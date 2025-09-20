import 'package:flutter/material.dart';
import '../../widgets/location_picker.dart';

class LocationPickerDemo extends StatefulWidget {
  @override
  _LocationPickerDemoState createState() => _LocationPickerDemoState();
}

class _LocationPickerDemoState extends State<LocationPickerDemo> {
  double? _selectedLatitude;
  double? _selectedLongitude;
  String? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Démo Sélection d\'Emplacement'),
        backgroundColor: Colors.pink[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700]),
                      SizedBox(width: 8),
                      Text(
                        'Démo du sélecteur d\'emplacement',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cette démo montre comment utiliser le sélecteur d\'emplacement avec Google Maps pour sélectionner les coordonnées d\'un établissement.',
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Location picker button
            ElevatedButton.icon(
              onPressed: _openLocationPicker,
              icon: Icon(Icons.location_on, color: Colors.white),
              label: Text('Ouvrir le sélecteur d\'emplacement'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Selected location display
            if (_selectedLatitude != null && _selectedLongitude != null) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700]),
                        SizedBox(width: 8),
                        Text(
                          'Emplacement sélectionné',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Latitude: ${_selectedLatitude!.toStringAsFixed(6)}',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                    Text(
                      'Longitude: ${_selectedLongitude!.toStringAsFixed(6)}',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                    if (_selectedAddress != null) ...[
                      SizedBox(height: 8),
                      Text(
                        'Adresse: $_selectedAddress',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_off, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text(
                      'Aucun emplacement sélectionné',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 24),

            // Features list
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange[700]),
                      SizedBox(width: 8),
                      Text(
                        'Fonctionnalités du sélecteur',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildFeatureItem('📍 Marqueur rose pour la sélection'),
                  _buildFeatureItem('🗺️ Carte Google Maps interactive'),
                  _buildFeatureItem('📍 Bouton "Ma position" pour géolocalisation'),
                  _buildFeatureItem('📱 Interface mobile optimisée'),
                  _buildFeatureItem('✅ Confirmation visuelle de la sélection'),
                  _buildFeatureItem('🔄 Coordonnées mises à jour en temps réel'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.orange[600], size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.orange[600]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          initialLatitude: _selectedLatitude,
          initialLongitude: _selectedLongitude,
          address: _selectedAddress,
          onLocationSelected: (latitude, longitude) {
            setState(() {
              _selectedLatitude = latitude;
              _selectedLongitude = longitude;
            });
          },
        ),
      ),
    );
  }
}
