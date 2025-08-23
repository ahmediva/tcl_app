/// Modèle représentant un arrondissement administratif
/// Table de référence géographique pour les divisions administratives
class ArrondissementModel {
  final String code;          // Code unique de l'arrondissement (2 caractères)
  final String libelle;       // Nom complet de l'arrondissement
  final DateTime dateEtat;    // Date de mise à jour de l'état
  final String codeEtat;      // Code d'état (A: Actif, I: Inactif, etc.)
  final DateTime? createdAt;  // Date de création
  final DateTime? updatedAt;  // Date de dernière modification

  ArrondissementModel({
    required this.code,
    required this.libelle,
    required this.dateEtat,
    required this.codeEtat,
    this.createdAt,
    this.updatedAt,
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
    };
  }

  /// Vérifie si l'arrondissement est actif
  bool get estActif => codeEtat == 'A';

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
