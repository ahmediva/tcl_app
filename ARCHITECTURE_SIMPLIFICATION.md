# Simplified TCL App Architecture

## Overview

The TCL app has been simplified to focus on a single main model (`EtablissementModel`) instead of multiple separate models for reference data. This approach aligns with the actual database structure where all establishment data is stored in the `ARTICLE` table.

## Architecture Changes

### Before (Complex)
- `EtablissementModel` - Main establishment data
- `ArrondissementModel` - Administrative divisions
- `CommuneModel` - Municipal units
- `DelegationModel` - Administrative delegations
- `CategorieTclModel` - Tax categories
- Multiple providers for each model
- Complex database joins and relationships

### After (Simplified)
- `EtablissementModel` - Contains all establishment data + static reference data
- Static reference data embedded in the model
- Single `EstablishmentProvider` for state management
- Simplified `DatabaseService` focused on establishments
- No complex joins needed

## Key Benefits

1. **Simplified Architecture**: Single source of truth for all establishment data
2. **Better Performance**: No JOIN operations needed
3. **Easier Maintenance**: Fewer models and providers to maintain
4. **Aligned with Database**: Matches the actual `ARTICLE` table structure
5. **Reduced Complexity**: Less code, easier to understand

## Static Reference Data

The `EtablissementModel` now contains static reference data for dropdowns:

```dart
// Arrondissements
static const List<Map<String, String>> arrondissements = [
  {"code": "01", "libelle": "01حي البستان_"},
  {"code": "02", "libelle": "02حي الجنان_"},
  // ... more arrondissements
];

// Etat options
static const List<Map<String, String>> etatOptions = [
  {"value": "1", "label": "Paye Taxe"},
  {"value": "0", "label": "Ne Paye Pas"},
];

// Other reference data...
```

## Helper Methods

The model includes helper methods for display:

```dart
String get displayArrondissement; // Returns human-readable arrondissement name
String get displayEtat;           // Returns human-readable etat
String get fullAddress;           // Returns complete address
bool get hasCoordinates;          // Checks if GPS coordinates exist
Map<String, double>? get coordinates; // Returns coordinates as map
```

## Usage Examples

### Dropdowns
```dart
// Use static data directly
DropdownButtonFormField<String>(
  items: EtablissementModel.arrondissements.map((arr) => 
    DropdownMenuItem(value: arr["code"], child: Text(arr["libelle"]))
  ).toList(),
)
```

### Display
```dart
// Use helper methods
Text(etablissement.displayArrondissement)
Text(etablissement.fullAddress)
```

### Provider
```dart
// Single provider for all establishment operations
final provider = Provider.of<EstablishmentProvider>(context);
await provider.fetchEtablissements();
await provider.addEtablissement(etablissement);
```

## Deprecated Files

The following files have been moved to `lib/models/deprecated/`:
- `arrondissement_model.dart`
- `commune_model.dart`
- `delegation_model.dart`
- `categorie_tcl_model.dart`

These files are kept for reference but should not be used in new code.

## Migration Guide

If you have existing code using the old models:

1. **Replace model imports**: Use `EtablissementModel` instead of separate models
2. **Update dropdowns**: Use static data from `EtablissementModel`
3. **Update providers**: Use `EstablishmentProvider` instead of multiple providers
4. **Update forms**: Use the new dropdown widgets from `etablissement_dropdowns.dart`

## Database Structure

The simplified architecture works with the existing `ARTICLE` table structure:

```sql
[ArtNouvCode]     -- Primary key
[ArtArrond]       -- Arrondissement code (references static data)
[CodeGouv]        -- Governorate code
[CodeDeleg]       -- Delegation code
[CodeCom]         -- Commune code
[ArtCatActivite]  -- Activity category (references static data)
[ArtEtat]         -- Tax status (references static data)
-- ... all other establishment fields
```

This approach eliminates the need for separate reference tables while maintaining data integrity and providing a clean, maintainable codebase.
