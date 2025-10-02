import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/etablissement_model.dart';

class DatabaseService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Test database connection with better error handling
  Future<void> testConnection() async {
    try {
      print('🔗 Testing Supabase connection...');
      print('🔑 Using URL: ${SupabaseConfig.supabaseUrl}');
      print('🔑 Using Key: ${SupabaseConfig.supabaseKey.substring(0, 20)}...');
      
      // Test 1: Try to get any data from article table
      print('🧪 Test 1: Basic select query...');
      final response = await _supabase.from('article').select('ArtNouvCode').limit(1);
      print('✅ Test 1 successful! Response: $response');
      
      // Test 2: Try to get total count
      print('🧪 Test 2: Count all records...');
      final countResponse = await _supabase.from('article').select('ArtNouvCode');
      print('✅ Test 2 successful! Total records: ${countResponse.length}');
      
      // Test 3: Try to get specific fields
      print('🧪 Test 3: Select specific fields...');
      final fieldsResponse = await _supabase.from('article').select('ArtNouvCode, ArtNomCommerce, ArtRue').limit(3);
      print('✅ Test 3 successful! Fields response: $fieldsResponse');
      
    } catch (e) {
      print('❌ Connection failed: $e');
      print('🔍 Error details: ${e.toString()}');
      
      // Try to get more specific error information
      if (e.toString().contains('RLS') || e.toString().contains('policy')) {
        print('🚨 Row Level Security (RLS) issue detected!');
        print('💡 The article table may not allow anonymous access');
        print('🔧 Solution: Add RLS policy for anonymous users');
      } else if (e.toString().contains('permission') || e.toString().contains('denied')) {
        print('🚨 Permission denied!');
        print('💡 Check your Supabase key permissions');
      }
    }
  }

  // Etablissement operations
  Future<List<EtablissementModel>> getEtablissements() async {
    try {
      print('🔍 Fetching etablissements from Supabase...');
      final data = await _supabase.from('article').select();
      print('📊 Raw data received: ${data.length} records');
      if (data.isNotEmpty) {
        print('📋 First record sample: ${data.first}');
      }
      final etablissements = data.map((json) => EtablissementModel.fromJson(json)).toList();
      print('✅ Successfully converted ${etablissements.length} etablissements');
      return etablissements;
    } catch (e) {
      print('❌ Error fetching etablissements: $e');
      return [];
    }
  }

  Future<EtablissementModel?> getEtablissementByCode(String artNouvCode) async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .eq('ArtNouvCode', artNouvCode)
          .single();
      return EtablissementModel.fromJson(data);
    } catch (e) {
      print('Error fetching etablissement by code: $e');
      return null;
    }
  }

  Future<EtablissementModel?> addEtablissement(EtablissementModel etablissement) async {
    try {
      final data = await _supabase.from('article').insert(etablissement.toJson()).select();
      if (data.isNotEmpty) {
        return EtablissementModel.fromJson(data.first);
      }
    } catch (e) {
      print('Error adding etablissement: $e');
      print('Failed to insert data: ${etablissement.toJson()}');
    }
    return null;
  }

  Future<bool> updateEtablissement(EtablissementModel etablissement) async {
    try {
      await _supabase.from('article').update(etablissement.toJson()).eq('ArtNouvCode', etablissement.artNouvCode);
      return true;
    } catch (e) {
      print('Error updating etablissement: $e');
      return false;
    }
  }

  Future<bool> deleteEtablissement(String artNouvCode) async {
    try {
      await _supabase.from('article').delete().eq('ArtNouvCode', artNouvCode);
      return true;
    } catch (e) {
      print('Error deleting etablissement: $e');
      return false;
    }
  }

  // Additional Etablissement operations for better functionality
  Future<List<EtablissementModel>> getEtablissementsByArrondissement(String arrondissementCode) async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .eq('ArtArrond', arrondissementCode);
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching etablissements by arrondissement: $e');
      return [];
    }
  }

  Future<List<EtablissementModel>> searchEtablissements(String query) async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .or('ArtRue.ilike.%$query%,ArtNomCommerce.ilike.%$query%,ArtOccup.ilike.%$query%');
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error searching etablissements: $e');
      return [];
    }
  }

  Future<List<EtablissementModel>> getEtablissementsWithCoordinates() async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .not('ArtLatitude', 'is', null)
          .not('ArtLongitude', 'is', null);
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching etablissements with coordinates: $e');
      return [];
    }
  }

  Future<List<EtablissementModel>> getEtablissementsByEtat(int etat) async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .eq('ArtEtat', etat);
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching etablissements by etat: $e');
      return [];
    }
  }

  Future<List<EtablissementModel>> getEtablissementsByImposable(int imposable) async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .eq('ArtImp', imposable);
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching etablissements by imposable: $e');
      return [];
    }
  }

  // Statistics and analytics
  Future<Map<String, dynamic>> getEtablissementStats() async {
    try {
      final total = await _supabase.from('article').select('ArtNouvCode');
      final withCoordinates = await _supabase
          .from('article')
          .select('ArtNouvCode')
          .not('ArtLatitude', 'is', null)
          .not('ArtLongitude', 'is', null);
      final payantTaxe = await _supabase
          .from('article')
          .select('ArtNouvCode')
          .eq('ArtEtat', 1);

      return {
        'total': total.length,
        'withCoordinates': withCoordinates.length,
        'payantTaxe': payantTaxe.length,
        'arrondissements': EtablissementModel.arrondissements.length,
      };
    } catch (e) {
      print('Error fetching etablissement stats: $e');
      return {
        'total': 0,
        'withCoordinates': 0,
        'payantTaxe': 0,
        'arrondissements': EtablissementModel.arrondissements.length,
      };
    }
  }
}