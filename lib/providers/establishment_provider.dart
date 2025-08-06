import 'package:flutter/foundation.dart';
import '../models/etablissement_model.dart';
import '../services/database_service.dart';

class EstablishmentProvider with ChangeNotifier {
  List<EtablissementModel> _etablissements = [];
  bool _isLoading = false;

  List<EtablissementModel> get etablissements => _etablissements;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Fetch all etablissements
  Future<void> fetchEtablissements() async {
    isLoading = true;
    try {
      _etablissements = await DatabaseService().getEtablissements();
      notifyListeners();
    } catch (e) {
      print('Error fetching etablissements: $e');
    } finally {
      isLoading = false;
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
        final index = _etablissements.indexWhere((e) => e.id == etablissement.id);
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
  Future<bool> deleteEtablissement(String id) async {
    try {
      final success = await DatabaseService().deleteEtablissement(id);
      if (success) {
        _etablissements.removeWhere((e) => e.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error deleting etablissement: $e');
    }
    return false;
  }
}
