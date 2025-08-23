/// Modèle représentant une catégorie TCL
/// Table de référence pour les catégories de taxe sur les établissements commerciaux et industriels
class CategorieTclModel {
  final int numero;           // Numéro unique de la catégorie
  final int catCode;          // Code de la catégorie
  final DateTime? catDate;    // Date de la catégorie
  final String? catLibelle;   // Libellé de la catégorie
  final DateTime? catDateEffet;     // Date d'effet
  final DateTime? catDateFinEffet;  // Date de fin d'effet
  final String? catEtat;      // État de la catégorie (A=Actif, I=Inactif, etc.)
  final DateTime? createdAt;  // Date de création
  final DateTime? updatedAt;  // Date de dernière modification

  CategorieTclModel({
    required this.numero,
    required this.catCode,
    this.catDate,
    this.catLibelle,
    this.catDateEffet,
    this.catDateFinEffet,
    this.catEtat,
    this.createdAt,
    this.updatedAt,
  });

  /// Constructeur à partir des données JSON de Supabase
  factory CategorieTclModel.fromJson(Map<String, dynamic> json) {
    return CategorieTclModel(
      numero: json['numero'],
      catCode: json['cat_code'],
      catDate: json['cat_date'] != null ? DateTime.parse(json['cat_date']) : null,
      catLibelle: json['cat_libelle'],
      catDateEffet: json['cat_date_effet'] != null ? DateTime.parse(json['cat_date_effet']) : null,
      catDateFinEffet: json['cat_date_fin_effet'] != null ? DateTime.parse(json['cat_date_fin_effet']) : null,
      catEtat: json['cat_etat'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Conversion en JSON pour Supabase
  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'cat_code': catCode,
      'cat_date': catDate?.toIso8601String(),
      'cat_libelle': catLibelle,
      'cat_date_effet': catDateEffet?.toIso8601String(),
      'cat_date_fin_effet': catDateFinEffet?.toIso8601String(),
      'cat_etat': catEtat,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Vérifie si la catégorie est active
  bool get estActif => catEtat == 'A';

  /// Représentation textuelle pour l'affichage
  @override
  String toString() {
    return '$numero - ${catLibelle ?? "Sans libellé"}';
  }

  /// Comparaison basée sur le numéro
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategorieTclModel &&
          runtimeType == other.runtimeType &&
          numero == other.numero;

  @override
  int get hashCode => numero.hashCode;
}
