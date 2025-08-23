import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/etablissement_model.dart';
import '../models/arrondissement_model.dart';
import '../models/commune_model.dart';
import '../models/categorie_tcl_model.dart';
import '../models/delegation_model.dart';

class DatabaseService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Etablissement operations
  Future<List<EtablissementModel>> getEtablissements() async {
    try {
      final data = await _supabase.from('article').select();
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching etablissements: $e');
      return [];
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
      await _supabase.from('article').update(etablissement.toJson()).eq('art_nouv_code', etablissement.artNouvCode);
      return true;
    } catch (e) {
      print('Error updating etablissement: $e');
      return false;
    }
  }

  Future<bool> deleteEtablissement(String artNouvCode) async {
    try {
      await _supabase.from('article').delete().eq('art_nouv_code', artNouvCode);
      return true;
    } catch (e) {
      print('Error deleting etablissement: $e');
      return false;
    }
  }

  // Arrondissement operations
  Future<List<ArrondissementModel>> getArrondissements() async {
    try {
      final data = await _supabase.from('arrondissement').select().order('libelle');
      return data.map((json) => ArrondissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching arrondissements: $e');
      return [];
    }
  }

  Future<List<ArrondissementModel>> getArrondissementsActifs() async {
    try {
      final data = await _supabase
          .from('arrondissement')
          .select()
          .eq('code_etat', 'A')
          .order('libelle');
      return data.map((json) => ArrondissementModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching active arrondissements: $e');
      return [];
    }
  }

  Future<ArrondissementModel?> getArrondissementByCode(String code) async {
    try {
      final data = await _supabase
          .from('arrondissement')
          .select()
          .eq('code', code)
          .single();
      return ArrondissementModel.fromJson(data);
    } catch (e) {
      print('Error fetching arrondissement by code: $e');
      return null;
    }
  }

  Future<ArrondissementModel?> addArrondissement(ArrondissementModel arrondissement) async {
    try {
      final data = await _supabase
          .from('arrondissement')
          .insert(arrondissement.toJson())
          .select();
      if (data.isNotEmpty) {
        return ArrondissementModel.fromJson(data.first);
      }
    } catch (e) {
      print('Error adding arrondissement: $e');
    }
    return null;
  }

  Future<bool> updateArrondissement(ArrondissementModel arrondissement) async {
    try {
      await _supabase
          .from('arrondissement')
          .update(arrondissement.toJson())
          .eq('code', arrondissement.code);
      return true;
    } catch (e) {
      print('Error updating arrondissement: $e');
      return false;
    }
  }

  Future<bool> deleteArrondissement(String code) async {
    try {
      await _supabase.from('arrondissement').delete().eq('code', code);
      return true;
    } catch (e) {
      print('Error deleting arrondissement: $e');
      return false;
    }
  }

  // Commune operations
  Future<List<CommuneModel>> getCommunes() async {
    try {
      final data = await _supabase.from('commune').select().order('libelle');
      return data.map((json) => CommuneModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching communes: $e');
      return [];
    }
  }

  Future<CommuneModel?> getCommuneByCode(String codeM) async {
    try {
      final data = await _supabase
          .from('commune')
          .select()
          .eq('code_m', codeM)
          .single();
      return CommuneModel.fromJson(data);
    } catch (e) {
      print('Error fetching commune by code: $e');
      return null;
    }
  }

  Future<CommuneModel?> addCommune(CommuneModel commune) async {
    try {
      final data = await _supabase
          .from('commune')
          .insert(commune.toJson())
          .select();
      if (data.isNotEmpty) {
        return CommuneModel.fromJson(data.first);
      }
    } catch (e) {
      print('Error adding commune: $e');
    }
    return null;
  }

  Future<bool> updateCommune(CommuneModel commune) async {
    try {
      await _supabase
          .from('commune')
          .update(commune.toJson())
          .eq('code_m', commune.codeM);
      return true;
    } catch (e) {
      print('Error updating commune: $e');
      return false;
    }
  }

  Future<bool> deleteCommune(String codeM) async {
    try {
      await _supabase.from('commune').delete().eq('code_m', codeM);
      return true;
    } catch (e) {
      print('Error deleting commune: $e');
      return false;
    }
  }

  // CategorieTCL operations
  Future<List<CategorieTclModel>> getCategoriesTcl() async {
    try {
      final data = await _supabase.from('categorietcl').select().order('numero');
      return data.map((json) => CategorieTclModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories TCL: $e');
      return [];
    }
  }

  Future<List<CategorieTclModel>> getCategoriesTclActives() async {
    try {
      final data = await _supabase
          .from('categorietcl')
          .select()
          .eq('cat_etat', 'A')
          .order('numero');
      return data.map((json) => CategorieTclModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching active categories TCL: $e');
      return [];
    }
  }

  Future<CategorieTclModel?> getCategorieTclByNumero(int numero) async {
    try {
      final data = await _supabase
          .from('categorietcl')
          .select()
          .eq('numero', numero)
          .single();
      return CategorieTclModel.fromJson(data);
    } catch (e) {
      print('Error fetching categorie TCL by numero: $e');
      return null;
    }
  }

  Future<CategorieTclModel?> addCategorieTcl(CategorieTclModel categorie) async {
    try {
      final data = await _supabase
          .from('categorietcl')
          .insert(categorie.toJson())
          .select();
      if (data.isNotEmpty) {
        return CategorieTclModel.fromJson(data.first);
      }
    } catch (e) {
      print('Error adding categorie TCL: $e');
    }
    return null;
  }

  Future<bool> updateCategorieTcl(CategorieTclModel categorie) async {
    try {
      await _supabase
          .from('categorietcl')
          .update(categorie.toJson())
          .eq('numero', categorie.numero);
      return true;
    } catch (e) {
      print('Error updating categorie TCL: $e');
      return false;
    }
  }

  Future<bool> deleteCategorieTcl(int numero) async {
    try {
      await _supabase.from('categorietcl').delete().eq('numero', numero);
      return true;
    } catch (e) {
      print('Error deleting categorie TCL: $e');
      return false;
    }
  }

  // Delegation operations
  Future<List<DelegationModel>> getDelegations() async {
    try {
      final data = await _supabase.from('delegation').select().order('LibelleFr');
      return data.map((json) => DelegationModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching delegations: $e');
      return [];
    }
  }

  Future<DelegationModel?> addDelegation(DelegationModel delegation) async {
    try {
      final data = await _supabase
          .from('delegation')
          .insert(delegation.toJson())
          .select();
      if (data.isNotEmpty) {
        return DelegationModel.fromJson(data.first);
      }
    } catch (e) {
      print('Error adding delegation: $e');
    }
    return null;
  }

  Future<bool> updateDelegation(DelegationModel delegation) async {
    try {
      await _supabase
          .from('delegation')
          .update(delegation.toJson())
          .eq('CodeDeleg', delegation.codeDeleg);
      return true;
    } catch (e) {
      print('Error updating delegation: $e');
      return false;
    }
  }

  Future<bool> deleteDelegation(int codeDeleg) async {
    try {
      await _supabase.from('delegation').delete().eq('CodeDeleg', codeDeleg);
      return true;
    } catch (e) {
      print('Error deleting delegation: $e');
      return false;
    }
  }
}
