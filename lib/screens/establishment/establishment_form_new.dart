import 'package:flutter/material.dart';
import '../../models/etablissement_model.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/establishment_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class EstablishmentFormNew extends StatefulWidget {
  @override
  _EstablishmentFormNewState createState() => _EstablishmentFormNewState();
}

class _EstablishmentFormNewState extends State<EstablishmentFormNew> {
  final _formKey = GlobalKey<FormState>();
  EtablissementModel? _editingEstablishment; // For editing existing establishment

  // Controllers for the required fields
  final TextEditingController _artNouvCodeController = TextEditingController();
  final TextEditingController _artDebPerController = TextEditingController();
  final TextEditingController _artFinPerController = TextEditingController();
  final TextEditingController _artTauxPresController = TextEditingController();
  final TextEditingController _artMntTaxeController = TextEditingController();
  final TextEditingController _artChiffreAffairesLocalController = TextEditingController();
  final TextEditingController _artExportationsController = TextEditingController();
  final TextEditingController _artTaxeImmobiliereController = TextEditingController();
  final TextEditingController _artLatitudeController = TextEditingController();
  final TextEditingController _artLongitudeController = TextEditingController();
  final TextEditingController _artAgentController = TextEditingController();
  final TextEditingController _artDateSaisieController = TextEditingController();
  final TextEditingController _artRedCodeController = TextEditingController();
  final TextEditingController _artMondController = TextEditingController();
  final TextEditingController _artOccupController = TextEditingController();
  final TextEditingController _artTelDeclController = TextEditingController();
  final TextEditingController _artSurTotController = TextEditingController();
  final TextEditingController _artSurCouvController = TextEditingController();
  final TextEditingController _artQualOccupController = TextEditingController();
  final TextEditingController _artPrixM2Controller = TextEditingController();
  final TextEditingController _artServitudesMunicipalesController = TextEditingController();
  bool _artAutresServitudes = false; // Case à cocher pour autres servitudes
  final TextEditingController _catArtSearchController = TextEditingController();
  final TextEditingController _artCommentaireController = TextEditingController();
  final TextEditingController _redTypeProprioController = TextEditingController();
  final TextEditingController _artNomCommerceController = TextEditingController();
  final TextEditingController _artAdresseController = TextEditingController();

  int _artEtat = 1; // Default to 1 (paye taxe)
  String? _selectedCatArt; // Selected category article
  String _catArtSearchQuery = ''; // Search query for category
  List<Map<String, String>> _filteredCategories = []; // Filtered categories
  bool _isLoading = false;

  // Google Maps variables
  GoogleMapController? _mapController;
  LatLng _selectedLocation = LatLng(36.8065, 10.1815); // Default to Tunis
  Set<Marker> _markers = {};


  @override
  void initState() {
    super.initState();
    _filteredCategories = categoriesArticle;
    
    // Add listeners for automatic TCL calculation
    _artChiffreAffairesLocalController.addListener(_calculateTCLAmount);
    _artExportationsController.addListener(_calculateTCLAmount);
    // Note: Taxe immobilière est maintenant calculée automatiquement, pas de listener nécessaire
    
    // Add listeners for automatic taxe immobilière calculation
    _artSurCouvController.addListener(_calculateTaxeImmobiliere);
    _artPrixM2Controller.addListener(_calculateTaxeImmobiliere);
    
    // Add listeners for coordinate synchronization
    _artLatitudeController.addListener(_updateMapFromCoordinates);
    _artLongitudeController.addListener(_updateMapFromCoordinates);
    
    // Set default values
    _artDebPerController.text = DateTime.now().year.toString();
    _artFinPerController.text = (DateTime.now().year + 1).toString();
    _artDateSaisieController.text = DateTime.now().toString().split(' ')[0];
    _artPrixM2Controller.text = '0.900'; // Taux de référence par défaut (sera calculé selon les servitudes)
    
    // Auto-fill agent name with current user's full name
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.user;
      if (currentUser != null) {
        final fullName = '${currentUser.firstName ?? ''} ${currentUser.lastName ?? ''}'.trim();
        if (fullName.isNotEmpty) {
          _artAgentController.text = fullName;
        }
      }
    });
    
    // Check if we're editing an existing establishment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      final args = route?.settings.arguments;
      print('🔍 Route: $route');
      print('🔍 Received arguments: $args');
      print('🔍 Arguments type: ${args?.runtimeType}');
      
      if (args is EtablissementModel) {
        print('🔧 Editing establishment: ${args.artNomCommerce}');
        _editingEstablishment = args;
        _initializeControllersWithData();
      } else if (args == null) {
        print('🆕 Creating new establishment - no arguments');
      } else {
        print('🆕 Creating new establishment - unexpected args: $args');
      }
    });
  }

  void _initializeControllersWithData() {
    if (_editingEstablishment != null) {
      setState(() {
        _artNouvCodeController.text = _editingEstablishment!.artNouvCode;
        _artAgentController.text = _editingEstablishment!.artAgent ?? '';
        _artOccupController.text = _editingEstablishment!.artOccup ?? '';
        _artNomCommerceController.text = _editingEstablishment!.artNomCommerce ?? '';
        _artAdresseController.text = _editingEstablishment!.artAdresse ?? '';
      _artMondController.text = _editingEstablishment!.artProprietaire ?? '';
      _artRedCodeController.text = _editingEstablishment!.artRedCode ?? '';
      _artTelDeclController.text = _editingEstablishment!.artTelDecl?.toString() ?? '';
      _artSurCouvController.text = _editingEstablishment!.artSurCouv?.toString() ?? '';
      _artServitudesMunicipalesController.text = _editingEstablishment!.artServitudesMunicipales?.toString() ?? '';
      _artAutresServitudes = _editingEstablishment!.artAutresServitudes == 1; // 1 = true, 0 = false
      _artTauxPresController.text = _editingEstablishment!.artTauxPres?.toString() ?? '';
      _artMntTaxeController.text = _editingEstablishment!.artMntTaxe?.toString() ?? '';
      // Note: Prix par m² n'est pas stocké en base, il sera calculé à partir de la taxe immobilière et surface couverte
      _artChiffreAffairesLocalController.text = _editingEstablishment!.artChiffreAffairesLocal?.toString() ?? '';
      _artExportationsController.text = _editingEstablishment!.artExportations?.toString() ?? '';
      _artTaxeImmobiliereController.text = _editingEstablishment!.artTaxeImmobiliere?.toString() ?? '';
      
      // Calculer le taux de référence selon les servitudes
      _updateTauxReference();
      _artLatitudeController.text = _editingEstablishment!.artLatitude?.toString() ?? '';
      _artLongitudeController.text = _editingEstablishment!.artLongitude?.toString() ?? '';
      _selectedCatArt = _editingEstablishment!.artCatArt;
        _artEtat = _editingEstablishment!.artEtat ?? 1;
        
        // Update map location if coordinates exist
        if (_editingEstablishment!.artLatitude != null && _editingEstablishment!.artLongitude != null) {
          _selectedLocation = LatLng(_editingEstablishment!.artLatitude!, _editingEstablishment!.artLongitude!);
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId('selected_location'),
              position: _selectedLocation,
              infoWindow: InfoWindow(
                title: 'Position de l\'établissement',
                snippet: 'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}, Lng: ${_selectedLocation.longitude.toStringAsFixed(6)}',
              ),
            ),
          );
        }
      });
      
      // Trigger map update after a short delay to ensure the map controller is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (_mapController != null && 
              _editingEstablishment!.artLatitude != null && 
              _editingEstablishment!.artLongitude != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(_selectedLocation),
            );
          }
        });
      });
    }
  }

  void _updateTauxReference() {
    final servitudesMunicipales = int.tryParse(_artServitudesMunicipalesController.text.trim()) ?? 0;
    
    double tauxReference;
    
    // Calcul du taux de référence selon les règles :
    // - Si servitudes municipales = 1 ou 2 : 0.9 DT
    // - Si servitudes municipales = 3 ou 4 : 1.125 DT  
    // - Si servitudes municipales = 5 : 1.345 DT
    // - Si autres servitudes cochées (plus que 5) : 1.570 DT
    if (_artAutresServitudes) {
      tauxReference = 1.570; // Plus que 5
    } else if (servitudesMunicipales == 5) {
      tauxReference = 1.345;
    } else if (servitudesMunicipales == 3 || servitudesMunicipales == 4) {
      tauxReference = 1.125;
    } else if (servitudesMunicipales == 1 || servitudesMunicipales == 2) {
      tauxReference = 0.9;
    } else {
      tauxReference = 0.900; // Valeur par défaut
    }
    
    // Update the taux de référence field
    _artPrixM2Controller.text = tauxReference.toStringAsFixed(3);
    
    // Trigger taxe immobilière calculation
    _calculateTaxeImmobiliere();
  }

  void _calculateTaxeImmobiliere() {
    final surfaceCouverte = double.tryParse(_artSurCouvController.text.trim()) ?? 0.0;
    final prixM2 = double.tryParse(_artPrixM2Controller.text.trim()) ?? 0.0;
    
    // Calcul taxe immobilière = surface couverte × taux de référence
    final taxeImmobiliere = surfaceCouverte * prixM2;
    
    // Update the taxe immobilière field
    _artTaxeImmobiliereController.text = taxeImmobiliere.toStringAsFixed(2);
    
    // Trigger TCL calculation since taxe immobilière changed
    _calculateTCLAmount();
  }

  void _calculateTCLAmount() {
    final chiffreAffairesLocal = double.tryParse(_artChiffreAffairesLocalController.text.trim()) ?? 0.0;
    final exportations = double.tryParse(_artExportationsController.text.trim()) ?? 0.0;
    final taxeImmobiliere = double.tryParse(_artTaxeImmobiliereController.text.trim()) ?? 0.0;
    
    // Calcul TCL selon les règles professionnelles :
    // - 0,2% du chiffre d'affaires brut local
    // - 0,1% pour les exportations
    // - Minimum basé sur la taxe immobilière
    final tclLocal = chiffreAffairesLocal * 0.002; // 0,2%
    final tclExport = exportations * 0.001; // 0,1%
    final montantTCL = tclLocal + tclExport;
    
    // Appliquer le minimum (taxe immobilière)
    final montantFinal = montantTCL > taxeImmobiliere ? montantTCL : taxeImmobiliere;
    
    // Update the TCL amount field
    _artMntTaxeController.text = montantFinal.toStringAsFixed(2);
  }

  void _updateMapFromCoordinates() {
    final lat = double.tryParse(_artLatitudeController.text);
    final lng = double.tryParse(_artLongitudeController.text);
    
    if (lat != null && lng != null) {
      final newLocation = LatLng(lat, lng);
      setState(() {
        _selectedLocation = newLocation;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('selected_location'),
            position: newLocation,
            infoWindow: InfoWindow(title: 'Position sélectionnée'),
          ),
        );
      });
      
      // Animate camera to new location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(newLocation),
        );
      }
    }
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selected_location'),
          position: location,
          infoWindow: InfoWindow(
            title: 'Position sélectionnée',
            snippet: 'Lat: ${location.latitude.toStringAsFixed(6)}, Lng: ${location.longitude.toStringAsFixed(6)}',
          ),
        ),
      );
      
      // Update coordinate fields
      _artLatitudeController.text = location.latitude.toStringAsFixed(6);
      _artLongitudeController.text = location.longitude.toStringAsFixed(6);
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Permission de localisation refusée')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission de localisation refusée définitivement')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      _onMapTap(currentLocation);
      
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(currentLocation),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération de la position: $e')),
      );
    }
  }

  // Liste des catégories d'articles
  static const List<Map<String, String>> categoriesArticle = [
    {"code": "2", "libelle": "مطار"},
    {"code": "3", "libelle": "بيع مرطبات"},
    {"code": "4", "libelle": "بيع الخبز"},
    {"code": "5", "libelle": "مخبزة"},
    {"code": "6", "libelle": "مطعم"},
    {"code": "7", "libelle": "بيع الحليب ومشتقاته"},
    {"code": "8", "libelle": "بيع الدجاج والبيض"},
    {"code": "10", "libelle": "صنع المرطبات"},
    {"code": "11", "libelle": "بيع الزيت"},
    {"code": "12", "libelle": "معصرة زيتون"},
    {"code": "13", "libelle": "فطائري"},
    {"code": "14", "libelle": "معمل مصيرات غذائية"},
    {"code": "15", "libelle": "رحي الحبوب والتوابل"},
    {"code": "16", "libelle": "بيع الفواكه الجافة"},
    {"code": "17", "libelle": "بيع الخضر والغلال"},
    {"code": "18", "libelle": "بيع مواد غذائية بالجملة"},
    {"code": "19", "libelle": "بيع التوابل"},
    {"code": "20", "libelle": "بيع التبغ"},
    {"code": "21", "libelle": "مطار"},
    {"code": "22", "libelle": "بيع مادة القهوة"},
    {"code": "23", "libelle": "مقهى"},
    {"code": "24", "libelle": "مدرسة"},
    {"code": "25", "libelle": "حانة"},
    {"code": "26", "libelle": "مغازة"},
    {"code": "27", "libelle": "صيدلية"},
    {"code": "28", "libelle": "طبيب عام"},
    {"code": "29", "libelle": "طبيب مختص"},
    {"code": "30", "libelle": "بيطري"},
    {"code": "31", "libelle": "مخبر تحاليل طبية"},
    {"code": "32", "libelle": "جزار"},
    {"code": "33", "libelle": "اسطبل"},
    {"code": "34", "libelle": "تربية الحيوانات"},
    {"code": "35", "libelle": "بيع العلف"},
    {"code": "36", "libelle": "حداد"},
    {"code": "37", "libelle": "بيع مواد حديدية وكهربائية"},
    {"code": "38", "libelle": "بيع أجهزة منزلية"},
    {"code": "39", "libelle": "مطالة ودهن"},
    {"code": "40", "libelle": "بيع مواد فلاحية"},
    {"code": "41", "libelle": "تعاونية الخدمات الفلاحية"},
    {"code": "42", "libelle": "بيع البلاستيك والمطاط"},
    {"code": "43", "libelle": "بيع الأجهزة القديمة"},
    {"code": "44", "libelle": "معمل أسلاك كهربائية"},
    {"code": "45", "libelle": "بيع دهن ومشتقاته"},
    {"code": "46", "libelle": "بيع مواد البناء"},
    {"code": "47", "libelle": "ميكانيكي عام"},
    {"code": "48", "libelle": "اصلاح الدراجات"},
    {"code": "49", "libelle": "ترقيع العجلات"},
    {"code": "50", "libelle": "كهرباء السيارات"},
    {"code": "51", "libelle": "اصلاح الرادياتور"},
    {"code": "52", "libelle": "بيع قطع غيار السيارات"},
    {"code": "53", "libelle": "بيع قطع غيار الدراجات"},
    {"code": "54", "libelle": "محطة لغسل السيارات"},
    {"code": "55", "libelle": "تغليف الكراسي"},
    {"code": "56", "libelle": "اصلاح وبيع الساعات"},
    {"code": "57", "libelle": "اصلاح الراديو والتلفزة"},
    {"code": "58", "libelle": "بيع وإصلاح قطع غيار الالكترونيك"},
    {"code": "59", "libelle": "نقل على الكعب"},
    {"code": "60", "libelle": "بيع الأحذية"},
    {"code": "61", "libelle": "اصلاح الأحذية"},
    {"code": "62", "libelle": "صنع الأحذية"},
    {"code": "63", "libelle": "صناعة جلدية مشتقة"},
    {"code": "64", "libelle": "تارزي"},
    {"code": "65", "libelle": "معمل خياطة"},
    {"code": "66", "libelle": "بيع الأقمشة"},
    {"code": "67", "libelle": "معمل جوارب"},
    {"code": "68", "libelle": "بيع الملابس"},
    {"code": "69", "libelle": "حياكة الصوف"},
    {"code": "70", "libelle": "بيع الصوف"},
    {"code": "71", "libelle": "بيع الملابس القديمة"},
    {"code": "72", "libelle": "بيع الملابس الجاهزة"},
    {"code": "73", "libelle": "تنظيف بالفاتح"},
    {"code": "74", "libelle": "بيع مواد التنظيف"},
    {"code": "75", "libelle": "بيع العطورات"},
    {"code": "76", "libelle": "كاتب عمومي"},
    {"code": "77", "libelle": "عدل منفذ"},
    {"code": "78", "libelle": "عدل إشهاد"},
    {"code": "79", "libelle": "محامي"},
    {"code": "80", "libelle": "نيابة تأمين"},
    {"code": "81", "libelle": "إدارة"},
    {"code": "82", "libelle": "روضة أطفال"},
    {"code": "83", "libelle": "بيع أدوات مدرسية"},
    {"code": "84", "libelle": "مدرسة تعليم السياقة"},
    {"code": "85", "libelle": "معهد خاص"},
    {"code": "86", "libelle": "حضانة"},
    {"code": "87", "libelle": "مكتب دراسات"},
    {"code": "88", "libelle": "وكالة أسفار"},
    {"code": "89", "libelle": "بيع الأكلة الخفيفة"},
    {"code": "90", "libelle": "بنك"},
    {"code": "91", "libelle": "قاعة سينما"},
    {"code": "92", "libelle": "مركز عمومي للاتصالات"},
    {"code": "93", "libelle": "حمام"},
    {"code": "94", "libelle": "حلاق"},
    {"code": "95", "libelle": "مصاغة"},
    {"code": "96", "libelle": "إصلاح وصنع المفاتيح"},
    {"code": "97", "libelle": "بيع أشرطة سمعية"},
    {"code": "98", "libelle": "بيع وكراء أشرطة فيديو"},
    {"code": "99", "libelle": "مصور"},
    {"code": "100", "libelle": "نجار"},
    {"code": "1000", "libelle": "نزل"},
    {"code": "101", "libelle": "بيع الخشب ومشتقاته"},
    {"code": "102", "libelle": "قاعة عرض تجارة"},
    {"code": "103", "libelle": "بيع وتركيب البلور"},
    {"code": "104", "libelle": "تجارة الأليمينيوم"},
    {"code": "105", "libelle": "صنع الموزييك"},
    {"code": "106", "libelle": "صنع قوالب الجبس"},
    {"code": "107", "libelle": "بيع الفحم والغاز"},
    {"code": "108", "libelle": "اصلاح موافيد النفط"},
    {"code": "109", "libelle": "إصلاح الثلاجات"},
    {"code": "110", "libelle": "بيع المحروقات"},
    {"code": "111", "libelle": "محطة بنزين"},
    {"code": "112", "libelle": "بيع الغاز"},
    {"code": "113", "libelle": "مخزن"},
    {"code": "114", "libelle": "بيع الفخار"},
    {"code": "115", "libelle": "بيع السمك"},
    {"code": "116", "libelle": "بيع وإصلاح الساعات"},
    {"code": "117", "libelle": "حلاقة"},
    {"code": "118", "libelle": "Plombier"},
    {"code": "119", "libelle": "الرخام المركب"},
    {"code": "120", "libelle": "معمل فاروز - درويو"},
    {"code": "121", "libelle": "بيع الحراري"},
    {"code": "122", "libelle": "كراء لوازم الافراح"},
    {"code": "123", "libelle": "تاجر"},
    {"code": "124", "libelle": "مسجد"},
    {"code": "125", "libelle": "مخبر أسنان"},
    {"code": "126", "libelle": "قاعة العاب"},
    {"code": "127", "libelle": "Mercerie"},
    {"code": "128", "libelle": "مكتب عمدة"},
    {"code": "129", "libelle": "اصلاح آلات الخياطة"},
    {"code": "130", "libelle": "تعمير قوارير الإطفاء"},
    {"code": "131", "libelle": "تزويق"},
    {"code": "132", "libelle": "محل تمريض"},
    {"code": "133", "libelle": "حطاب"},
    {"code": "134", "libelle": "Supermarché"},
    {"code": "135", "libelle": "Faux- Bijoux"},
    {"code": "136", "libelle": "بيع النظارات"},
    {"code": "137", "libelle": "Electrique"},
    {"code": "138", "libelle": "TOURNEUR"},
    {"code": "139", "libelle": "بيع الحديد"},
    {"code": "140", "libelle": "قاعة عرض حدادة"},
    {"code": "141", "libelle": "صنع الفورية"},
    {"code": "142", "libelle": "خياطة"},
    {"code": "143", "libelle": "قاعة أفراح"},
    {"code": "144", "libelle": "بيع آلات الخياطة"},
    {"code": "145", "libelle": "مغازة"},
    {"code": "146", "libelle": "مطبعة وراقة"},
    {"code": "147", "libelle": "بيع الملابس والمحافظ الجلدية"},
    {"code": "148", "libelle": "قاعة عرض"},
    {"code": "149", "libelle": "صنع الكراسي"},
    {"code": "150", "libelle": "قاعة رياضية"},
    {"code": "151", "libelle": "صقل الرخام"},
    {"code": "152", "libelle": "مخبر صور"},
    {"code": "153", "libelle": "مهندس معماري"},
    {"code": "154", "libelle": "اصلاح وبيع البرابول"},
    {"code": "155", "libelle": "مدرسة خاصة"},
    {"code": "156", "libelle": "بيع مواد شبه طبية"},
    {"code": "157", "libelle": "بيع الموالح"},
    {"code": "158", "libelle": "قاعة إعلامية موجهة للطفل"},
    {"code": "159", "libelle": "مركز تبريد"},
    {"code": "177", "libelle": "بيع وتصليح الهاتف الجوال"},
    {"code": "178", "libelle": "بيع وتصليح الآلات الموسيقية"},
    {"code": "179", "libelle": "صناعات تقليدية"},
    {"code": "180", "libelle": "خدمات إعلامية"},
    {"code": "181", "libelle": "مكتب حسابات"},
    {"code": "182", "libelle": "نساج"},
    {"code": "183", "libelle": "مدرسة ابتدائية"},
    {"code": "184", "libelle": "TATOUAGE"},
    {"code": "185", "libelle": "معمل بلاستيك"},
    {"code": "186", "libelle": "دهن الموبيليا"},
    {"code": "187", "libelle": "وكالة عقارية"},
    {"code": "188", "libelle": "مرسم محلف"},
    {"code": "189", "libelle": "كراء السيارات"},
    {"code": "190", "libelle": "بيع الزهور"},
    {"code": "191", "libelle": "حزب سياسي"},
    {"code": "192", "libelle": "علاج طبيعي"},
    {"code": "193", "libelle": "بيع وإصلاح الحاسوب"},
    {"code": "194", "libelle": "مركب ترفيهي"},
    {"code": "195", "libelle": "وكالة إشهار"},
    {"code": "196", "libelle": "مدرسة خاصة"},
    {"code": "197", "libelle": "FRIGO"},
    {"code": "2000", "libelle": "محل شامل"},
    {"code": "2001", "libelle": "مدرسة تجميل"},
    {"code": "2002", "libelle": "خياطة الستائر"},
    {"code": "2003", "libelle": "بيع اللحوم"},
    {"code": "2004", "libelle": "بيع مواد التجميل"},
    {"code": "2005", "libelle": "بيع الطاقة الشمسية"},
    {"code": "2006", "libelle": "مركز الكفاءة للغات والإعلامية"},
    {"code": "2007", "libelle": "بيع مواد كهربائية"},
    {"code": "2008", "libelle": "التضامن الاجتماعي"},
    {"code": "2009", "libelle": "تصبير وتصدير السمك"},
    {"code": "2010", "libelle": "ديوان الحبوب"},
    {"code": "2011", "libelle": "معمل طماطم"},
    {"code": "2012", "libelle": "الدعم في مجال التعليم"},
    {"code": "2013", "libelle": "بيع المثلجات"},
    {"code": "2014", "libelle": "بيع المواد الغذائية والمطعم"},
  ];


  @override
  void dispose() {
    // Dispose all controllers
    _artNouvCodeController.dispose();
    _artDebPerController.dispose();
    _artFinPerController.dispose();
    _artTauxPresController.dispose();
    _artMntTaxeController.dispose();
    _artChiffreAffairesLocalController.dispose();
    _artExportationsController.dispose();
    _artTaxeImmobiliereController.dispose();
    _artLatitudeController.dispose();
    _artLongitudeController.dispose();
    _artAgentController.dispose();
    _artDateSaisieController.dispose();
    _artRedCodeController.dispose();
    _artMondController.dispose();
    _artOccupController.dispose();
    _artTelDeclController.dispose();
    _artSurTotController.dispose();
    _artSurCouvController.dispose();
    _artQualOccupController.dispose();
    _artPrixM2Controller.dispose();
    _artServitudesMunicipalesController.dispose();
    _catArtSearchController.dispose();
    _artCommentaireController.dispose();
    _redTypeProprioController.dispose();
    _artNomCommerceController.dispose();
    _artAdresseController.dispose();
    super.dispose();
  }

  void _filterCategories(String query) {
    setState(() {
      _catArtSearchQuery = query;
      _catArtSearchController.text = query;
      if (query.isEmpty) {
        _filteredCategories = List.from(categoriesArticle);
      } else {
        _filteredCategories = categoriesArticle.where((category) {
          final code = category['code']?.toLowerCase() ?? '';
          final libelle = category['libelle']?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          return code.contains(searchLower) || libelle.contains(searchLower);
        }).toList();
      }
    });
  }



  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final establishmentProvider = Provider.of<EstablishmentProvider>(context, listen: false);

    // Calculate TCL amount before saving
    final chiffreAffairesLocal = double.tryParse(_artChiffreAffairesLocalController.text.trim()) ?? 0.0;
    final exportations = double.tryParse(_artExportationsController.text.trim()) ?? 0.0;
    final taxeImmobiliere = double.tryParse(_artTaxeImmobiliereController.text.trim()) ?? 0.0;
    
    // Calcul TCL selon les règles professionnelles :
    // - 0,2% du chiffre d'affaires brut local
    // - 0,1% pour les exportations
    // - Minimum basé sur la taxe immobilière
    final tclLocal = chiffreAffairesLocal * 0.002; // 0,2%
    final tclExport = exportations * 0.001; // 0,1%
    final montantTCL = tclLocal + tclExport;
    
    // Appliquer le minimum (taxe immobilière)
    final montantFinal = montantTCL > taxeImmobiliere ? montantTCL : taxeImmobiliere;

    final newEtablissement = EtablissementModel(
      artNouvCode: _artNouvCodeController.text.trim(),
      artAgent: _artAgentController.text.trim(),
      artOccup: _artOccupController.text.trim(),
      artNomCommerce: _artNomCommerceController.text.trim(),
      artAdresse: _artAdresseController.text.trim(),
      artProprietaire: _artMondController.text.trim(),
      artRedCode: _artRedCodeController.text.trim(),
      artTelDecl: int.tryParse(_artTelDeclController.text.trim()),
      artCatArt: _selectedCatArt,
      artSurCouv: double.tryParse(_artSurCouvController.text.trim()),
      artServitudesMunicipales: int.tryParse(_artServitudesMunicipalesController.text.trim()),
      artAutresServitudes: _artAutresServitudes ? 1 : 0, // Convertir bool en int pour la base
      prixm2: 1.570, // Taux de référence fixe
      artTauxPres: double.tryParse(_artTauxPresController.text.trim()),
      artMntTaxe: montantFinal,
      artChiffreAffairesLocal: chiffreAffairesLocal,
      artExportations: exportations,
      artTaxeImmobiliere: taxeImmobiliere,
      artLatitude: double.tryParse(_artLatitudeController.text.trim()),
      artLongitude: double.tryParse(_artLongitudeController.text.trim()),
      artDebPer: _artDebPerController.text.trim(),
      artFinPer: _artFinPerController.text.trim(),
      artEtat: _artEtat,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      bool success;
      String message;
      Color backgroundColor;
      
      if (_editingEstablishment != null) {
        // Update existing establishment
        success = await establishmentProvider.updateEtablissement(newEtablissement);
        message = success ? 'Établissement modifié avec succès!' : 'Échec de la modification de l\'établissement. Veuillez réessayer.';
        backgroundColor = success ? Colors.green : Colors.red;
      } else {
        // Add new establishment
        success = await establishmentProvider.addEtablissement(newEtablissement);
        message = success ? 'Établissement ajouté avec succès!' : 'Échec de l\'ajout de l\'établissement. Veuillez réessayer.';
        backgroundColor = success ? Colors.green : Colors.red;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
      
      if (success) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      print('❌ Erreur dans le formulaire: $e');
      
      String errorMessage = 'Erreur lors de l\'ajout de l\'établissement';
      
      if (e.toString().contains('duplicate key') || e.toString().contains('unique constraint')) {
        errorMessage = 'Le code établissement existe déjà. Veuillez utiliser un autre code.';
      } else if (e.toString().contains('not-null') || e.toString().contains('required')) {
        errorMessage = 'Certains champs obligatoires sont manquants.';
      } else if (e.toString().contains('RLS') || e.toString().contains('policy')) {
        errorMessage = 'Problème de permissions. Contactez l\'administrateur.';
      } else if (e.toString().contains('permission') || e.toString().contains('denied')) {
        errorMessage = 'Permission refusée. Vérifiez vos droits d\'accès.';
      } else if (e.toString().contains('network') || e.toString().contains('timeout')) {
        errorMessage = 'Problème de connexion. Vérifiez votre connexion internet.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Détails',
            textColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Détails de l\'erreur'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Fermer'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingEstablishment != null ? 'Modifier Établissement' : 'Nouvel Établissement'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
              key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    // User Information Section
                    _buildSectionHeader('Informations Utilisateur'),
                    
                    // First row: CIN and Propriétaire
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artRedCodeController,
                            decoration: InputDecoration(
                              labelText: 'CIN ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.badge),
                              helperText: 'Carte d\'identité nationale (exactement 8 chiffres)',
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                // Must be exactly 8 digits
                                final cinRegex = RegExp(r'^[0-9]{8}$');
                                if (!cinRegex.hasMatch(value)) {
                                  return 'Le CIN doit contenir exactement 8 chiffres';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artMondController,
                            decoration: InputDecoration(
                              labelText: 'Propriétaire ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                              helperText: 'Nom du propriétaire',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Second row: Qualité Occupation and Occupant
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artQualOccupController,
                            decoration: InputDecoration(
                              labelText: 'Qualité Occupation',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.star),
                              helperText: 'Qualité de l\'occupation',
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artOccupController,
                            decoration: InputDecoration(
                              labelText: 'Occupant ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                              helperText: 'Nom de l\'occupant (propriétaire, locataire...)',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Third row: Téléphone Domicile (full width)
                    TextFormField(
                      controller: _artTelDeclController,
                      decoration: InputDecoration(
                        labelText: 'Téléphone Domicile ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                        helperText: 'Numéro de téléphone domicile (8 chiffres)',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          // Must be exactly 8 digits
                          final phoneRegex = RegExp(r'^[0-9]{8}$');
                          if (!phoneRegex.hasMatch(value)) {
                            return 'Le numéro doit contenir exactement 8 chiffres';
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),

                    
                    
                    _buildSectionHeader('Informations de Base'),
                    
                    // First row: Article Nouveau Code and Adresse
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artNouvCodeController,
                            decoration: InputDecoration(
                              labelText: 'Article Nouveau Code  *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.qr_code),
                              helperText: 'Code unique de l\'établissement',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Le code article est obligatoire';
                              }
                              if (value.length < 3) {
                                return 'Le code doit contenir au moins 3 caractères';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artAdresseController,
                            decoration: InputDecoration(
                              labelText: 'Adresse *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                              helperText: 'Adresse complète de l\'établissement',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir l\'adresse';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Second row: Servitudes Municipales and Autres Servitudes
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artServitudesMunicipalesController,
                            decoration: InputDecoration(
                              labelText: 'Nombre Servitudes Municipales',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_city),
                              helperText: '(propreté, assainissement, goudronnée, trottoir, éclairage publique)',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final number = int.tryParse(value.trim());
                                if (number == null || number < 1 || number > 5) {
                                  return 'Nombre entre 1 et 5';
                                }
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _updateTauxReference();
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: CheckboxListTile(
                                  title: Text('Autres'),
                                  value: _artAutresServitudes,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _artAutresServitudes = value ?? false;
                                    });
                                    _updateTauxReference();
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  '(jardin publique, parking...)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Third row: Surface Couverte and Taux de référence
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artSurCouvController,
                            decoration: InputDecoration(
                              labelText: 'Surface Couverte (m²) *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.square_foot),
                              helperText: 'Surface couverte en mètres carrés',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Veuillez saisir la surface couverte';
                              }
                              final surface = double.tryParse(value.trim());
                              if (surface == null || surface <= 0) {
                                return 'Surface invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artPrixM2Controller,
                            decoration: InputDecoration(
                              labelText: 'Taux de référence (DT)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calculate),
                              helperText: 'Calculé automatiquement selon les servitudes',
                            ),
                            readOnly: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Info de Établissement Commerce Section
                    _buildSectionHeader('Info de Établissement Commerce'),
                    
                    // First row: Activité and Nom Commerce
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _catArtSearchController,
                                decoration: InputDecoration(
                                  labelText: 'Activité ',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                  suffixIcon: _catArtSearchQuery.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _catArtSearchQuery = '';
                                              _catArtSearchController.clear();
                                              _filteredCategories = [];
                                              _selectedCatArt = null;
                                            });
                                          },
                                          icon: Icon(Icons.clear),
                                        )
                                      : null,
                                  helperText: 'Tapez pour rechercher une catégorie',
                                ),
                                onChanged: _filterCategories,
                                validator: (value) {
                                  if (_selectedCatArt == null || _selectedCatArt!.isEmpty) {
                                    return 'Veuillez sélectionner une catégorie';
                                  }
                                  return null;
                                },
                              ),
                              // Search results container with fixed height
                              Container(
                                height: _filteredCategories.isNotEmpty && _catArtSearchQuery.isNotEmpty ? 200 : 0,
                                margin: EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: _filteredCategories.isNotEmpty && _catArtSearchQuery.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: _filteredCategories.length > 6 ? 6 : _filteredCategories.length,
                                        itemBuilder: (context, index) {
                                          final category = _filteredCategories[index];
                                          final isSelected = _selectedCatArt == category['code'];
                                          return ListTile(
                                            title: Text('${category['code']} - ${category['libelle']}'),
                                            selected: isSelected,
                                            selectedTileColor: Colors.blue[100],
                                            onTap: () {
                                              setState(() {
                                                _selectedCatArt = category['code'];
                                                _catArtSearchQuery = '${category['code']} - ${category['libelle']}';
                                                _catArtSearchController.text = _catArtSearchQuery;
                                                _filteredCategories = []; // Clear the dropdown after selection
                                              });
                                            },
                                          );
                                        },
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artNomCommerceController,
                            decoration: InputDecoration(
                              labelText: 'Nom Commerce ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.store),
                              helperText: 'Nom commercial de l\'établissement',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Tax Information Section
                    _buildSectionHeader('Informations Taxe'),
                    
                    // First row: Chiffre d'affaires brut local and Exportations
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artChiffreAffairesLocalController,
                            decoration: InputDecoration(
                              labelText: 'Chiffre d\'affaires brut local *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.account_balance_wallet),
                              helperText: 'Montant en DT (0,2% de ce montant)',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Veuillez saisir le chiffre d\'affaires local';
                              }
                              final amount = double.tryParse(value.trim());
                              if (amount == null || amount < 0) {
                                return 'Montant invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artExportationsController,
                            decoration: InputDecoration(
                              labelText: 'Chiffre d\'affaires exportations',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.flight_takeoff),
                              helperText: 'Montant en DT (0,1% de ce montant)',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final amount = double.tryParse(value.trim());
                                if (amount == null || amount < 0) {
                                  return 'Montant invalide';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Second row: Taxe immobilière and Montant TCL calculé
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artTaxeImmobiliereController,
                            decoration: InputDecoration(
                              labelText: 'Taxe immobilière (minimum)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.home),
                              helperText: 'Calculée automatiquement (Surface × Taux de référence)',
                            ),
                            readOnly: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artMntTaxeController,
                            decoration: InputDecoration(
                              labelText: 'Montant TCL calculé',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calculate),
                              helperText: 'Calculé automatiquement selon la formule TCL',
                            ),
                            readOnly: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Third row: Périodes
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artDebPerController,
                            decoration: InputDecoration(
                              labelText: 'Début Période',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                              helperText: 'Année de début (ex: 2024)',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final year = int.tryParse(value);
                                if (year == null || year < 2000 || year > 2100) {
                                  return 'Année invalide (2000-2100)';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artFinPerController,
                            decoration: InputDecoration(
                              labelText: 'Fin Période',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                              helperText: 'Année de fin (ex: 2025)',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final year = int.tryParse(value);
                                if (year == null || year < 2000 || year > 2100) {
                                  return 'Année invalide (2000-2100)';
                                }
                                // Check if end year is after start year
                                final startYear = int.tryParse(_artDebPerController.text);
                                if (startYear != null && year <= startYear) {
                                  return 'L\'année de fin doit être après l\'année de début';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Fourth row: État Taxe
                    DropdownButtonFormField<int>(
                      value: _artEtat,
                      decoration: InputDecoration(
                        labelText: 'État Taxe',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.info),
                      ),
                      items: [
                        DropdownMenuItem<int>(value: 1, child: Text('Paye Taxe')),
                        DropdownMenuItem<int>(value: 0, child: Text('Ne Paye Pas')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _artEtat = value ?? 1;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Agent Section
                    _buildSectionHeader('Agent'),
                    
                    // Agent row: Agent and Date Saisie
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artAgentController,
                            decoration: InputDecoration(
                              labelText: 'Agent ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                              helperText: 'Nom de l\'agent responsable ',
                            ),
                            readOnly: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artDateSaisieController,
                            decoration: InputDecoration(
                              labelText: 'Date Saisie ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                              helperText: 'Date de saisie des données',
                            ),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                _artDateSaisieController.text = date.toString().split(' ')[0];
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Commentaire Section
                    _buildSectionHeader('Commentaire'),
                    
                    // ArtCommentaire - Commentaire
                    TextFormField(
                      controller: _artCommentaireController,
                      decoration: InputDecoration(
                        labelText: 'Commentaire ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.comment),
                        helperText: 'Commentaires ou notes supplémentaires',
                      ),
                      maxLines: 4,
                      minLines: 2,
                      textInputAction: TextInputAction.newline,
                    ),
                    SizedBox(height: 32),
                    // Position Géographique Section
                    _buildSectionHeader('Position Géographique'),
                    
                    // Google Maps Container
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                            // If editing and coordinates exist, center the map on the establishment location
                            if (_editingEstablishment != null && 
                                _editingEstablishment!.artLatitude != null && 
                                _editingEstablishment!.artLongitude != null) {
                              controller.animateCamera(
                                CameraUpdate.newLatLng(_selectedLocation),
                              );
                            }
                          },
                          initialCameraPosition: CameraPosition(
                            target: _selectedLocation,
                            zoom: 15.0,
                          ),
                          onTap: _onMapTap,
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Location buttons row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: Icon(Icons.my_location),
                            label: Text('Ma Position'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_mapController != null) {
                                _mapController!.animateCamera(
                                  CameraUpdate.newLatLng(_selectedLocation),
                                );
                              }
                            },
                            icon: Icon(Icons.center_focus_strong),
                            label: Text('Centrer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Coordinate fields row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artLatitudeController,
                            decoration: InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.my_location),
                              helperText: 'Coordonnée latitude (ex: 36.8065)',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final lat = double.tryParse(value.trim());
                                if (lat == null || lat < -90 || lat > 90) {
                                  return 'Latitude invalide (-90 à 90)';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artLongitudeController,
                            decoration: InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.my_location),
                              helperText: 'Coordonnée longitude (ex: 10.1815)',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final lng = double.tryParse(value.trim());
                                if (lng == null || lng < -180 || lng > 180) {
                                  return 'Longitude invalide (-180 à 180)';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: Icon(Icons.save),
                        label: Text(_editingEstablishment != null ? 'Modifier l\'Établissement' : 'Enregistrer l\'Établissement'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }
}