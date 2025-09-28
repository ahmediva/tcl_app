import 'package:flutter/material.dart';
import '../../models/etablissement_model.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/arrondissement_provider.dart';
import '../../widgets/arrondissement_dropdown.dart';
import '../../widgets/arrondissement_map_selector.dart';
import '../../widgets/location_picker.dart';

class EstablishmentForm extends StatefulWidget {
  @override
  _EstablishmentFormState createState() => _EstablishmentFormState();
}

class _EstablishmentFormState extends State<EstablishmentForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Controllers for all ARTICLE table fields
  final TextEditingController _artNouvCodeController = TextEditingController();
  final TextEditingController _artImpController = TextEditingController();
  final TextEditingController _artTauxPresController = TextEditingController();
  final TextEditingController _artMntTaxeController = TextEditingController();
  final TextEditingController _artRedCodeController = TextEditingController();
  final TextEditingController _artMondController = TextEditingController();
  final TextEditingController _artOccupController = TextEditingController();
  final TextEditingController _artRueController = TextEditingController();
  final TextEditingController _artTexteAdresseController = TextEditingController();
  final TextEditingController _artSurTotController = TextEditingController();
  final TextEditingController _artSurCouvController = TextEditingController();
  final TextEditingController _artPrixRefController = TextEditingController();
  final TextEditingController _artCatArtController = TextEditingController();
  final TextEditingController _artQualOccupController = TextEditingController();
  final TextEditingController _artSurContController = TextEditingController();
  final TextEditingController _artSurDeclController = TextEditingController();
  final TextEditingController _artPrixMetreController = TextEditingController();
  final TextEditingController _artBaseTaxeController = TextEditingController();
  final TextEditingController _codeGouvController = TextEditingController();
  final TextEditingController _codeDelegController = TextEditingController();
  final TextEditingController _codeComController = TextEditingController();
  final TextEditingController _redTypePrporController = TextEditingController();
  final TextEditingController _artTelDeclController = TextEditingController();
  final TextEditingController _artEmailDeclController = TextEditingController();
  final TextEditingController _artCommentaireController = TextEditingController();
  final TextEditingController _artCatActiviteController = TextEditingController();
  final TextEditingController _artNomCommerceController = TextEditingController();
  final TextEditingController _artOccupVoieController = TextEditingController();
  final TextEditingController _artLatitudeController = TextEditingController();
  final TextEditingController _artLongitudeController = TextEditingController();

  String? _selectedArrondissement;
  int _artEtat = 1; // Default to 1 (active)
  bool _isLoading = false;
  final DatabaseService _databaseService = DatabaseService();

  // Dropdown options
  final List<String> _etatOptions = ['1', '0']; // 1 = Active, 0 = Inactive
  final List<String> _redTypePrporOptions = ['1', '2', '3']; // Property types
  final List<String> _artCatActiviteOptions = ['1', '2', '3', '4', '5']; // Activity categories

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    // Load arrondissements when the form is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arrondissementProvider = Provider.of<ArrondissementProvider>(context, listen: false);
      arrondissementProvider.fetchArrondissementsActifs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Dispose all controllers
    _artNouvCodeController.dispose();
    _artImpController.dispose();
    _artTauxPresController.dispose();
    _artMntTaxeController.dispose();
    _artRedCodeController.dispose();
    _artMondController.dispose();
    _artOccupController.dispose();
    _artRueController.dispose();
    _artTexteAdresseController.dispose();
    _artSurTotController.dispose();
    _artSurCouvController.dispose();
    _artPrixRefController.dispose();
    _artCatArtController.dispose();
    _artQualOccupController.dispose();
    _artSurContController.dispose();
    _artSurDeclController.dispose();
    _artPrixMetreController.dispose();
    _artBaseTaxeController.dispose();
    _codeGouvController.dispose();
    _codeDelegController.dispose();
    _codeComController.dispose();
    _redTypePrporController.dispose();
    _artTelDeclController.dispose();
    _artEmailDeclController.dispose();
    _artCommentaireController.dispose();
    _artCatActiviteController.dispose();
    _artNomCommerceController.dispose();
    _artOccupVoieController.dispose();
    _artLatitudeController.dispose();
    _artLongitudeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final createdBy = authProvider.user?.fullName ?? 'Unknown';

    final newEtablissement = EtablissementModel(
      artNouvCode: _artNouvCodeController.text.trim(),
      artDebPer: null,
      artFinPer: null,
      artImp: int.tryParse(_artImpController.text.trim()),
      artTauxPres: double.tryParse(_artTauxPresController.text.trim()),
      artDateDebImp: null,
      artDateFinImp: null,
      artMntTaxe: double.tryParse(_artMntTaxeController.text.trim()),
      artAgentSaisie: createdBy,
      artDateSaisie: DateTime.now(),
      artRedCode: _artRedCodeController.text.trim(),
      artMond: _artMondController.text.trim(),
      artOccup: _artOccupController.text.trim(),
      artArrond: _selectedArrondissement ?? '01',
      artRue: _artRueController.text.trim(),
      artTexteAdresse: _artTexteAdresseController.text.trim(),
      artSurTot: double.tryParse(_artSurTotController.text.trim()),
      artSurCouv: double.tryParse(_artSurCouvController.text.trim()),
      artPrixRef: double.tryParse(_artPrixRefController.text.trim()),
      artCatArt: _artCatArtController.text.trim(),
      artQualOccup: _artQualOccupController.text.trim(),
      artSurCont: double.tryParse(_artSurContController.text.trim()),
      artSurDecl: double.tryParse(_artSurDeclController.text.trim()),
      artPrixMetre: double.tryParse(_artPrixMetreController.text.trim()),
      artBaseTaxe: int.tryParse(_artBaseTaxeController.text.trim()),
      artEtat: _artEtat,
      artTaxeOffice: null,
      artNumRole: null,
      codeGouv: int.tryParse(_codeGouvController.text.trim()),
      codeDeleg: int.tryParse(_codeDelegController.text.trim()),
      codeImeda: null,
      codeCom: _codeComController.text.trim(),
      redTypePrpor: int.tryParse(_redTypePrporController.text.trim()),
      artTelDecl: _artTelDeclController.text.trim(),
      artEmailDecl: _artEmailDeclController.text.trim(),
      artCommentaire: _artCommentaireController.text.trim(),
      artCatActivite: int.tryParse(_artCatActiviteController.text.trim()),
      artNomCommerce: _artNomCommerceController.text.trim(),
      artOccupVoie: int.tryParse(_artOccupVoieController.text.trim()),
      artLatitude: double.tryParse(_artLatitudeController.text.trim()) ?? 0.0,
      artLongitude: double.tryParse(_artLongitudeController.text.trim()) ?? 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _databaseService.addEtablissement(newEtablissement);

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Établissement ajouté avec succès!')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'ajout de l\'établissement. Veuillez réessayer.')),
      );
    }
  }


  Future<void> _openLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          initialLatitude: _artLatitudeController.text.isNotEmpty 
              ? double.tryParse(_artLatitudeController.text) 
              : null,
          initialLongitude: _artLongitudeController.text.isNotEmpty 
              ? double.tryParse(_artLongitudeController.text) 
              : null,
          address: _artTexteAdresseController.text.isNotEmpty 
              ? _artTexteAdresseController.text 
              : null,
          onLocationSelected: (latitude, longitude) {
            setState(() {
              _artLatitudeController.text = latitude.toStringAsFixed(6);
              _artLongitudeController.text = longitude.toStringAsFixed(6);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire Établissement - ARTICLE'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Section 1: Basic Information
                    _buildSectionHeader('Informations de Base'),
                    
                    TextFormField(
                      controller: _artNouvCodeController,
                      decoration: InputDecoration(
                        labelText: 'Code Article (ArtNouvCode) *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.qr_code),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le code article est obligatoire';
                        }
                        if (value.length > 12) {
                          return 'Le code ne peut pas dépasser 12 caractères';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Section 2: Tax Information
                    _buildSectionHeader('Informations Fiscales'),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artImpController,
                            decoration: InputDecoration(
                              labelText: 'Impôt (ArtImp)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.account_balance),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artTauxPresController,
                            decoration: InputDecoration(
                              labelText: 'Taux Présumé (ArtTauxPres)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.percent),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artMntTaxeController,
                            decoration: InputDecoration(
                              labelText: 'Montant Taxe (ArtMntTaxe)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.euro),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artBaseTaxeController,
                            decoration: InputDecoration(
                              labelText: 'Base Taxe (ArtBaseTaxe)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calculate),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                
                    
                    
                    // Google Maps Arrondissement Selector
                    _buildSectionHeader('Sélection de l\'Arrondissement'),
                  
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artRueController,
                            decoration: InputDecoration(
                              labelText: 'Rue (ArtRue) *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.streetview),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La rue est obligatoire';
                              }
                              if (value.length > 5) {
                                return 'Le code rue ne peut pas dépasser 5 caractères';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artTexteAdresseController,
                            decoration: InputDecoration(
                              labelText: 'Adresse Complète (ArtTexteAdresse)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ArrondissementDropdown(
                      selectedValue: _selectedArrondissement,
                      onChanged: (value) {
                        setState(() {
                          _selectedArrondissement = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    
                    

                    // Section 4: Property Information
                    _buildSectionHeader('Informations du Bien'),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artSurTotController,
                            decoration: InputDecoration(
                              labelText: 'Surface Totale (ArtSurTot)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.square_foot),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artSurCouvController,
                            decoration: InputDecoration(
                              labelText: 'Surface Couverte (ArtSurCouv)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.home),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artSurContController,
                            decoration: InputDecoration(
                              labelText: 'Surface Contrat (ArtSurCont)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.description),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artSurDeclController,
                            decoration: InputDecoration(
                              labelText: 'Surface Déclarée (ArtSurDecl)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.assignment),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artPrixRefController,
                            decoration: InputDecoration(
                              labelText: 'Prix Référence (ArtPrixRef)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.price_check),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artPrixMetreController,
                            decoration: InputDecoration(
                              labelText: 'Prix au M² (ArtPrixMetre)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Section 5: Category and Quality
                    _buildSectionHeader('Catégorie et Qualité'),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artCatArtController,
                            decoration: InputDecoration(
                              labelText: 'Catégorie Article (ArtCatArt)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.category),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artQualOccupController,
                            decoration: InputDecoration(
                              labelText: 'Qualité Occupation (ArtQualOccup)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.star),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Section 6: Owner and Tenant Information
                    _buildSectionHeader('Informations Propriétaire et Locataire'),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artRedCodeController,
                            decoration: InputDecoration(
                              labelText: 'Code Propriétaire (ArtRedCode)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artMondController,
                            decoration: InputDecoration(
                              labelText: 'Code Locataire (ArtMond)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artOccupController,
                            decoration: InputDecoration(
                              labelText: 'Occupation (ArtOccup)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artNomCommerceController,
                            decoration: InputDecoration(
                              labelText: 'Nom Commerce (ArtNomCommerce)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.store),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Section 7: Administrative Codes
                    _buildSectionHeader('Codes Administratifs'),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _codeGouvController,
                            decoration: InputDecoration(
                              labelText: 'Code Gouvernorat (CodeGouv)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_city),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _codeDelegController,
                            decoration: InputDecoration(
                              labelText: 'Code Délégation (CodeDeleg)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_city),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _codeComController,
                            decoration: InputDecoration(
                              labelText: 'Code Commune (CodeCom)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_city),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _redTypePrporController,
                            decoration: InputDecoration(
                              labelText: 'Type Propriété (RedTypePrpor)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.home_work),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Section 8: Contact and Additional Information
                    _buildSectionHeader('Contact et Informations Supplémentaires'),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artTelDeclController,
                            decoration: InputDecoration(
                              labelText: 'Téléphone (ArtTelDecl)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artEmailDeclController,
                            decoration: InputDecoration(
                              labelText: 'Email (ArtEmailDecl)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _artCommentaireController,
                      decoration: InputDecoration(
                        labelText: 'Commentaire (ArtCommentaire)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.comment),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artCatActiviteController,
                            decoration: InputDecoration(
                              labelText: 'Catégorie Activité (ArtCatActivite)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.work),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artOccupVoieController,
                            decoration: InputDecoration(
                              labelText: 'Occupation Voie (ArtOccupVoie)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.directions_car),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Section 9: Status and Coordinates
                    _buildSectionHeader('Statut et Coordonnées'),
                    
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _artEtat,
                            decoration: InputDecoration(
                              labelText: 'État (ArtEtat)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.info),
                            ),
                            items: _etatOptions.map((option) {
                              return DropdownMenuItem<int>(
                                value: int.parse(option),
                                child: Text(option == '1' ? 'Actif' : 'Inactif'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _artEtat = value ?? 1;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(), // Empty container for spacing
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Location Picker Section
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.pink[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.map, color: Colors.pink[600]),
                              SizedBox(width: 8),
                              Text(
                                'Sélection de l\'emplacement',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[700],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Utilisez la carte pour sélectionner précisément l\'emplacement de l\'établissement',
                            style: TextStyle(
                              color: Colors.pink[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _openLocationPicker,
                            icon: Icon(Icons.location_on, color: Colors.white),
                            label: Text('Ouvrir la carte'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _artLatitudeController,
                            decoration: InputDecoration(
                              labelText: 'Latitude (ArtLatitude)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                              suffixIcon: IconButton(
                                onPressed: _openLocationPicker,
                                icon: Icon(Icons.map, color: Colors.pink[600]),
                                tooltip: 'Sélectionner sur la carte',
                              ),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _artLongitudeController,
                            decoration: InputDecoration(
                              labelText: 'Longitude (ArtLongitude)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                              suffixIcon: IconButton(
                                onPressed: _openLocationPicker,
                                icon: Icon(Icons.map, color: Colors.pink[600]),
                                tooltip: 'Sélectionner sur la carte',
                              ),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Enregistrer l\'Établissement',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
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
