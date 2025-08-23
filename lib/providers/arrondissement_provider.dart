import 'package:flutter/foundation.dart';
import '../models/arrondissement_model.dart';
import '../services/database_service.dart';

/// Fournisseur d'état pour la gestion des arrondissements administratifs
class ArrondissementProvider with ChangeNotifier {
  List<ArrondissementModel> _arrondissements = [];
  bool _isLoading = false;
  String? _error;

  List<ArrondissementModel> get arrondissements => _arrondissements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Récupérer tous les arrondissements
  Future<void> fetchArrondissements() async {
    isLoading = true;
    _error = null;
    try {
      _arrondissements = await DatabaseService().getArrondissements();
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des arrondissements: $e';
      print(_error);
    } finally {
      isLoading = false;
    }
  }

  /// Récupérer uniquement les arrondissements actifs
  Future<void> fetchArrondissementsActifs() async {
    isLoading = true;
    _error = null;
    try {
      _arrondissements = await DatabaseService().getArrondissementsActifs();
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des arrondissements actifs: $e';
      print(_error);
    } finally {
      isLoading = false;
    }
  }

  /// Ajouter un nouvel arrondissement
  Future<bool> addArrondissement(ArrondissementModel arrondissement) async {
    _error = null;
    try {
      final newArrondissement = await DatabaseService().addArrondissement(arrondissement);
      if (newArrondissement != null) {
        _arrondissements.add(newArrondissement);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de l\'ajout de l\'arrondissement: $e';
      print(_error);
    }
    return false;
  }

  /// Mettre à jour un arrondissement existant
  Future<bool> updateArrondissement(ArrondissementModel arrondissement) async {
    _error = null;
    try {
      final success = await DatabaseService().updateArrondissement(arrondissement);
      if (success) {
        final index = _arrondissements.indexWhere((a) => a.code == arrondissement.code);
        if (index != -1) {
          _arrondissements[index] = arrondissement;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de la mise à jour de l\'arrondissement: $e';
      print(_error);
    }
    return false;
  }

  /// Supprimer un arrondissement
  Future<bool> deleteArrondissement(String code) async {
    _error = null;
    try {
      final success = await DatabaseService().deleteArrondissement(code);
      if (success) {
        _arrondissements.removeWhere((a) => a.code == code);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de la suppression de l\'arrondissement: $e';
      print(_error);
    }
    return false;
  }

  /// Obtenir un arrondissement par son code
  ArrondissementModel? getArrondissementByCode(String code) {
    return _arrondissements.firstWhere(
      (a) => a.code == code,
      orElse: () => ArrondissementModel(
        code: '',
        libelle: '',
        dateEtat: DateTime.now(),
        codeEtat: '',
      ),
    );
  }

  /// Vider les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Vider la liste des arrondissements
  void clearArrondissements() {
    _arrondissements.clear();
    notifyListeners();
  }
}
