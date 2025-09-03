import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Get current authenticated user
  TCLUser? get currentUser => _supabase.auth.currentUser != null ? _getCurrentUserFromAuth() : null;

  // Login with email and password
  Future<TCLUser?> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('Login response user: ${response.user}');
      if (response.user != null) {
        // Fetch user data from our users table
        final userData = await _supabase
            .from('users')
            .select()
            .eq('email', email)
            .eq('is_active', true)
            .single();

        print('User data fetched: $userData');

        // Update last login
        await _supabase
            .from('users')
            .update({'last_login': DateTime.now().toIso8601String()})
            .eq('id', userData['id']);

        return TCLUser.fromJson(userData);
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  // Login with username and password (alternative method)
  Future<TCLUser?> loginWithUsername(String username, String password) async {
    try {
      // First find user by username
      final userData = await _supabase
          .from('users')
          .select()
          .eq('username', username)
          .eq('is_active', true)
          .single();

      if (userData != null) {
        // Now try to authenticate with email
        return await login(userData['email'], password);
      }
    } catch (e) {
      print('Username login error: $e');
    }
    return null;
  }

  // Public registration method (no admin required)
  Future<bool> registerPublicUser({
    required String userCode,
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String agentType = 'CONSULTANT',
    String agentLevel = 'JUNIOR',
  }) async {
    try {
      // Create user in Supabase Auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'user_code': userCode,
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'agent_type': agentType,
          'agent_level': agentLevel,
        },
      );

      if (response.user != null) {
        // Set default permissions based on agent type
        final permissions = _getDefaultPermissions(agentType);

        // Create user in our users table
        await _supabase.from('users').insert({
          'id': response.user!.id,
          'user_code': userCode,
          'username': username,
          'email': email,
          'password_hash': password, // In production, this should be hashed
          'first_name': firstName,
          'last_name': lastName,
          'agent_type': agentType,
          'agent_level': agentLevel,
          'can_create_articles': permissions['can_create_articles'] ?? false,
          'can_edit_articles': permissions['can_edit_articles'] ?? false,
          'can_delete_articles': permissions['can_delete_articles'] ?? false,
          'can_view_reports': permissions['can_view_reports'] ?? false,
          'can_export_data': permissions['can_export_data'] ?? false,
          'can_manage_users': permissions['can_manage_users'] ?? false,
          'is_active': false, // Requires admin activation
          'is_verified': false, // Requires email verification
        });

        return true;
      }
    } catch (e) {
      print('Public registration error: $e');
      rethrow;
    }
    return false;
  }

  // Register new user (admin only)
  Future<TCLUser?> registerUser({
    required String userCode,
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String agentType,
    String agentLevel = 'JUNIOR',
    String? phone,
    String? address,
    String? employeeId,
    String? department,
    String? position,
    String? assignedArrondissement,
    String? assignedCommune,
    Map<String, bool>? customPermissions,
  }) async {
    try {
      // Check if current user is admin
      final currentUser = await getCurrentUser();
      if (currentUser == null || !currentUser.permissions.canManageUsers) {
        throw Exception('Insufficient permissions to create users');
      }

      // Create user in Supabase Auth
      final response = await _supabase.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: true,
        ),
      );

      if (response.user != null) {
        // Set default permissions based on agent type
        final permissions = _getDefaultPermissions(agentType);
        if (customPermissions != null) {
          permissions.addAll(customPermissions);
        }

        // Create user in our users table
        final userData = await _supabase.from('users').insert({
          'id': response.user!.id,
          'user_code': userCode,
          'username': username,
          'email': email,
          'password_hash': password, // In production, this should be hashed
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'address': address,
          'agent_type': agentType,
          'agent_level': agentLevel,
          'employee_id': employeeId,
          'department': department,
          'position': position,
          'assigned_arrondissement': assignedArrondissement,
          'assigned_commune': assignedCommune,
          'can_create_articles': permissions['can_create_articles'] ?? false,
          'can_edit_articles': permissions['can_edit_articles'] ?? false,
          'can_delete_articles': permissions['can_delete_articles'] ?? false,
          'can_view_reports': permissions['can_view_reports'] ?? false,
          'can_export_data': permissions['can_export_data'] ?? false,
          'can_manage_users': permissions['can_manage_users'] ?? false,
          'is_active': true,
          'is_verified': true,
          'created_by': currentUser.id,
          'updated_by': currentUser.id,
        }).select().single();

        return TCLUser.fromJson(userData);
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
    return null;
  }

  // Get current user from database
  Future<TCLUser?> getCurrentUser() async {
    try {
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) return null;

      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', authUser.id)
          .eq('is_active', true)
          .single();

      return TCLUser.fromJson(userData);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Check if user has specific permission
  Future<bool> hasPermission(String permission) async {
    try {
      final user = await getCurrentUser();
      if (user == null) return false;
      
      return user.permissions.hasPermission(permission);
    } catch (e) {
      print('Permission check error: $e');
      return false;
    }
  }

  // Get articles assigned to current user
  Future<List<Map<String, dynamic>>> getAssignedArticles() async {
    try {
      final user = await getCurrentUser();
      if (user == null) return [];

      final response = await _supabase
          .from('article')
          .select()
          .eq('agent_user_id', user.id);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting assigned articles: $e');
      return [];
    }
  }

  // Get articles by geographic area
  Future<List<Map<String, dynamic>>> getArticlesByArea(String? arrondissement, String? commune) async {
    try {
      final user = await getCurrentUser();
      if (user == null) return [];

      var query = _supabase.from('article').select();
      
      if (arrondissement != null) {
        query = query.eq('art_arrond', arrondissement);
      }
      
      if (commune != null) {
        query = query.eq('art_commune', commune);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting articles by area: $e');
      return [];
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    try {
      final user = await getCurrentUser();
      if (user == null) return false;

      await _supabase
          .from('users')
          .update(updates)
          .eq('id', user.id);

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Update last login time
      final user = await getCurrentUser();
      if (user != null) {
        await _supabase
            .from('users')
            .update({'last_login': DateTime.now().toIso8601String()})
            .eq('id', user.id);
      }
      
      await _supabase.auth.signOut();
    } catch (e) {
      print('Logout error: $e');
      await _supabase.auth.signOut();
    }
  }

  // Get auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Helper method to get default permissions based on agent type
  Map<String, bool> _getDefaultPermissions(String agentType) {
    switch (agentType) {
      case 'ADMIN':
        return {
          'can_create_articles': true,
          'can_edit_articles': true,
          'can_delete_articles': true,
          'can_view_reports': true,
          'can_export_data': true,
          'can_manage_users': true,
        };
      case 'SUPERVISOR':
        return {
          'can_create_articles': true,
          'can_edit_articles': true,
          'can_delete_articles': true,
          'can_view_reports': true,
          'can_export_data': true,
          'can_manage_users': false,
        };
      case 'CONTROL_AGENT':
        return {
          'can_create_articles': true,
          'can_edit_articles': true,
          'can_delete_articles': false,
          'can_view_reports': true,
          'can_export_data': false,
          'can_manage_users': false,
        };
      case 'COLLECTOR':
        return {
          'can_create_articles': true,
          'can_edit_articles': true,
          'can_delete_articles': false,
          'can_view_reports': true,
          'can_export_data': false,
          'can_manage_users': false,
        };
      case 'CONSULTANT':
        return {
          'can_create_articles': false,
          'can_edit_articles': false,
          'can_delete_articles': false,
          'can_view_reports': true,
          'can_export_data': false,
          'can_manage_users': false,
        };
      default:
        return {
          'can_create_articles': false,
          'can_edit_articles': false,
          'can_delete_articles': false,
          'can_view_reports': false,
          'can_export_data': false,
          'can_manage_users': false,
        };
    }
  }

  // Helper method to get user from auth (for backward compatibility)
  TCLUser? _getCurrentUserFromAuth() {
    final authUser = _supabase.auth.currentUser;
    if (authUser == null) return null;
    
    // Return a minimal user object - this should be replaced with proper database lookup
    return TCLUser(
      id: authUser.id,
      userCode: '',
      username: authUser.email ?? '',
      email: authUser.email ?? '',
      passwordHash: '',
      firstName: '',
      lastName: '',
      agentType: 'UNKNOWN',
      agentLevel: 'JUNIOR',
      permissions: UserPermissions(
        canCreateArticles: false,
        canEditArticles: false,
        canDeleteArticles: false,
        canViewReports: false,
        canExportData: false,
        canManageUsers: false,
      ),
      isActive: true,
      isVerified: authUser.emailConfirmedAt != null,
      loginAttempts: 0,
      createdAt: DateTime.parse(authUser.createdAt),
      updatedAt: DateTime.parse(authUser.createdAt),
    );
  }
}
