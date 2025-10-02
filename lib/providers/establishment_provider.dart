import 'package:flutter/foundation.dart';
import '../models/etablissement_model.dart';
import '../services/database_service.dart';

class EstablishmentProvider with ChangeNotifier {
  List<EtablissementModel> _etablissements = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedArrondissement;
  Map<String, dynamic> _stats = {};

  List<EtablissementModel> get etablissements => _etablissements;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedArrondissement => _selectedArrondissement;
  Map<String, dynamic> get stats => _stats;

  // Filtered etablissements based on search and filters
  List<EtablissementModel> get filteredEtablissements {
    List<EtablissementModel> filtered = _etablissements;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((etablissement) {
        return etablissement.artRue.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               etablissement.artNomCommerce?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
               etablissement.artOccup?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
               etablissement.displayArrondissement.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedArrondissement != null) {
      filtered = filtered.where((etablissement) => 
        etablissement.artArrond == _selectedArrondissement).toList();
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

  set selectedArrondissement(String? arrondissement) {
    _selectedArrondissement = arrondissement;
    notifyListeners();
  }

  // Fetch all etablissements
  Future<void> fetchEtablissements() async {
    print('🚀 EstablishmentProvider: Starting to fetch etablissements...');
    isLoading = true;
    try {
      // Test connection first
      await DatabaseService().testConnection();
      
      _etablissements = await DatabaseService().getEtablissements();
      print('📈 EstablishmentProvider: Fetched ${_etablissements.length} etablissements');
      notifyListeners();
    } catch (e) {
      print('❌ EstablishmentProvider: Error fetching etablissements: $e');
    } finally {
      isLoading = false;
      print('🏁 EstablishmentProvider: Finished fetching etablissements');
    }
  }

  // Fetch etablissements by arrondissement
  Future<void> fetchEtablissementsByArrondissement(String arrondissementCode) async {
    isLoading = true;
    try {
      _etablissements = await DatabaseService().getEtablissementsByArrondissement(arrondissementCode);
      notifyListeners();
    } catch (e) {
      print('Error fetching etablissements by arrondissement: $e');
    } finally {
      isLoading = false;
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
  Future<bool> addEtablissement(EtablissementModel etablissement) async {
    try {
      final newEtablissement = await DatabaseService().addEtablissement(etablissement);
      if (newEtablissement != null) {
        _etablissements.add(newEtablissement);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error adding etablissement: $e');
    }
    return false;
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
    _selectedArrondissement = null;
    notifyListeners();
  }

  // Get arrondissement options for dropdown
  List<Map<String, String>> get arrondissementOptions => EtablissementModel.arrondissements;

  // Get etat options for dropdown
  List<Map<String, String>> get etatOptions => EtablissementModel.etatOptions;

  // Get red type prpor options for dropdown
  List<Map<String, String>> get redTypePrporOptions => EtablissementModel.redTypePrporOptions;

  // Get cat activite options for dropdown
  List<Map<String, String>> get artCatActiviteOptions => EtablissementModel.artCatActiviteOptions;
}
