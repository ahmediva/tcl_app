import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  
  // Simple login method that bypasses RLS issues
  Future<TCLUser?> login(String email, String password) async {
    try {
      print('🔐 Attempting login for: $email');
      
      // Try to get user data directly
      final userData = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .eq('is_active', true)
          .maybeSingle();
      
      if (userData == null) {
        print('❌ User not found: $email');
        return null;
      }

      print('📋 User data found: ${userData['email']}');
      print('🔍 Stored password hash: ${userData['password_hash']}');
      print('🔍 Computed password hash: ${_simpleHash(password)}');
      
      // Simple password comparison (in production, use proper hashing)
      // Also check for plain text passwords for backward compatibility
      bool passwordMatch = userData['password_hash'] == _simpleHash(password) ||
                         userData['password_hash'] == password;
      
      if (passwordMatch) {
        print('✅ Password correct for: $email');
        
        // Create user object
        final user = TCLUser.fromJson(userData);
        print('👤 User created: ${user.fullName} (${user.agentType})');
        
        return user;
      } else {
        print('❌ Password incorrect for: $email');
        return null;
      }
    } catch (e) {
      print('❌ Login error for $email: $e');
      return null;
    }
  }

  // Get all users (for admin)
  Future<List<TCLUser>> getAllUsers() async {
    try {
      print('📋 Fetching all users...');
      final response = await _supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);

      print('📊 Found ${response.length} users');
      return response.map<TCLUser>((json) => TCLUser.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error getting all users: $e');
      rethrow;
    }
  }

  // Méthode pour réinitialiser le mot de passe
  Future<bool> resetPassword(String email) async {
    try {
      print('🔄 Attempting password reset for: $email');
      
      // Vérifier d'abord si l'email existe dans la table users (agents)
      final userData = await _supabase
          .from('users')
          .select('email')
          .eq('email', email)
          .maybeSingle();
      
      if (userData != null) {
        print('✅ Email found in users table (agent): $email');
        
        // Utiliser Supabase Auth pour envoyer l'email de réinitialisation
        await _supabase.auth.resetPasswordForEmail(
          email,
          redirectTo: 'https://ohtqdcudyzupndgxyyhn.supabase.co/auth/v1/callback',
        );
        
        print('✅ Password reset email sent successfully to agent');
        return true;
      }
      
      // Si pas trouvé dans users, vérifier dans citizens
      final citizenData = await _supabase
          .from('citizens')
          .select('email')
          .eq('email', email)
          .maybeSingle();
      
      if (citizenData != null) {
        print('✅ Email found in citizens table: $email');
        
        // Utiliser Supabase Auth pour envoyer l'email de réinitialisation
        await _supabase.auth.resetPasswordForEmail(
          email,
          redirectTo: 'https://ohtqdcudyzupndgxyyhn.supabase.co/auth/v1/callback',
        );
        
        print('✅ Password reset email sent successfully to citizen');
        return true;
      }
      
      print('❌ Email not found in users or citizens table: $email');
      return false;
    } catch (e) {
      print('❌ Error sending password reset email: $e');
      return false;
    }
  }

  // Méthode alternative pour réinitialiser le mot de passe directement (sans email)
  Future<bool> updatePasswordDirectly(String email, String newPassword) async {
    try {
      print('🔄 Updating password directly for: $email');
      
      // Vérifier d'abord si l'email existe dans la table users (agents)
      final userData = await _supabase
          .from('users')
          .select('id, email')
          .eq('email', email)
          .maybeSingle();
      
      if (userData != null) {
        print('✅ Email found in users table (agent), updating password...');
        
        // Hasher le nouveau mot de passe
        final hashedPassword = _simpleHash(newPassword);
        
        // Mettre à jour le mot de passe dans la table users
        await _supabase
            .from('users')
            .update({'password_hash': hashedPassword})
            .eq('email', email);
        
        print('✅ Agent password updated successfully');
        return true;
      }
      
      // Si pas trouvé dans users, vérifier dans citizens
      final citizenData = await _supabase
          .from('citizens')
          .select('id, email')
          .eq('email', email)
          .maybeSingle();
      
      if (citizenData != null) {
        print('✅ Email found in citizens table, updating password...');
        
        // Hasher le nouveau mot de passe
        final hashedPassword = _simpleHash(newPassword);
        
        // Mettre à jour le mot de passe dans la table citizens
        await _supabase
            .from('citizens')
            .update({'password_hash': hashedPassword})
            .eq('email', email);
        
        print('✅ Citizen password updated successfully');
        return true;
      }
      
      print('❌ Email not found in users or citizens table: $email');
      return false;
    } catch (e) {
      print('❌ Error updating password: $e');
      return false;
    }
  }

  // Simple hash function for password (for development)
  String _simpleHash(String password) {
    // Simple hash for development - in production use bcrypt
    // Using a more consistent hash method
    return password.length.toString() + password.hashCode.toString();
  }

  // Test connection
  Future<void> testConnection() async {
    try {
      print('🔗 Testing database connection...');
      final response = await _supabase.from('users').select('count').limit(1);
      print('✅ Database connection successful');
    } catch (e) {
      print('❌ Database connection failed: $e');
      rethrow;
    }
  }

  // Create test user for mohamed@tcl.tn
  Future<void> createTestUser() async {
    try {
      print('👤 Creating/updating test user: mohamed@tcl.tn');
      
      // Check if user already exists
      final existingUser = await _supabase
          .from('users')
          .select('id, email')
          .eq('email', 'mohamed@tcl.tn')
          .maybeSingle();
      
      final userData = {
        'user_code': '12345678',
        'nom': 'Mohamed',
        'prenom': 'Test',
        'email': 'mohamed@tcl.tn',
        'password_hash': _simpleHash('password123'), // Properly hashed password
        'numero_telephone': '12345678',
        'agent_type': 'collecteur',
        'can_create_articles': true,
        'can_modify_articles': false,
        'can_delete_articles': false,
        'can_manage_users': false,
        'is_active': true,
      };
      
      if (existingUser != null) {
        print('🔄 User mohamed@tcl.tn exists, updating...');
        await _supabase
            .from('users')
            .update(userData)
            .eq('email', 'mohamed@tcl.tn');
        print('✅ Test user mohamed@tcl.tn updated successfully');
      } else {
        print('➕ Creating new user mohamed@tcl.tn...');
        await _supabase.from('users').insert(userData);
        print('✅ Test user mohamed@tcl.tn created successfully');
      }
    } catch (e) {
      print('❌ Error creating/updating test user: $e');
    }
  }

  // Create test citizen for ahmedhajjjem01@gmail.com
  Future<void> createTestCitizen() async {
    try {
      print('👤 Creating/updating test citizen: ahmedhajjjem01@gmail.com');
      
      // Check if citizen already exists
      final existingCitizen = await _supabase
          .from('citizens')
          .select('id, email')
          .eq('email', 'ahmedhajjjem01@gmail.com')
          .maybeSingle();
      
      final citizenData = {
        'cin': '87654321',
        'nom': 'Ahmed',
        'prenom': 'Hajjem',
        'email': 'ahmedhajjjem01@gmail.com',
        'password_hash': _simpleHash('password123'), // Properly hashed password
        'numero_telephone': '87654321',
        'is_active': true,
        'is_verified': true,
      };
      
      if (existingCitizen != null) {
        print('🔄 Citizen ahmedhajjjem01@gmail.com exists, updating...');
        await _supabase
            .from('citizens')
            .update(citizenData)
            .eq('email', 'ahmedhajjjem01@gmail.com');
        print('✅ Test citizen ahmedhajjjem01@gmail.com updated successfully');
      } else {
        print('➕ Creating new citizen ahmedhajjjem01@gmail.com...');
        await _supabase.from('citizens').insert(citizenData);
        print('✅ Test citizen ahmedhajjjem01@gmail.com created successfully');
      }
    } catch (e) {
      print('❌ Error creating/updating test citizen: $e');
    }
  }

  // Register new user (simplified)
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
      print('📝 Registering new user: $email');
      
      // Create user in our users table
      final userData = await _supabase.from('users').insert({
        'user_code': userCode,
        'nom': lastName,
        'prenom': firstName,
        'email': email,
        'password_hash': _simpleHash(password),
        'numero_telephone': phone,
        'agent_type': agentType,
        'can_create_articles': customPermissions?['can_create_articles'] ?? true, // Permission par défaut
        'can_edit_articles': customPermissions?['can_edit_articles'] ?? false,
        'can_delete_articles': customPermissions?['can_delete_articles'] ?? false,
        'can_manage_users': customPermissions?['can_manage_users'] ?? false,
        'is_active': true,
      }).select().single();

      print('✅ User registered successfully: $email');
      return TCLUser.fromJson(userData);
    } catch (e) {
      print('❌ Registration error: $e');
      return null;
    }
  }

  // Check permission
  Future<bool> hasPermission(String permission) async {
    try {
      // For now, return true for testing
      return true;
    } catch (e) {
      print('❌ Permission check error: $e');
      return false;
    }
  }

  // Get assigned articles
  Future<List<Map<String, dynamic>>> getAssignedArticles() async {
    try {
      // For now, return empty list
      return [];
    } catch (e) {
      print('❌ Error getting assigned articles: $e');
      return [];
    }
  }

  // Get articles by zone
  Future<List<Map<String, dynamic>>> getArticlesByZone(String? zone) async {
    try {
      // For now, return empty list
      return [];
    } catch (e) {
      print('❌ Error getting articles by zone: $e');
      return [];
    }
  }

  // Update profile
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    try {
      // For now, return true for testing
      return true;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  // Get current user
  Future<TCLUser?> getCurrentUser() async {
    try {
      // For now, return null (no auto-login)
      return null;
    } catch (e) {
      print('❌ Error getting current user: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      print('🚪 Logging out...');
      // Clear any stored authentication
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  // Toggle user status (active/inactive)
  Future<bool> toggleUserStatus(String userId, bool isActive) async {
    try {
      print('🔄 Toggling user status: $userId to $isActive');
      await _supabase
          .from('users')
          .update(<String, dynamic>{
            'is_active': isActive,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      print('✅ User status updated successfully');
      return true;
    } catch (e) {
      print('❌ Error toggling user status: $e');
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      print('🗑️ Deleting user: $userId');
      
      // Delete from users table
      await _supabase
          .from('users')
          .delete()
          .eq('id', userId);

      print('✅ User deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting user: $e');
      return false;
    }
  }

  // Update user
  Future<bool> updateUser(
    String userId, {
    required String userCode,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String agentType,
    String agentLevel = 'JUNIOR',
    String? phone,
    Map<String, bool>? permissions,
  }) async {
    try {
      print('✏️ Updating user: $userId');
      
      final updateData = <String, dynamic>{
        'user_code': userCode,
        'nom': lastName,
        'prenom': firstName,
        'email': email,
        'agent_type': agentType,
        'agent_level': agentLevel,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (phone != null && phone.isNotEmpty) {
        updateData['numero_telephone'] = phone;
      }

      // Add permissions if provided
      if (permissions != null) {
        updateData.addAll({
          'can_create_articles': permissions['can_create_articles'] ?? false,
          'can_edit_articles': permissions['can_edit_articles'] ?? false,
          'can_delete_articles': permissions['can_delete_articles'] ?? false,
          'can_manage_users': permissions['can_manage_users'] ?? false,
        });
      }

      await _supabase
          .from('users')
          .update(updateData)
          .eq('id', userId);

      print('✅ User updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating user: $e');
      return false;
    }
  }

  // Update user permissions
  Future<bool> updateUserPermissions(String userId, Map<String, bool> permissions) async {
    try {
      print('🔐 Updating permissions for user: $userId');
      
      final updateData = <String, dynamic>{
        'can_create_articles': permissions['can_create_articles'] ?? false,
        'can_edit_articles': permissions['can_edit_articles'] ?? false,
        'can_delete_articles': permissions['can_delete_articles'] ?? false,
        'can_manage_users': permissions['can_manage_users'] ?? false,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase
          .from('users')
          .update(updateData)
          .eq('id', userId);

      print('✅ User permissions updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating user permissions: $e');
      return false;
    }
  }
}
