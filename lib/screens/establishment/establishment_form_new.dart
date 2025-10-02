import 'package:flutter/material.dart';
import '../../models/etablissement_model.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/establishment_provider.dart';
import '../../widgets/arrondissement_dropdown.dart';
import '../../widgets/common/etablissement_dropdowns.dart';
import '../../widgets/location_picker.dart';

class EstablishmentFormNew extends StatefulWidget {
  @override
  _EstablishmentFormNewState createState() => _EstablishmentFormNewState();
}

class _EstablishmentFormNewState extends State<EstablishmentFormNew> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Controllers for all ARTICLE table fields
  final TextEditingController _artNouvCodeController = TextEditingController();
  final TextEditingController _artDebPerController = TextEditingController();
  final TextEditingController _artFinPerController = TextEditingController();
  final TextEditingController _artImpController = TextEditingController();
  final TextEditingController _artTauxPresController = TextEditingController();
  final TextEditingController _artDateDebImpController = TextEditingController();
  final TextEditingController _artDateFinImpController = TextEditingController();
  final TextEditingController _artMntTaxeController = TextEditingController();
  final TextEditingController _artAgentController = TextEditingController();
  final TextEditingController _artDateSaisieController = TextEditingController();
  final TextEditingController _artRedCodeController = TextEditingController();
  final TextEditingController _artMondController = TextEditingController();
  final TextEditingController _artOccupController = TextEditingController();
  final TextEditingController _artArrondController = TextEditingController();
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
  final TextEditingController _artEtatController = TextEditingController();
  final TextEditingController _codeGouvController = TextEditingController();
  final TextEditingController _codeDelegController = TextEditingController();
  final TextEditingController _codeImedaController = TextEditingController();
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
  String? _selectedEtat;
  String? _selectedRedTypePrpor;
  String? _selectedCatActivite;
  int _artImp = 1; // Default to 1 (imposable)
  int _artOccupVoie = 0; // Default to 0 (ne occupe pas la voie)
  int _artEtat = 1; // Default to 1 (pays taxe)
  bool _isLoading = false;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    // Set default values
    _artDateSaisieController.text = DateTime.now().toString().split(' ')[0];
    _artAgentController.text = 'Agent TCL';
    _selectedEtat = '1'; // Default to "Paye Taxe"
    _selectedRedTypePrpor = '1'; // Default to Type 1
    _selectedCatActivite = '1'; // Default to Catégorie 1
    // No need to load arrondissements - they're now static in EtablissementModel
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Dispose all controllers
    _artNouvCodeController.dispose();
    _artDebPerController.dispose();
    _artFinPerController.dispose();
    _artImpController.dispose();
    _artTauxPresController.dispose();
    _artDateDebImpController.dispose();
    _artDateFinImpController.dispose();
    _artMntTaxeController.dispose();
    _artAgentController.dispose();
    _artDateSaisieController.dispose();
    _artRedCodeController.dispose();
    _artMondController.dispose();
    _artOccupController.dispose();
    _artArrondController.dispose();
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
    _artEtatController.dispose();
    _codeGouvController.dispose();
    _codeDelegController.dispose();
    _codeImedaController.dispose();
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
    final establishmentProvider = Provider.of<EstablishmentProvider>(context, listen: false);
    final createdBy = authProvider.user?.fullName ?? 'Unknown';

    final newEtablissement = EtablissementModel(
      artNouvCode: _artNouvCodeController.text.trim(),
      artDebPer: _artDebPerController.text.isNotEmpty ? int.tryParse(_artDebPerController.text.replaceAll('-', '')) : null,
      artFinPer: _artFinPerController.text.isNotEmpty ? int.tryParse(_artFinPerController.text.replaceAll('-', '')) : null,
      artImp: _artImp,
      artTauxPres: double.tryParse(_artTauxPresController.text.trim()),
      artDateDebImp: _artDateDebImpController.text.isNotEmpty ? DateTime.tryParse(_artDateDebImpController.text) : null,
      artDateFinImp: _artDateFinImpController.text.isNotEmpty ? DateTime.tryParse(_artDateFinImpController.text) : null,
      artMntTaxe: double.tryParse(_artMntTaxeController.text.trim()),
      artAgentSaisie: _artAgentController.text.trim(),
      artDateSaisie: _artDateSaisieController.text.isNotEmpty ? DateTime.tryParse(_artDateSaisieController.text) : DateTime.now(),
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
      artEtat: int.tryParse(_selectedEtat ?? '1') ?? 1,
      artTaxeOffice: null,
      artNumRole: null,
      codeGouv: int.tryParse(_codeGouvController.text.trim()),
      codeDeleg: int.tryParse(_codeDelegController.text.trim()),
      codeImeda: int.tryParse(_codeImedaController.text.trim()),
      codeCom: _codeComController.text.trim(),
      redTypePrpor: int.tryParse(_selectedRedTypePrpor ?? '1') ?? 1,
      artTelDecl: _artTelDeclController.text.trim(),
      artEmailDecl: _artEmailDeclController.text.trim(),
      artCommentaire: _artCommentaireController.text.trim(),
      artCatActivite: int.tryParse(_selectedCatActivite ?? '1') ?? 1,
      artNomCommerce: _artNomCommerceController.text.trim(),
      artOccupVoie: _artOccupVoie,
      artLatitude: double.tryParse(_artLatitudeController.text.trim()) ?? 0.0,
      artLongitude: double.tryParse(_artLongitudeController.text.trim()) ?? 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await establishmentProvider.addEtablissement(newEtablissement);

    setState(() {
      _isLoading = false;
    });

    if (success) {
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
        title: Text('العقار - Formulaire ARTICLE'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'العقار', icon: Icon(Icons.home)),
            Tab(text: 'المالك', icon: Icon(Icons.person)),
            Tab(text: 'الشاغل', icon: Icon(Icons.business)),
            Tab(text: 'النشاط', icon: Icon(Icons.work)),
            Tab(text: 'المساحة', icon: Icon(Icons.square_foot)),
            Tab(text: 'الإحداثيات', icon: Icon(Icons.location_on)),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPropertyTab(),
                  _buildOwnerTab(),
                  _buildOccupantTab(),
                  _buildActivityTab(),
                  _buildAreaTab(),
                  _buildCoordinatesTab(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitForm,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        icon: Icon(Icons.save),
        label: Text('Enregistrer'),
      ),
    );
  }

  // Tab 1: العقار (Property) - Basic property information
  Widget _buildPropertyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Informations de Base - العقار'),
          
          // Top section - Property details
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _artNouvCodeController,
                  decoration: InputDecoration(
                    labelText: 'الرمز - Code Article (ArtNouvCode) *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le code article est obligatoire';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _artTauxPresController,
                  decoration: InputDecoration(
                    labelText: 'الثمن المرجعي - Prix Référence (ArtTauxPres)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
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
                  controller: _artDateDebImpController,
                  decoration: InputDecoration(
                    labelText: 'بداية توظيف الأداء - Date Début Imposable (ArtDateDebImp)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
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
                      _artDateDebImpController.text = date.toString().split(' ')[0];
                    }
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _artMntTaxeController,
                  decoration: InputDecoration(
                    labelText: 'المبلغ الجملي للمعلوم - Montant Taxe (ArtMntTaxe)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.euro),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Status section
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _artEtat,
                  decoration: InputDecoration(
                    labelText: 'الحالة - État (ArtEtat)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.info),
                  ),
                  items: [
                    DropdownMenuItem<int>(value: 1, child: Text('خاضع للمعلوم - Paye Taxe')),
                    DropdownMenuItem<int>(value: 0, child: Text('غير خاضع للمعلوم - Ne Paye Pas')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _artEtat = value ?? 1;
                    });
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _artImp,
                  decoration: InputDecoration(
                    labelText: 'Imposable (ArtImp)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                  items: [
                    DropdownMenuItem<int>(value: 1, child: Text('Oui')),
                    DropdownMenuItem<int>(value: 0, child: Text('Non')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _artImp = value ?? 1;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Administrative information
          _buildSectionHeader('Informations Administratives'),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _artAgentController,
                  decoration: InputDecoration(
                    labelText: 'عون الاحصاء - Agent (ArtAgent)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _artDateSaisieController,
                  decoration: InputDecoration(
                    labelText: 'تاريخ الادراج - Date Saisie (ArtDateSaisie)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
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
          SizedBox(height: 16),

          // Period information
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _artDebPerController,
                  decoration: InputDecoration(
                    labelText: 'Début Période (ArtDebPer)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
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
                      _artDebPerController.text = date.toString().split(' ')[0];
                    }
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _artFinPerController,
                  decoration: InputDecoration(
                    labelText: 'Fin Période (ArtFinPer)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
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
                      _artFinPerController.text = date.toString().split(' ')[0];
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Administrative codes
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
                  controller: _codeImedaController,
                  decoration: InputDecoration(
                    labelText: 'Code Imeda (CodeImeda)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16),
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
            ],
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: _artCommentaireController,
            decoration: InputDecoration(
              labelText: 'الملاحظات - Commentaire (ArtCommentaire)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.comment),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // Tab 2: المالك (Owner) - Owner information
  Widget _buildOwnerTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Informations Propriétaire - المالك'),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _artRedCodeController,
                  decoration: InputDecoration(
                    labelText: 'CIN Propriétaire (ArtRedCode)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _redTypePrporController,
                  decoration: InputDecoration(
                    labelText: 'Type Propriétaire (RedTypePrpor)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home_work),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: _artMondController,
            decoration: InputDecoration(
              labelText: 'Mondataire (ArtMond)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 16),

          // Contact information
          _buildSectionHeader('Contact Propriétaire'),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _artTelDeclController,
                  decoration: InputDecoration(
                    labelText: 'Téléphone Domicile (ArtTelDecl)',
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
                    labelText: 'Email Déclamateur (ArtEmailDecl)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 3: الشاغل (Occupant) - Occupant information
  Widget _buildOccupantTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Informations Occupant - الشاغل'),
          
          TextFormField(
            controller: _artOccupController,
            decoration: InputDecoration(
              labelText: 'Occupant (ArtOccup)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: _artQualOccupController,
            decoration: InputDecoration(
              labelText: 'Qualité Occupation (ArtQualOccup)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.star),
            ),
          ),
          SizedBox(height: 16),

          // Commercial information
          _buildSectionHeader('Informations Commerciales'),
          
          TextFormField(
            controller: _artNomCommerceController,
            decoration: InputDecoration(
              labelText: 'الاسم التجاري - Nom Commerce (ArtNomCommerce)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.store),
            ),
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
                child: DropdownButtonFormField<int>(
                  value: _artOccupVoie,
                  decoration: InputDecoration(
                    labelText: 'Occupation Voie (ArtOccupVoie)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car),
                  ),
                  items: [
                    DropdownMenuItem<int>(value: 1, child: Text('Oui')),
                    DropdownMenuItem<int>(value: 0, child: Text('Non')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _artOccupVoie = value ?? 0;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 4: النشاط (Activity) - Activity information
  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Informations Activité - النشاط'),
          
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
                  controller: _artPrixRefController,
                  decoration: InputDecoration(
                    labelText: 'Prix Référence (ArtPrixRef)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.price_check),
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
                  controller: _artPrixMetreController,
                  decoration: InputDecoration(
                    labelText: 'Prix au M² (ArtPrixMetre)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 5: المساحة (Area) - Area information
  Widget _buildAreaTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Informations Surface - المساحة'),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _artSurTotController,
                  decoration: InputDecoration(
                    labelText: 'المساحة الجملية - Surface Totale (ArtSurTot)',
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
                    labelText: 'المساحة المغطاة - Surface Couverte (ArtSurCouv)',
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
                    labelText: 'اSurface Contrôlé (ArtSurCont)',
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
                    labelText: ' Surface Déclarée ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.assignment),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Address information
          _buildSectionHeader('Adresse - العنوان'),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _artRueController,
                  decoration: InputDecoration(
                    labelText: 'النهج - Rue (ArtRue)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.streetview),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ArrondissementDropdown(
                  selectedValue: _selectedArrondissement,
                  onChanged: (value) {
                    setState(() {
                      _selectedArrondissement = value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: _artTexteAdresseController,
            decoration: InputDecoration(
              labelText: ' Adresse Complète (ArtTexteAdresse)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // Tab 6: الإحداثيات (Coordinates) - Location information
  Widget _buildCoordinatesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Position Géographique - الإحداثيات'),
          
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
        ],
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
