import 'package:flutter/foundation.dart';
import '../models/citizen_model.dart';
import '../models/etablissement_model.dart';
import '../services/citizen_service.dart';

class CitizenProvider extends ChangeNotifier {
  TCLCitizen? _citizen;
  bool _isLoading = false;
  List<EtablissementModel> _establishments = [];

  // Getters
  TCLCitizen? get citizen => _citizen;
  bool get isAuthenticated => _citizen != null;
  bool get isLoading => _isLoading;
  List<EtablissementModel> get establishments => _establishments;

  // Login citizen
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final citizen = await CitizenService().loginCitizen(email, password);
      if (citizen != null) {
        _citizen = citizen;
        await _loadEstablishments();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Load establishments for current citizen
  Future<void> _loadEstablishments() async {
    if (_citizen != null) {
      try {
        _establishments = await CitizenService().getCitizenEstablishments(_citizen!.cin);
        notifyListeners();
      } catch (e) {
        print('❌ Error loading establishments: $e');
        _establishments = [];
        notifyListeners();
      }
    }
  }

  // Refresh establishments
  Future<void> refreshEstablishments() async {
    await _loadEstablishments();
  }

  // Logout citizen
  void logout() {
    _citizen = null;
    _establishments = [];
    _isLoading = false;
    notifyListeners();
  }

  // Set citizen (for direct navigation)
  void setCitizen(TCLCitizen citizen) {
    _citizen = citizen;
    _loadEstablishments();
    notifyListeners();
  }
}
