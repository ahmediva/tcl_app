import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/etablissement_model.dart';
import '../../providers/establishment_provider.dart';

class EstablishmentMapScreen extends StatefulWidget {
  const EstablishmentMapScreen({Key? key}) : super(key: key);

  @override
  State<EstablishmentMapScreen> createState() => _EstablishmentMapScreenState();
}

class _EstablishmentMapScreenState extends State<EstablishmentMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  EtablissementModel? _selectedEstablishment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEstablishments();
    });
  }

  Future<void> _loadEstablishments() async {
    final establishmentProvider = Provider.of<EstablishmentProvider>(context, listen: false);
    await establishmentProvider.fetchEtablissements();
    
    setState(() {
      _markers = _createMarkers(establishmentProvider.etablissements);
      _isLoading = false;
    });
  }

  Set<Marker> _createMarkers(List<EtablissementModel> establishments) {
    return establishments
        .where((establishment) => 
            establishment.artLatitude != null && 
            establishment.artLongitude != null)
        .map((establishment) {
      return Marker(
        markerId: MarkerId(establishment.artNouvCode),
        position: LatLng(
          establishment.artLatitude!,
          establishment.artLongitude!,
        ),
        infoWindow: InfoWindow(
          title: establishment.artNomCommerce ?? 'Établissement',
          snippet: establishment.artAdresse ?? '',
        ),
        onTap: () {
          setState(() {
            _selectedEstablishment = establishment;
          });
          _showEstablishmentInfo();
        },
      );
    }).toSet();
  }

  void _showEstablishmentInfo() {
    if (_selectedEstablishment == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            _selectedEstablishment!.artNomCommerce ?? 'Établissement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Code', _selectedEstablishment!.artNouvCode),
              _buildInfoRow('Catégorie', _selectedEstablishment!.artCatArt ?? 'Non spécifiée'),
              _buildInfoRow('Statut', _getStatusText(_selectedEstablishment!.artEtat)),
              _buildInfoRow('Adresse', _selectedEstablishment!.artAdresse ?? 'Non spécifiée'),
              _buildInfoRow('Propriétaire', _selectedEstablishment!.artProprietaire ?? 'Non spécifié'),
              _buildInfoRow('Montant TCL', '${_selectedEstablishment!.artMntTaxe?.toStringAsFixed(2) ?? '0.00'} DT'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Fermer',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(int? status) {
    switch (status) {
      case 1:
        return 'Actif';
      case 0:
        return 'Inactif';
      default:
        return 'Non défini';
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    
    // Centrer la carte sur Tunis si des établissements existent
    if (_markers.isNotEmpty) {
      final firstMarker = _markers.first;
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(firstMarker.position),
      );
    } else {
      // Position par défaut : Tunis
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(36.8065, 10.1815), // Tunis
          10,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte des Établissements'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadEstablishments();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(36.8065, 10.1815), // Tunis
                    zoom: 10,
                  ),
                  markers: _markers,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                if (_markers.isEmpty)
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Aucun établissement avec géolocalisation',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Les établissements doivent avoir des coordonnées GPS pour apparaître sur la carte.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Centrer la carte sur tous les établissements
          if (_markers.isNotEmpty) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLngBounds(
                _getBounds(),
                100,
              ),
            );
          }
        },
        child: Icon(Icons.center_focus_strong),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
    );
  }

  LatLngBounds _getBounds() {
    if (_markers.isEmpty) {
      return LatLngBounds(
        southwest: LatLng(36.0, 10.0),
        northeast: LatLng(37.0, 11.0),
      );
    }

    double minLat = _markers.first.position.latitude;
    double maxLat = _markers.first.position.latitude;
    double minLng = _markers.first.position.longitude;
    double maxLng = _markers.first.position.longitude;

    for (Marker marker in _markers) {
      minLat = minLat < marker.position.latitude ? minLat : marker.position.latitude;
      maxLat = maxLat > marker.position.latitude ? maxLat : marker.position.latitude;
      minLng = minLng < marker.position.longitude ? minLng : marker.position.longitude;
      maxLng = maxLng > marker.position.longitude ? maxLng : marker.position.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
