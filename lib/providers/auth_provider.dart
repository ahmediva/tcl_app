import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  TCLUser? _user;
  bool _isLoading = false;

  TCLUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  // Permission getters
  bool get canCreateArticles => _user?.canCreateArticles ?? false;
  bool get canEditArticles => _user?.canEditArticles ?? false;
  bool get canDeleteArticles => _user?.canDeleteArticles ?? false;
  bool get canManageUsers => _user?.canManageUsers ?? false;

  // User type getters
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isSupervisor => _user?.isSupervisor ?? false;
  bool get isControlAgent => _user?.isControlAgent ?? false;
  bool get isCollector => _user?.isCollector ?? false;
  // isConsultant n'existe plus dans le nouveau modèle

  // User info getters
  String get fullName => _user?.fullName ?? '';
  String get userCode => _user?.userCode ?? '';
  String get email => _user?.email ?? '';

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Initialize auth provider
  Future<void> initialize() async {
    try {
      // Test connection first
      await AuthService().testConnection();
      print('✅ Database connection successful');
      // Create test user for mohamed@tcl.tn
      await AuthService().createTestUser();
      // Create test citizen for ahmedhajjjem01@gmail.com
      await AuthService().createTestCitizen();
    } catch (e) {
      print('❌ Initialization error: $e');
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    isLoading = true;
    try {
      final user = await AuthService().login(email, password);
      if (user != null) {
        _user = user;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    } finally {
      isLoading = false;
    }
    return false;
  }

  

  // Register new user (admin only)
  Future<bool> registerUser({
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
    if (!canManageUsers) {
      print('Insufficient permissions to create users');
      return false;
    }

    isLoading = true;
    try {
      final user = await AuthService().registerUser(
        userCode: userCode,
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        agentType: agentType,
        agentLevel: agentLevel,
        phone: phone,
        address: address,
        employeeId: employeeId,
        department: department,
        position: position,
        assignedArrondissement: assignedArrondissement,
        assignedCommune: assignedCommune,
        customPermissions: customPermissions,
      );
      
      if (user != null) {
        // Don't set as current user, just return success
        return true;
      }
    } catch (e) {
      print('User registration error: $e');
    } finally {
      isLoading = false;
    }
    return false;
  }

  // Check permission
  Future<bool> hasPermission(String permission) async {
    try {
      return await AuthService().hasPermission(permission);
    } catch (e) {
      print('Permission check error: $e');
      return false;
    }
  }

  // Get assigned articles
  Future<List<Map<String, dynamic>>> getAssignedArticles() async {
    try {
      return await AuthService().getAssignedArticles();
    } catch (e) {
      print('Error getting assigned articles: $e');
      return [];
    }
  }

  // Get articles by zone (simplified)
  Future<List<Map<String, dynamic>>> getArticlesByZone(String? zone) async {
    try {
      return await AuthService().getArticlesByZone(zone);
    } catch (e) {
      print('Error getting articles by zone: $e');
      return [];
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    try {
      final success = await AuthService().updateProfile(updates);
      if (success) {
        // Refresh user data
        final updatedUser = await AuthService().getCurrentUser();
        if (updatedUser != null) {
          _user = updatedUser;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      print('Profile update error: $e');
      return false;
    }
  }

  // Refresh user data
  Future<void> refreshUser() async {
    try {
      final user = await AuthService().getCurrentUser();
      if (user != null) {
        _user = user;
        notifyListeners();
      }
    } catch (e) {
      print('User refresh error: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await AuthService().logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
      // Force logout even if there's an error
      _user = null;
      notifyListeners();
    }
  }

  // Clear user data (for testing or error recovery)
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
