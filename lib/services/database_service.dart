import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/etablissement_model.dart';

class DatabaseService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  Future<List<EtablissementModel>> getEtablissements() async {
    try {
      final data = await _supabase.from('etablissements').select();
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching etablissements: $e');
      return [];
    }
  }

  Future<EtablissementModel?> addEtablissement(EtablissementModel etablissement) async {
    try {
      final data = await _supabase.from('etablissements').insert(etablissement.toJson()).select();
      if (data.isNotEmpty) {
        return EtablissementModel.fromJson(data.first);
      }
    } catch (e) {
      print('Error adding etablissement: $e');
    }
    return null;
  }

  Future<bool> updateEtablissement(EtablissementModel etablissement) async {
    try {
      await _supabase.from('etablissements').update(etablissement.toJson()).eq('id', etablissement.id);
      return true;
    } catch (e) {
      print('Error updating etablissement: $e');
      return false;
    }
  }

  Future<bool> deleteEtablissement(String id) async {
    try {
      await _supabase.from('etablissements').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting etablissement: $e');
      return false;
    }
  }
}
