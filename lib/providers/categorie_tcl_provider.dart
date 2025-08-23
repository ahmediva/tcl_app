import 'package:flutter/foundation.dart';
import '../models/categorie_tcl_model.dart';
import '../services/database_service.dart';

/// Fournisseur d'état pour la gestion des catégories TCL
class CategorieTclProvider with ChangeNotifier {
  List<CategorieTclModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategorieTclModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Récupérer toutes les catégories TCL
  Future<void> fetchCategories() async {
    isLoading = true;
    _error = null;
    try {
      _categories = await DatabaseService().getCategoriesTcl();
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des catégories TCL: $e';
      print(_error);
    } finally {
      isLoading = false;
    }
  }

  /// Récupérer uniquement les catégories actives
  Future<void> fetchCategoriesActives() async {
    isLoading = true;
    _error = null;
    try {
      _categories = await DatabaseService().getCategoriesTclActives();
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des catégories actives: $e';
      print(_error);
    } finally {
      isLoading = false;
    }
  }

  /// Ajouter une nouvelle catégorie TCL
  Future<bool> addCategorie(CategorieTclModel categorie) async {
    _error = null;
    try {
      final newCategorie = await DatabaseService().addCategorieTcl(categorie);
      if (newCategorie != null) {
        _categories.add(newCategorie);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de l\'ajout de la catégorie: $e';
      print(_error);
    }
    return false;
  }

  /// Mettre à jour une catégorie existante
  Future<bool> updateCategorie(CategorieTclModel categorie) async {
    _error = null;
    try {
      final success = await DatabaseService().updateCategorieTcl(categorie);
      if (success) {
        final index = _categories.indexWhere((c) => c.numero == categorie.numero);
        if (index != -1) {
          _categories[index] = categorie;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de la mise à jour de la catégorie: $e';
      print(_error);
    }
    return false;
  }

  /// Supprimer une catégorie
  Future<bool> deleteCategorie(int numero) async {
    _error = null;
    try {
      final success = await DatabaseService().deleteCategorieTcl(numero);
      if (success) {
        _categories.removeWhere((c) => c.numero == numero);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Erreur lors de la suppression de la catégorie: $e';
      print(_error);
    }
    return false;
  }

  /// Obtenir une catégorie par son numéro
  CategorieTclModel? getCategorieByNumero(int numero) {
    return _categories.firstWhere(
      (c) => c.numero == numero,
      orElse: () => CategorieTclModel(numero: 0, catCode: 0),
    );
  }

  /// Vider les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Vider la liste des catégories
  void clearCategories() {
    _categories.clear();
    notifyListeners();
  }
}
