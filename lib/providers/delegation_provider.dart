import 'package:flutter/foundation.dart';
import '../models/delegation_model.dart';
import '../services/database_service.dart';

/// Fournisseur d'état pour la gestion des délégations administratives
class DelegationProvider with ChangeNotifier {
  List<DelegationModel> _delegations = [];
  bool _isLoading = false;
  String? _error;

  List<DelegationModel> get delegations => _delegations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Récupérer toutes les délégations
  Future<void> fetchDelegations() async {
    isLoading = true;
    _error = null;
    try {
      _delegations = await DatabaseService().getDelegations();
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des délégations: $e';
      print(_error);
    } finally {
      isLoading = false;
    }
  }

  /// Ajouter une nouvelle délégation
  Future<bool> addDelegation(DelegationModel delegation) async {
    _error = null;
    try {
      final newDelegation = await DatabaseService().addDelegation(delegation);
      if (newDelegation != null) {
        _delegations.add(newDelegation);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de l\'ajout de la délégation: $e';
      print(_error);
    }
    return false;
  }

  /// Mettre à jour une délégation existante
  Future<bool> updateDelegation(DelegationModel delegation) async {
    _error = null;
    try {
      final success = await DatabaseService().updateDelegation(delegation);
      if (success) {
        final index = _delegations.indexWhere((d) => d.codeDeleg == delegation.codeDeleg);
        if (index != -1) {
          _delegations[index] = delegation;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de la mise à jour de la délégation: $e';
      print(_error);
    }
    return false;
  }

  /// Supprimer une délégation
  Future<bool> deleteDelegation(int codeDeleg) async {
    _error = null;
    try {
      final success = await DatabaseService().deleteDelegation(codeDeleg);
      if (success) {
        _delegations.removeWhere((d) => d.codeDeleg == codeDeleg);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de la suppression de la délégation: $e';
      print(_error);
    }
    return false;
  }

  /// Obtenir une délégation par son code
  DelegationModel? getDelegationByCode(int codeDeleg) {
    return _delegations.firstWhere(
      (d) => d.codeDeleg == codeDeleg,
      orElse: () => DelegationModel(
        codeDeleg: 0,
        codeGouv: null,
        libelleFr: null,
        libelleAr: null,
      ),
    );
  }

  /// Vider les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Vider la liste des délégations
  void clearDelegations() {
    _delegations.clear();
    notifyListeners();
  }
}
