import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/citizen_model.dart';
import '../models/etablissement_model.dart';

class CitizenService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Register a new citizen
  Future<TCLCitizen?> registerCitizen({
    required String cin,
    required String nom,
    required String prenom,
    required String email,
    required String password,
    String? numeroTelephone,
  }) async {
    try {
      print('🔄 Registering citizen: $email');
      
      // Hash password
      final hashedPassword = _simpleHash(password);
      
      // Check if email already exists
      final existingEmail = await _supabase
          .from('citizens')
          .select('email')
          .eq('email', email)
          .maybeSingle();
      
      if (existingEmail != null) {
        print('❌ Email already exists: $email');
        throw Exception('Cet email est déjà utilisé');
      }
      
      // Check if CIN already exists
      final existingCin = await _supabase
          .from('citizens')
          .select('cin')
          .eq('cin', cin)
          .maybeSingle();
      
      if (existingCin != null) {
        print('❌ CIN already exists: $cin');
        throw Exception('Ce CIN est déjà utilisé');
      }
      
      // Insert citizen
      final response = await _supabase.from('citizens').insert({
        'cin': cin,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'password_hash': hashedPassword,
        'numero_telephone': numeroTelephone,
        'is_active': true,
        'is_verified': false,
      }).select().single();
      
      print('✅ Citizen registered successfully: ${response['email']}');
      return TCLCitizen.fromJson(response);
    } catch (e) {
      print('❌ Error registering citizen: $e');
      if (e.toString().contains('row-level security')) {
        throw Exception('Erreur de sécurité. Veuillez contacter l\'administrateur.');
      }
      rethrow;
    }
  }

  // Login citizen
  Future<TCLCitizen?> loginCitizen(String email, String password) async {
    try {
      print('🔐 Attempting login for citizen: $email');
      
      // Get citizen by email
      final response = await _supabase
          .from('citizens')
          .select()
          .eq('email', email)
          .eq('is_active', true)
          .maybeSingle();
      
      if (response == null) {
        print('❌ Citizen not found: $email');
        return null;
      }
      
      print('📋 Citizen data found: ${response['email']}');
      print('🔍 Stored password hash: ${response['password_hash']}');
      print('🔍 Computed password hash: ${_simpleHash(password)}');
      
      // Check password (support both hashed and plain text for backward compatibility)
      bool passwordMatch = response['password_hash'] == _simpleHash(password) ||
                         response['password_hash'] == password;
      
      if (passwordMatch) {
        print('✅ Password correct for citizen: $email');
        
        // Update last login
        await _supabase
            .from('citizens')
            .update({'last_login': DateTime.now().toIso8601String()})
            .eq('id', response['id']);
        
        // Create citizen object
        final citizen = TCLCitizen.fromJson(response);
        print('👤 Citizen created: ${citizen.fullName}');
        return citizen;
      } else {
        print('❌ Password incorrect for citizen: $email');
        return null;
      }
    } catch (e) {
      print('❌ Login error for citizen $email: $e');
      return null;
    }
  }

  // Get establishments owned by citizen (using CIN)
  Future<List<EtablissementModel>> getCitizenEstablishments(String cin) async {
    try {
      print('📋 Fetching establishments for citizen CIN: $cin');
      
      // Get establishments where artredcode (owner CIN) matches citizen CIN
      final response = await _supabase
          .from('article')
          .select()
          .eq('artredcode', cin);
      
      print('📊 Found ${response.length} establishments for citizen');
      
      return response.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error fetching citizen establishments: $e');
      return [];
    }
  }

  // Check if CIN exists in establishments
  Future<bool> hasEstablishments(String cin) async {
    try {
      final response = await _supabase
          .from('article')
          .select('artnouvcode')
          .eq('artredcode', cin)
          .limit(1);
      
      return response.isNotEmpty;
    } catch (e) {
      print('❌ Error checking establishments for CIN $cin: $e');
      return false;
    }
  }

  // Update citizen profile
  Future<bool> updateCitizenProfile(String citizenId, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('citizens')
          .update(updates)
          .eq('id', citizenId);
      
      print('✅ Citizen profile updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating citizen profile: $e');
      return false;
    }
  }

  // Reset password for citizen
  Future<bool> resetCitizenPassword(String email, String newPassword) async {
    try {
      print('🔄 Resetting password for citizen: $email');
      
      // Check if citizen exists
      final citizenData = await _supabase
          .from('citizens')
          .select('id, email')
          .eq('email', email)
          .maybeSingle();
      
      if (citizenData == null) {
        print('❌ Citizen not found: $email');
        return false;
      }
      
      // Update password
      await _supabase
          .from('citizens')
          .update({'password_hash': _simpleHash(newPassword)})
          .eq('email', email);
      
      print('✅ Citizen password updated successfully');
      return true;
    } catch (e) {
      print('❌ Error resetting citizen password: $e');
      return false;
    }
  }

  // Simple hash function (same as AuthService)
  String _simpleHash(String password) {
    // Simple hash for development - in production use bcrypt
    // Using a more consistent hash method
    return password.length.toString() + password.hashCode.toString();
  }

  // Test connection
  Future<void> testConnection() async {
    try {
      print('🔗 Testing citizen service connection...');
      final response = await _supabase.from('citizens').select('count').limit(1);
      print('✅ Citizen service connection successful');
    } catch (e) {
      print('❌ Citizen service connection error: $e');
    }
  }
}
