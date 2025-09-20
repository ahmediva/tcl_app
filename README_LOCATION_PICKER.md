# Location Picker Implementation

## Overview

This document describes the implementation of a location picker functionality with Google Maps API for the TCL mobile application. The feature allows users to select precise coordinates for establishments using an interactive map with a pink marker.

## Features

### 🗺️ Interactive Map Selection
- **Google Maps Integration**: Full Google Maps integration with interactive map
- **Pink Marker**: Custom pink marker (magenta hue) for location selection
- **Tap to Select**: Users can tap anywhere on the map to select a location
- **Real-time Updates**: Coordinates update immediately when location is selected

### 📍 Geolocation Support
- **Current Location**: Button to get user's current location automatically
- **Permission Handling**: Proper handling of location permissions
- **High Accuracy**: Uses high accuracy GPS positioning

### 🎨 User Interface
- **Pink Theme**: Consistent pink color scheme throughout the interface
- **Visual Feedback**: Snackbar notifications for location selection
- **Instructions**: Clear instructions for users
- **Responsive Design**: Mobile-optimized interface

### 🔧 Technical Features
- **Fallback Support**: Graceful fallback when Google Maps is not configured
- **Manual Entry**: Option to manually enter coordinates
- **Address Integration**: Shows address information when available
- **Error Handling**: Comprehensive error handling and user feedback

## Files Created/Modified

### New Files
1. **`lib/widgets/location_picker.dart`** - Main location picker widget
2. **`lib/screens/demo/location_picker_demo.dart`** - Demo screen for testing
3. **`README_LOCATION_PICKER.md`** - This documentation file

### Modified Files
1. **`lib/screens/establishment/establishment_form.dart`** - Integrated location picker
2. **`lib/routes/app_routes.dart`** - Added demo route
3. **`lib/screens/dashboard/agent_dashboard.dart`** - Added demo access

## Usage

### In Establishment Form

The location picker is integrated into the establishment form in the "Statut et Coordonnées" section:

```dart
// Location Picker Section
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.pink[50],
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.pink[200]!),
  ),
  child: Column(
    children: [
      // Instructions and button
      ElevatedButton.icon(
        onPressed: _openLocationPicker,
        icon: Icon(Icons.location_on, color: Colors.white),
        label: Text('Ouvrir la carte'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[600],
          foregroundColor: Colors.white,
        ),
      ),
    ],
  ),
),
```

### Opening the Location Picker

```dart
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
```

## Configuration

### Google Maps API Key

The location picker requires a valid Google Maps API key. Update the configuration in `lib/config/google_maps_config.dart`:

```dart
class GoogleMapsConfig {
  static const String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
  // ... other configuration
}
```

### Required Permissions

Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

For iOS, add to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to select establishment coordinates.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access to select establishment coordinates.</string>
```

## Dependencies

The following dependencies are already included in `pubspec.yaml`:

```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
```

## Testing

### Demo Screen

Access the demo screen through the agent dashboard:
1. Navigate to Agent Dashboard
2. Tap "Démo Sélection d'Emplacement"
3. Test the location picker functionality

### Manual Testing

1. **Map Interaction**: Tap on different locations on the map
2. **Current Location**: Use the "My Location" button
3. **Coordinate Display**: Verify coordinates are displayed correctly
4. **Form Integration**: Test integration with establishment form
5. **Error Handling**: Test with invalid API key or no location permission

## API Integration

### Location Selection Callback

The location picker uses a callback function to notify the parent widget:

```dart
onLocationSelected: (double latitude, double longitude) {
  // Handle the selected coordinates
  setState(() {
    _latitude = latitude;
    _longitude = longitude;
  });
}
```

### Marker Configuration

The pink marker is configured using:

```dart
Marker(
  markerId: MarkerId('selected_location'),
  position: _selectedLocation!,
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
  infoWindow: InfoWindow(
    title: 'Emplacement sélectionné',
    snippet: 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
  ),
)
```

## Error Handling

### Google Maps Not Configured

When Google Maps API key is not configured, the widget shows a fallback interface with:
- Warning message
- Configuration instructions
- Manual coordinate entry option

### Location Permission Denied

When location permission is denied:
- Graceful fallback to manual selection
- User-friendly error messages
- Instructions for enabling permissions

### Network Issues

- Loading indicators during map initialization
- Error messages for network connectivity issues
- Retry mechanisms for failed operations

## Future Enhancements

### Planned Features
1. **Address Search**: Add search functionality for addresses
2. **Saved Locations**: Save frequently used locations
3. **Map Styles**: Different map styles (satellite, terrain)
4. **Offline Support**: Basic offline map functionality
5. **Batch Selection**: Select multiple locations at once

### Performance Optimizations
1. **Map Caching**: Cache map tiles for offline use
2. **Marker Clustering**: Group nearby markers for better performance
3. **Lazy Loading**: Load map data as needed
4. **Memory Management**: Optimize memory usage for large datasets

## Troubleshooting

### Common Issues

1. **Map Not Loading**
   - Check API key configuration
   - Verify internet connection
   - Check console for error messages

2. **Location Not Found**
   - Ensure location permissions are granted
   - Check GPS settings
   - Try manual coordinate entry

3. **Performance Issues**
   - Reduce map zoom level
   - Limit marker count
   - Check device memory usage

### Debug Mode

Enable debug mode by adding to your app initialization:

```dart
GoogleMapsFlutterPlatform.instance.initialize(
  androidApiKey: GoogleMapsConfig.apiKey,
  iosApiKey: GoogleMapsConfig.apiKey,
);
```

## Support

For technical support or questions about the location picker implementation:

1. Check the console logs for error messages
2. Verify Google Maps API key configuration
3. Test with the demo screen first
4. Check device location permissions
5. Review the implementation in `lib/widgets/location_picker.dart`

## License

This implementation is part of the TCL mobile application project and follows the same licensing terms.
