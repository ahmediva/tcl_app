import 'dart:convert';

class GoogleMapsConfig {
  // Google Maps API key for Android
  static const String apiKey = 'AIzaSyBkgIRFqUXtBumLkCkstDOhaJgOPGfIEAs';
  
  // Default map settings for Tunisia
  static const double defaultLatitude = 36.8065;  // Tunis center
  static const double defaultLongitude = 10.1815; // Tunis center
  static const double defaultZoom = 10.0;
  
  // Map style for a professional look
  static const String mapStyle = '''
[
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "landscape",
    "stylers": [
      {
        "color": "#f5f5f2"
      }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "water",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  }
]
''';
  
  // Check if API key is configured
  static bool get isConfigured => apiKey.isNotEmpty && apiKey != 'AIzaSyBkgIRFqUXtBumLkCkstDOhaJgOPGfIEAs';
  
  // Get map style as a list
  static List<Map<String, dynamic>> get mapStyleList {
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(mapStyle));
    } catch (e) {
      print('Error parsing map style: $e');
      return [];
    }
  }
}
