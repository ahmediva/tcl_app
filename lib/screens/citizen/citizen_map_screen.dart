import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/citizen_model.dart';
import '../../models/etablissement_model.dart';

class CitizenMapScreen extends StatefulWidget {
  @override
  _CitizenMapScreenState createState() => _CitizenMapScreenState();
}

class _CitizenMapScreenState extends State<CitizenMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isLoading = true;
  TCLCitizen? _citizen;
  List<EtablissementModel> _establishments = [];
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    // Don't access context-dependent data here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedData) {
      _loadData();
    }
  }

  void _loadData() {
    // Get data from route arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _citizen = args['citizen'] as TCLCitizen;
        _establishments = args['establishments'] as List<EtablissementModel>;
        _markers = _createMarkers(_establishments);
        _isLoading = false;
        _hasLoadedData = true;
      });
    } else {
      // If no arguments provided, show empty state
      setState(() {
        _isLoading = false;
        _hasLoadedData = true;
      });
    }
  }

  Set<Marker> _createMarkers(List<EtablissementModel> establishments) {
    return establishments
        .where((establishment) => 
            establishment.artLatitude != null && 
            establishment.artLongitude != null &&
            establishment.artLatitude! != 0.0 &&
            establishment.artLongitude! != 0.0)
        .map((establishment) {
      final lat = establishment.artLatitude!;
      final lng = establishment.artLongitude!;
      
      return Marker(
        markerId: MarkerId(establishment.artNouvCode),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: establishment.artNomCommerce ?? 'Établissement ${establishment.artNouvCode}',
          snippet: establishment.artAdresse ?? 'Adresse non spécifiée',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          establishment.artEtat == 1 ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueOrange,
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte - ${_citizen?.fullName ?? 'Citoyen'}'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Info bar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Text(
                        'CIN: ${_citizen?.cin ?? 'N/A'} - ${_establishments.length} établissement(s)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Map
                Expanded(
                  child: _establishments.isEmpty
                      ? _buildEmptyState()
                      : _markers.isEmpty
                          ? _buildNoCoordinatesState()
                          : GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                _mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(36.8065, 10.1815), // Tunis center
                                zoom: 10.0,
                              ),
                              markers: _markers,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                            ),
                ),
                
                // Legend
                if (_establishments.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem(
                          Icons.business,
                          Colors.green,
                          'Actif (${_establishments.where((e) => e.artEtat == 1).length})',
                        ),
                        _buildLegendItem(
                          Icons.pause_circle,
                          Colors.orange,
                          'Inactif (${_establishments.where((e) => e.artEtat == 0).length})',
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun établissement trouvé',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aucun établissement n\'est enregistré avec votre CIN',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCoordinatesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 64,
            color: Colors.orange[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun établissement sur la carte',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos établissements n\'ont pas de coordonnées géographiques',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Contactez votre agent pour ajouter les coordonnées',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
