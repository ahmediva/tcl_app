/// Modèle représentant une commune administrative
/// Table de référence géographique pour les communes
class CommuneModel {
  final String codeM;          // Code unique de la commune (5 caractères)
  final String? libelle;       // Nom de la commune
  final String? ministere;     // Ministère de tutelle
  final String? adresse;       // Adresse de la mairie
  final String? responsable;   // Nom du responsable
  final String? receveur;      // Nom du receveur
  final String? dansLe;        // Localisation/Zone géographique
  final DateTime? createdAt;   // Date de création
  final DateTime? updatedAt;   // Date de dernière modification

  CommuneModel({
    required this.codeM,
    this.libelle,
    this.ministere,
    this.adresse,
    this.responsable,
    this.receveur,
    this.dansLe,
    this.createdAt,
    this.updatedAt,
  });

  /// Constructeur à partir des données JSON de Supabase
  factory CommuneModel.fromJson(Map<String, dynamic> json) {
    return CommuneModel(
      codeM: json['code_m'],
      libelle: json['libelle'],
      ministere: json['ministere'],
      adresse: json['adresse'],
      responsable: json['responsable'],
      receveur: json['receveur'],
      dansLe: json['dans_le'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Conversion en JSON pour Supabase
  Map<String, dynamic> toJson() {
    return {
      'code_m': codeM,
      'libelle': libelle,
      'ministere': ministere,
      'adresse': adresse,
      'responsable': responsable,
      'receveur': receveur,
      'dans_le': dansLe,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Représentation textuelle pour l'affichage
  @override
  String toString() {
    return '$codeM - ${libelle ?? "Sans nom"}';
  }

  /// Comparaison basée sur le code
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommuneModel &&
          runtimeType == other.runtimeType &&
          codeM == other.codeM;

  @override
  int get hashCode => codeM.hashCode;
}
