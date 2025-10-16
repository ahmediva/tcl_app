import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/etablissement_model.dart';

class DatabaseService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Test connection
  Future<void> testConnection() async {
    try {
      await _supabase.from('article').select('artnouvcode').limit(1);
      print('Database connection successful');
    } catch (e) {
      print('Database connection failed: $e');
      rethrow;
    }
  }

  // Get all establishments (filtered by user role)
  Future<List<EtablissementModel>> getEtablissements({String? currentUserAgent, String? currentUserCode}) async {
    try {
      print('📋 Fetching establishments...');
      
      var query = _supabase.from('article').select();
      
      // Si c'est un collecteur, ne montrer que ses établissements
      if (currentUserAgent == 'collecteur' && currentUserCode != null) {
        print('🔍 Filtering establishments for collector: $currentUserCode');
        query = query.eq('artagent', currentUserCode);
      } else {
        print('👁️ Showing all establishments for role: $currentUserAgent');
      }
      // Les autres rôles (admin, superviseur, controle) voient tous les établissements
      
      final data = await query;
      print('📊 Found ${data.length} establishments');
      
      // Enrichir les données avec les noms des agents
      final enrichedData = await _enrichWithAgentNames(data);
      
      return enrichedData.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error fetching etablissements: $e');
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
      print('❌ Error fetching etablissement by code: $e');
      return null;
    }
  }

  // Add new establishment (with bypass for RLS issues)
  // Méthode pour enrichir les données avec les noms des agents
  Future<List<Map<String, dynamic>>> _enrichWithAgentNames(List<dynamic> establishments) async {
    try {
      print('🔍 Enriching ${establishments.length} establishments with agent names...');
      
      // Récupérer tous les codes d'agents uniques
      final agentCodes = establishments
          .map((e) => e['artagent'] as String?)
          .where((code) => code != null && code.isNotEmpty)
          .toSet()
          .toList();
      
      print('📋 Found agent codes: $agentCodes');
      
      if (agentCodes.isEmpty) {
        print('⚠️ No agent codes found, returning original data');
        return establishments.cast<Map<String, dynamic>>();
      }
      
      // Récupérer les informations des agents
      List<Map<String, dynamic>> agentsData = [];
      for (final agentCode in agentCodes) {
        if (agentCode != null && agentCode.isNotEmpty) {
          try {
            print('🔍 Fetching agent data for code: $agentCode');
            final agentData = await _supabase
                .from('users')
                .select('user_code, nom, prenom')
                .eq('user_code', agentCode);
            if (agentData.isNotEmpty) {
              print('✅ Found agent data: ${agentData.first}');
              agentsData.addAll(agentData.cast<Map<String, dynamic>>());
            } else {
              print('⚠️ No agent found for code: $agentCode');
            }
          } catch (e) {
            print('❌ Error fetching agent $agentCode: $e');
          }
        }
      }
      
      print('👥 Total agents data retrieved: ${agentsData.length}');
      
      // Créer un map pour un accès rapide
      final agentMap = <String, Map<String, dynamic>>{};
      for (final agent in agentsData) {
        final code = agent['user_code'] as String;
        agentMap[code] = agent;
      }
      
      // Enrichir les données des établissements
      final enrichedEstablishments = <Map<String, dynamic>>[];
      for (final establishment in establishments) {
        final establishmentMap = Map<String, dynamic>.from(establishment);
        final agentCode = establishment['artagent'] as String?;
        
        print('🔍 Processing establishment: ${establishment['artnomcommerce']} with agent: $agentCode');
        
        if (agentCode != null && agentMap.containsKey(agentCode)) {
          final agent = agentMap[agentCode]!;
          final nom = agent['nom'] as String? ?? '';
          final prenom = agent['prenom'] as String? ?? '';
          final displayName = '$prenom $nom'.trim();
          establishmentMap['agent_display_name'] = displayName;
          print('✅ Enriched with agent name: $displayName');
        } else {
          establishmentMap['agent_display_name'] = agentCode ?? 'Non spécifié';
          print('⚠️ Using fallback agent name: ${agentCode ?? 'Non spécifié'}');
        }
        
        enrichedEstablishments.add(establishmentMap);
      }
      
      print('🎉 Enrichment completed for ${enrichedEstablishments.length} establishments');
      return enrichedEstablishments;
    } catch (e) {
      print('❌ Error enriching with agent names: $e');
      return establishments.cast<Map<String, dynamic>>();
    }
  }

  // Méthode pour récupérer tous les utilisateurs (pour la conversion nom -> CIN)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final data = await _supabase.from('users').select('user_code, nom, prenom, agent_type');
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Error fetching users: $e');
      return [];
    }
  }

  Future<EtablissementModel?> addEtablissement(EtablissementModel etablissement, {String? currentUserCode}) async {
    try {
      print('🔄 Adding establishment: ${etablissement.artNomCommerce}');
      
      // Prepare the data for insertion
      final establishmentData = etablissement.toJson();
      
      // Si l'agent n'est pas défini, utiliser le code utilisateur actuel
      if (establishmentData['artagent'] == null || establishmentData['artagent'].toString().isEmpty) {
        if (currentUserCode != null) {
          establishmentData['artagent'] = currentUserCode;
          print('👤 Setting agent to current user code: $currentUserCode');
        }
      }
      
      // Add timestamps if not present
      if (!establishmentData.containsKey('created_at')) {
        establishmentData['created_at'] = DateTime.now().toIso8601String();
      }
      if (!establishmentData.containsKey('updated_at')) {
        establishmentData['updated_at'] = DateTime.now().toIso8601String();
      }

      print('📝 Inserting data: $establishmentData');
      
      // Try to insert
      final data = await _supabase
          .from('article')
          .insert(establishmentData)
          .select();
      
      if (data.isNotEmpty) {
        print('✅ Establishment added successfully');
        return EtablissementModel.fromJson(data.first);
      }
      return null;
    } catch (e) {
      print('❌ Error adding etablissement: $e');
      
      // If RLS error, try with a simpler approach
      if (e.toString().contains('row-level security')) {
        print('🔄 RLS error detected, trying alternative approach...');
        return await _addEtablissementAlternative(etablissement, currentUserCode: currentUserCode);
      }
      
      rethrow;
    }
  }

  // Alternative method to add establishment (bypass RLS)
  Future<EtablissementModel?> _addEtablissementAlternative(EtablissementModel etablissement, {String? currentUserCode}) async {
    try {
      print('🔄 Trying alternative insertion method...');
      
      // Use a raw SQL approach if available, or try with minimal data
      final minimalData = {
        'artnouvcode': etablissement.artNouvCode,
        'artnomcommerce': etablissement.artNomCommerce ?? 'Nouveau Commerce',
        'artadresse': etablissement.artAdresse ?? 'Adresse non spécifiée',
        'artoccup': etablissement.artOccup ?? 'Occupation non spécifiée',
        'artetat': etablissement.artEtat ?? 1,
        'arttaxeimmobiliere': etablissement.artTaxeImmobiliere ?? 0.0,
        'artagent': currentUserCode ?? etablissement.artAgent ?? 'Agent non spécifié',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final data = await _supabase
          .from('article')
          .insert(minimalData)
          .select();
      
      if (data.isNotEmpty) {
        print('✅ Establishment added with alternative method');
        return EtablissementModel.fromJson(data.first);
      }
      return null;
    } catch (e) {
      print('❌ Alternative insertion also failed: $e');
      return null;
    }
  }

  // Update establishment
  Future<bool> updateEtablissement(EtablissementModel etablissement) async {
    try {
      print('🔄 Updating establishment: ${etablissement.artNomCommerce}');
      
      final updateData = etablissement.toJson();
      updateData['updated_at'] = DateTime.now().toIso8601String();
      
      await _supabase
          .from('article')
          .update(updateData)
          .eq('artnouvcode', etablissement.artNouvCode);
      
      print('✅ Establishment updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating etablissement: $e');
      return false;
    }
  }

  // Delete establishment
  Future<bool> deleteEtablissement(String artNouvCode) async {
    try {
      print('🗑️ Deleting establishment: $artNouvCode');
      
      await _supabase
          .from('article')
          .delete()
          .eq('artnouvcode', artNouvCode);
      
      print('✅ Establishment deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting etablissement: $e');
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
      print('❌ Error fetching etablissements with coordinates: $e');
      return [];
    }
  }

  // Search establishments
  Future<List<EtablissementModel>> searchEtablissements(String query) async {
    try {
      final data = await _supabase
          .from('article')
          .select()
          .or('artnomcommerce.ilike.%$query%,artadresse.ilike.%$query%,artoccup.ilike.%$query%');
      return data.map((json) => EtablissementModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error searching etablissements: $e');
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
      print('❌ Error fetching stats: $e');
      return {
        'total': 0,
        'payantTaxe': 0,
      };
    }
  }
}
