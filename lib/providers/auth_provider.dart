import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  UserModel? get currentUser => _user; // Add currentUser property
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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

  // Register method
  Future<bool> register(String email, String password, String name) async {
    isLoading = true;
    try {
      final user = await AuthService().register(email, password, name);
      if (user != null) {
        _user = user;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Registration error: $e');
    } finally {
      isLoading = false;
    }
    return false;
  }

  // Logout method
  Future<void> logout() async {
    await AuthService().logout();
    _user = null;
    notifyListeners();
  }
}
