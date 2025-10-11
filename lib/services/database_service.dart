import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/etablissement_model.dart';

class DatabaseService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Get all establishments
  Future<List<EtablissementModel>> getEtablissements() async {
    try {
      final data = await _supabase.from('article').select();
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching etablissements: $e');
      return [];
    }
  }

  // Get establishment by code
  Future<EtablissementModel?> getEtablissementByCode(String artNouvCode) async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .eq('artnouvcode', artNouvCode)
          .single();
      return EtablissementModel.fromJson(data);
    } catch (e) {
      print('Error fetching etablissement by code: $e');
      return null;
    }
  }

  // Add new establishment
  Future<EtablissementModel?> addEtablissement(EtablissementModel etablissement) async {
    try {
      final data = await _supabase.from('article').insert(etablissement.toJson()).select();
      if (data.isNotEmpty) {
        return EtablissementModel.fromJson(data.first);
      }
      return null;
    } catch (e) {
      print('Error adding etablissement: $e');
      rethrow;
    }
  }

  // Update establishment
  Future<bool> updateEtablissement(EtablissementModel etablissement) async {
    try {
      await _supabase.from('article').update(etablissement.toJson()).eq('artnouvcode', etablissement.artNouvCode);
      return true;
    } catch (e) {
      print('Error updating etablissement: $e');
      return false;
    }
  }

  // Delete establishment
  Future<bool> deleteEtablissement(String artNouvCode) async {
    try {
      await _supabase.from('article').delete().eq('artnouvcode', artNouvCode);
      return true;
    } catch (e) {
      print('Error deleting etablissement: $e');
      return false;
    }
  }


 


  // Get establishments with coordinates
  Future<List<EtablissementModel>> getEtablissementsWithCoordinates() async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .not('artlatitude', 'is', null)
          .not('artlongitude', 'is', null);
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching etablissements with coordinates: $e');
      return [];
    }
  }

  // Get establishment statistics
  Future<Map<String, dynamic>> getEtablissementStats() async {
    try {
      final total = await _supabase.from('article').select('artnouvcode');
      final payantTaxe = await _supabase.from('article').select('artnouvcode').eq('artetat', 1);
      
      return {
        'total': total.length,
        'payantTaxe': payantTaxe.length,
       
      };
    } catch (e) {
      print('Error fetching etablissement stats: $e');
      return {
        'total': 0,
        'payantTaxe': 0,
  
      };
    }
  }

  // Search establishments by multiple criteria
  Future<List<EtablissementModel>> searchEtablissements(String query) async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .or('artnouvcode.ilike.%$query%,artnomcommerce.ilike.%$query%,artproprietaire.ilike.%$query%,artredcode.ilike.%$query%,artoccup.ilike.%$query%,artadresse.ilike.%$query%');
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error searching etablissements: $e');
      return [];
    }
  }

  // Test database connection
  Future<void> testConnection() async {
    try {
      await _supabase.from('article').select('artnouvcode').limit(1);
      print('Database connection successful');
    } catch (e) {
      print('Database connection failed: $e');
    }
  }
}