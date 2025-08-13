import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('Login response user: ${response.user}');
      if (response.user != null) {
        // Fetch user data from database
        final userData = await _supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .single();

        print('User data fetched: $userData');

        return UserModel.fromJson(userData);
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  Future<UserModel?> register(String email, String password, String name) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
        },
      );

      print('Registration response: $response');

      // Supabase AuthResponse does not have 'error' property, check for error differently
      if (response.user == null) {
        print('Registration failed: No user returned');
        return null;
      }

      // Check if user is confirmed (email confirmed)
      final userConfirmed = response.user!.emailConfirmedAt != null;

      if (!userConfirmed) {
        print('Registration pending email confirmation.');
        // You can throw or return a special value here to indicate pending confirmation
        return null;
      }

      // Create user in database
      try {
        await _supabase.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': name,
          'role': 'agent', // Default role
        });
      } catch (e) {
        print('Error inserting user into database: $e');
        return null;
      }

      return UserModel(
        id: response.user!.id,
        email: email,
        name: name,
        role: 'agent',
      );
    } catch (e) {
      print('Registration error: $e');
    }
    return null;
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
