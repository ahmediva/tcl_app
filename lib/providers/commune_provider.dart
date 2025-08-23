import 'package:flutter/foundation.dart';
import '../models/commune_model.dart';
import '../services/database_service.dart';

/// Fournisseur d'état pour la gestion des communes
class CommuneProvider with ChangeNotifier {
  List<CommuneModel> _communes = [];
  bool _isLoading = false;
  String? _error;

  List<CommuneModel> get communes => _communes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Récupérer toutes les communes
  Future<void> fetchCommunes() async {
    isLoading = true;
    _error = null;
    try {
      _communes = await DatabaseService().getCommunes();
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des communes: $e';
      print(_error);
    } finally {
      isLoading = false;
    }
  }

  /// Ajouter une nouvelle commune
  Future<bool> addCommune(CommuneModel commune) async {
    _error = null;
    try {
      final newCommune = await DatabaseService().addCommune(commune);
      if (newCommune != null) {
        _communes.add(newCommune);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de l\'ajout de la commune: $e';
      print(_error);
    }
    return false;
  }

  /// Mettre à jour une commune existante
  Future<bool> updateCommune(CommuneModel commune) async {
    _error = null;
    try {
      final success = await DatabaseService().updateCommune(commune);
      if (success) {
        final index = _communes.indexWhere((c) => c.codeM == commune.codeM);
        if (index != -1) {
          _communes[index] = commune;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de la mise à jour de la commune: $e';
      print(_error);
    }
    return false;
  }

  /// Supprimer une commune
  Future<bool> deleteCommune(String codeM) async {
    _error = null;
    try {
      final success = await DatabaseService().deleteCommune(codeM);
      if (success) {
        _communes.removeWhere((c) => c.codeM == codeM);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de la suppression de la commune: $e';
      print(_error);
    }
    return false;
  }

  /// Obtenir une commune par son code
  CommuneModel? getCommuneByCode(String codeM) {
    return _communes.firstWhere(
      (c) => c.codeM == codeM,
      orElse: () => CommuneModel(codeM: ''),
    );
  }

  /// Vider les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Vider la liste des communes
  void clearCommunes() {
    _communes.clear();
    notifyListeners();
  }
}
