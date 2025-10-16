import 'package:flutter/foundation.dart';
import '../models/etablissement_model.dart';
import '../services/database_service.dart';

class EstablishmentProvider with ChangeNotifier {
  List<EtablissementModel> _etablissements = [];
  bool _isLoading = false;
  String _searchQuery = '';
  Map<String, dynamic> _stats = {};

  List<EtablissementModel> get etablissements => _etablissements;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get stats => _stats;

  // Filtered etablissements based on search and filters
  List<EtablissementModel> get filteredEtablissements {
    List<EtablissementModel> filtered = _etablissements;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((etablissement) {
        return etablissement.artAdresse?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
               etablissement.artNomCommerce?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
               etablissement.artOccup?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
      }).toList();
    }


    return filtered;
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }


  // Fetch all etablissements (with user filtering)
  Future<void> fetchEtablissements({String? currentUserAgent, String? currentUserCode}) async {
    print('🚀 EstablishmentProvider: Starting to fetch etablissements...');
    isLoading = true;
    try {
      // Test connection first
      await DatabaseService().testConnection();
      
      _etablissements = await DatabaseService().getEtablissements(
        currentUserAgent: currentUserAgent,
        currentUserCode: currentUserCode,
      );
      print('📈 EstablishmentProvider: Fetched ${_etablissements.length} etablissements');
      notifyListeners();
    } catch (e) {
      print('❌ EstablishmentProvider: Error fetching etablissements: $e');
    } finally {
      isLoading = false;
      print('🏁 EstablishmentProvider: Finished fetching etablissements');
    }
  }


  // Search etablissements
  Future<void> searchEtablissements(String query) async {
    isLoading = true;
    try {
      _etablissements = await DatabaseService().searchEtablissements(query);
      notifyListeners();
    } catch (e) {
      print('Error searching etablissements: $e');
    } finally {
      isLoading = false;
    }
  }

  // Fetch etablissements with coordinates
  Future<void> fetchEtablissementsWithCoordinates() async {
    isLoading = true;
    try {
      _etablissements = await DatabaseService().getEtablissementsWithCoordinates();
      notifyListeners();
    } catch (e) {
      print('Error fetching etablissements with coordinates: $e');
    } finally {
      isLoading = false;
    }
  }

  // Fetch statistics
  Future<void> fetchStats() async {
    try {
      _stats = await DatabaseService().getEtablissementStats();
      notifyListeners();
    } catch (e) {
      print('Error fetching stats: $e');
    }
  }

  // Add a new etablissement
  Future<bool> addEtablissement(EtablissementModel etablissement, {String? currentUserCode}) async {
    try {
      print('🔄 EstablishmentProvider: Tentative d\'ajout d\'établissement...');
      final newEtablissement = await DatabaseService().addEtablissement(etablissement, currentUserCode: currentUserCode);
      if (newEtablissement != null) {
        _etablissements.add(newEtablissement);
        notifyListeners();
        print('✅ EstablishmentProvider: Établissement ajouté avec succès');
        return true;
      } else {
        print('⚠️ EstablishmentProvider: Aucun établissement retourné');
        return false;
      }
    } catch (e) {
      print('❌ EstablishmentProvider: Erreur lors de l\'ajout: $e');
      rethrow; // Re-lancer l'erreur pour que l'UI puisse la gérer
    }
  }

  // Update an existing etablissement
  Future<bool> updateEtablissement(EtablissementModel etablissement) async {
    try {
      final success = await DatabaseService().updateEtablissement(etablissement);
      if (success) {
        final index = _etablissements.indexWhere((e) => e.artNouvCode == etablissement.artNouvCode);
        if (index != -1) {
          _etablissements[index] = etablissement;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      print('Error updating etablissement: $e');
    }
    return false;
  }

  // Delete an etablissement
  Future<bool> deleteEtablissement(String artNouvCode) async {
    try {
      final success = await DatabaseService().deleteEtablissement(artNouvCode);
      if (success) {
        _etablissements.removeWhere((e) => e.artNouvCode == artNouvCode);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error deleting etablissement: $e');
    }
    return false;
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    notifyListeners();
  }



  // Get etat options for dropdown
  List<Map<String, String>> get etatOptions => EtablissementModel.etatOptions;

  // Get red type prpor options for dropdown
  List<Map<String, String>> get redTypePrporOptions => EtablissementModel.redTypePrporOptions;

  // Get cat activite options for dropdown
  List<Map<String, String>> get artCatActiviteOptions => EtablissementModel.artCatActiviteOptions;
}
