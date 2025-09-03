/// Modèle représentant un arrondissement administratif
/// Table de référence géographique pour les divisions administratives
class ArrondissementModel {
  final String code;          // Code unique de l'arrondissement (2 caractères)
  final String libelle;       // Nom complet de l'arrondissement
  final DateTime dateEtat;    // Date de mise à jour de l'état
  final String codeEtat;      // Code d'état (A: Actif, I: Inactif, etc.)
  final DateTime? createdAt;  // Date de création
  final DateTime? updatedAt;  // Date de dernière modification
  
  // Google Maps coordinates
  final double? centerLatitude;   // Latitude du centre de l'arrondissement
  final double? centerLongitude;  // Longitude du centre de l'arrondissement
  final double? zoomLevel;        // Niveau de zoom recommandé pour la carte
  final List<Map<String, double>>? boundaryCoordinates; // Coordonnées des limites de l'arrondissement

  ArrondissementModel({
    required this.code,
    required this.libelle,
    required this.dateEtat,
    required this.codeEtat,
    this.createdAt,
    this.updatedAt,
    this.centerLatitude,
    this.centerLongitude,
    this.zoomLevel,
    this.boundaryCoordinates,
  });

  /// Constructeur à partir des données JSON de Supabase
  factory ArrondissementModel.fromJson(Map<String, dynamic> json) {
    return ArrondissementModel(
      code: json['code'],
      libelle: json['libelle'],
      dateEtat: DateTime.parse(json['date_etat']),
      codeEtat: json['code_etat'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      centerLatitude: json['center_latitude']?.toDouble(),
      centerLongitude: json['center_longitude']?.toDouble(),
      zoomLevel: json['zoom_level']?.toDouble(),
      boundaryCoordinates: json['boundary_coordinates'] != null 
          ? List<Map<String, double>>.from(
              json['boundary_coordinates'].map((coord) => Map<String, double>.from(coord))
            )
          : null,
    );
  }

  /// Conversion en JSON pour Supabase
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'libelle': libelle,
      'date_etat': dateEtat.toIso8601String(),
      'code_etat': codeEtat,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'center_latitude': centerLatitude,
      'center_longitude': centerLongitude,
      'zoom_level': zoomLevel,
      'boundary_coordinates': boundaryCoordinates,
    };
  }

  /// Vérifie si l'arrondissement est actif
  bool get estActif => codeEtat == 'A';

  /// Vérifie si l'arrondissement a des coordonnées
  bool get hasCoordinates => centerLatitude != null && centerLongitude != null;

  /// Vérifie si l'arrondissement a des limites définies
  bool get hasBoundaries => boundaryCoordinates != null && boundaryCoordinates!.isNotEmpty;

  /// Obtient le centre de l'arrondissement comme LatLng
  Map<String, double>? get center {
    if (hasCoordinates) {
      return {
        'latitude': centerLatitude!,
        'longitude': centerLongitude!,
      };
    }
    return null;
  }

  /// Représentation textuelle pour l'affichage
  @override
  String toString() {
    return '$code - $libelle';
  }

  /// Comparaison basée sur le code
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrondissementModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
