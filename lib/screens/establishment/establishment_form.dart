import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../models/etablissement_model.dart';
import '../../services/database_service.dart';
import '../../utils/validators.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/arrondissement_provider.dart';
import '../../widgets/arrondissement_dropdown.dart';
import 'package:geolocator/geolocator.dart';

class EstablishmentForm extends StatefulWidget {
  @override
  _EstablishmentFormState createState() => _EstablishmentFormState();
}

class _EstablishmentFormState extends State<EstablishmentForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _superficieController = TextEditingController();
  String? _selectedCategorie;
  String? _selectedArrondissement;
  bool _statut = true;
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerCinController = TextEditingController();
  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _tenantActivityController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  bool _isLoading = false;
  final DatabaseService _databaseService = DatabaseService();

  final List<String> _categories = [
    'Seller of fruits',
    'Magazin',
    'Restaurant',
    'Clothing',
    'Electronics',
    'Other',
  ];

  @override
  void dispose() {
    _matriculeController.dispose();
    _addressController.dispose();
    _superficieController.dispose();
    _ownerNameController.dispose();
    _ownerCinController.dispose();
    _tenantNameController.dispose();
    _tenantActivityController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
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
    final createdBy = authProvider.user?.name ?? 'Unknown';

    final newEtablissement = EtablissementModel(
      artNouvCode: _matriculeController.text.trim(),
      artDebPer: null,
      artFinPer: null,
      artImp: null,
      artTauxPres: null,
      artDateDebImp: null,
      artDateFinImp: null,
      artMntTaxe: null,
      artAgent: createdBy,
      artDateSaisie: DateTime.now(),
      artRedCode: _ownerCinController.text.trim(),
      artMond: _tenantNameController.text.trim(),
      artOccup: _tenantActivityController.text.trim(),
      artArrond: _selectedArrondissement ?? '01', // Use selected arrondissement or default
      artRue: '001', // Default rue
      artTexteAdresse: _addressController.text.trim(),
      artSurTot: double.tryParse(_superficieController.text.trim()),
      artSurCouv: null,
      artPrixRef: null,
      artCatArt: _selectedCategorie ?? '',
      artQualOccup: null,
      artSurCont: null,
      artSurDecl: null,
      artPrixMetre: null,
      artBaseTaxe: null,
      artEtat: _statut ? 1 : 0,
      artTaxeOffice: null,
      artNumRole: null,
      codeGouv: null,
      codeDeleg: null,
      codeImeda: null,
      codeCom: null,
      redTypePrpor: null,
      artTelDecl: _ownerCinController.text.trim(),
      artEmailDecl: '',
      artCommentaire: null,
      artCatActivite: null,
      artNomCommerce: _ownerNameController.text.trim(),
      artOccupVoie: null,
      artLatitude: double.tryParse(_latitudeController.text.trim()) ?? 0.0,
      artLongitude: double.tryParse(_longitudeController.text.trim()) ?? 0.0,
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

  @override
  void initState() {
    super.initState();
    // Load arrondissements when the form is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arrondissementProvider = Provider.of<ArrondissementProvider>(context, listen: false);
      arrondissementProvider.fetchArrondissementsActifs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire Établissement'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _matriculeController,
                      decoration: InputDecoration(labelText: 'Matricule'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir le matricule';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Adresse'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir l\'adresse';
                        }
                        return null;
                      },
                    ),
                    Consumer<ArrondissementProvider>(
                      builder: (context, provider, child) {
                        return ArrondissementDropdown(
                          selectedValue: _selectedArrondissement,
                          onChanged: (value) {
                            setState(() {
                              _selectedArrondissement = value;
                            });
                          },
                        );
                      },
                    ),
                    TextFormField(
                      controller: _superficieController,
                      decoration: InputDecoration(labelText: 'Superficie (m²)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir la superficie';
                        }
                        if (num.tryParse(value) == null) {
                          return 'Veuillez saisir un nombre valide';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedCategorie,
                      decoration: InputDecoration(labelText: 'Categorie'),
                      items: _categories
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategorie = val;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a categorie';
                        }
                        return null;
                      },
                    ),
                    SwitchListTile(
                      title: Text('Statut (Open)'),
                      value: _statut,
                      onChanged: (val) {
                        setState(() {
                          _statut = val;
                        });
                      },
                    ),
                    TextFormField(
                      controller: _ownerNameController,
                      decoration: InputDecoration(labelText: 'Owner Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter owner name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ownerCinController,
                      decoration: InputDecoration(labelText: 'Owner CIN'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter owner CIN';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _tenantNameController,
                      decoration: InputDecoration(labelText: 'Tenant Name'),
                    ),
                    TextFormField(
                      controller: _tenantActivityController,
                      decoration: InputDecoration(labelText: 'Tenant Activity'),
                    ),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(labelText: 'Latitude'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter latitude';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid latitude';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(labelText: 'Longitude'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter longitude';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid longitude';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
