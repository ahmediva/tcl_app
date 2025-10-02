import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/etablissement_model.dart';
import '../config/google_maps_config.dart';

class ArrondissementMapSelector extends StatefulWidget {
  final String? selectedArrondissementCode;
  final Function(String) onArrondissementSelected;
  final double height;
  final double width;

  const ArrondissementMapSelector({
    Key? key,
    this.selectedArrondissementCode,
    required this.onArrondissementSelected,
    this.height = 300,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  _ArrondissementMapSelectorState createState() => _ArrondissementMapSelectorState();
}

class _ArrondissementMapSelectorState extends State<ArrondissementMapSelector> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isMapInitialized = false;
  
  // Default coordinates for Tunisia (you can adjust these)
  static const LatLng _defaultCenter = LatLng(36.8065, 10.1815);
  static const double _defaultZoom = 10.0;

  @override
  void initState() {
    super.initState();
    _updateMapData();
  }

  void _updateMapData() {
    _markers.clear();

    // Add markers for each arrondissement (using static data)
    for (final arrondissement in EtablissementModel.arrondissements) {
      // For now, we'll use default coordinates for each arrondissement
      // In a real app, you'd have actual coordinates for each arrondissement
      final latLng = _getArrondissementCoordinates(arrondissement['code']!);
      
      _markers.add(
        Marker(
          markerId: MarkerId(arrondissement['code']!),
          position: latLng,
          infoWindow: InfoWindow(
            title: arrondissement['libelle'],
            snippet: 'Code: ${arrondissement['code']}',
          ),
          onTap: () => _selectArrondissement(arrondissement['code']!),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  // Get coordinates for each arrondissement (you can customize these)
  LatLng _getArrondissementCoordinates(String code) {
    // Default coordinates for different arrondissements
    // You can customize these based on actual locations
    switch (code) {
      case '01': return LatLng(36.8065, 10.1815);
      case '02': return LatLng(36.8165, 10.1915);
      case '03': return LatLng(36.8265, 10.2015);
      case '04': return LatLng(36.8365, 10.2115);
      case '05': return LatLng(36.8465, 10.2215);
      case '06': return LatLng(36.8565, 10.2315);
      case '07': return LatLng(36.8665, 10.2415);
      case '08': return LatLng(36.8765, 10.2515);
      case '09': return LatLng(36.8865, 10.2615);
      case '10': return LatLng(36.8965, 10.2715);
      case '11': return LatLng(36.9065, 10.2815);
      case '12': return LatLng(36.9165, 10.2915);
      case '13': return LatLng(36.9265, 10.3015);
      case '14': return LatLng(36.9365, 10.3115);
      case '15': return LatLng(36.9465, 10.3215);
      case '16': return LatLng(36.9565, 10.3315);
      default: return _defaultCenter;
    }
  }

  void _selectArrondissement(String code) {
    widget.onArrondissementSelected(code);
    setState(() {
      _updateMapData(); // Refresh to update marker colors
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if Google Maps is properly configured
    if (!GoogleMapsConfig.isConfigured) {
      return _buildFallbackWidget(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with instructions
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.map, color: Colors.blue[700]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sélectionnez un arrondissement sur la carte',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Google Map
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: Builder(
              builder: (context) {
                try {
                  return GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      _isMapInitialized = true;
                      _updateMapData();
                    },
                    initialCameraPosition: CameraPosition(
                      target: _defaultCenter,
                      zoom: _defaultZoom,
                    ),
                    markers: _markers,
                    onTap: (LatLng position) {
                      // Find the closest arrondissement to the tapped position
                      _findClosestArrondissement(position);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: true,
                  );
                } catch (e) {
                  return Container(
                    color: Colors.red[50],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 48),
                          SizedBox(height: 8),
                          Text(
                            'Erreur Google Maps',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Vérifiez votre configuration',
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        
        // Selected arrondissement info
        if (widget.selectedArrondissementCode != null) ...[
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arrondissement sélectionné:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        EtablissementModel.arrondissements
                            .firstWhere((a) => a['code'] == widget.selectedArrondissementCode)['libelle'] ?? 'Inconnu',
                        style: TextStyle(color: Colors.green[700]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onArrondissementSelected(''),
                  icon: Icon(Icons.clear, color: Colors.green[700]),
                  tooltip: 'Désélectionner',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _findClosestArrondissement(LatLng position) {
    String closestCode = EtablissementModel.arrondissements.first['code']!;
    double minDistance = double.infinity;

    for (final arrondissement in EtablissementModel.arrondissements) {
      final arrondissementLatLng = _getArrondissementCoordinates(arrondissement['code']!);
      final distance = _calculateDistance(
        position.latitude,
        position.longitude,
        arrondissementLatLng.latitude,
        arrondissementLatLng.longitude,
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        closestCode = arrondissement['code']!;
      }
    }

    // Select the closest arrondissement
    _selectArrondissement(closestCode);
    
    // Animate camera to the selected arrondissement
    if (_mapController != null && _isMapInitialized) {
      final closestLatLng = _getArrondissementCoordinates(closestCode);
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(closestLatLng, 12.0),
      );
    }
  }

  // Calculate distance between two points using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(_degreesToRadians(lat1)) * sin(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  Widget _buildFallbackWidget(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, color: Colors.orange[700], size: 48),
            SizedBox(height: 8),
            Text(
              'Google Maps non configuré',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Veuillez configurer votre clé API Google Maps dans lib/config/google_maps_config.dart',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange[700]),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Show instructions for API key setup
                _showApiKeyInstructions(context);
              },
              icon: Icon(Icons.help),
              label: Text('Instructions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Utilisez le dropdown ci-dessous en attendant',
              style: TextStyle(
                color: Colors.orange[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showApiKeyInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Configuration Google Maps'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pour utiliser Google Maps, vous devez :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('1. Aller sur Google Cloud Console'),
                Text('2. Créer un projet ou sélectionner un existant'),
                Text('3. Activer Maps SDK for Android/iOS'),
                Text('4. Créer des identifiants API'),
                Text('5. Mettre à jour lib/config/google_maps_config.dart'),
                SizedBox(height: 16),
                Text(
                  'Lien : https://console.cloud.google.com/apis/credentials',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}