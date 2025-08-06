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

      if (response.user != null) {
        // Fetch user data from database
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();

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
          'name': name,
        },
      );

      if (response.user != null) {
        // Create user in database
        await _supabase.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'name': name,
          'role': 'agent', // Default role
        });

        return UserModel(
          id: response.user!.id,
          email: email,
          name: name,
          role: 'agent',
        );
      }
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
