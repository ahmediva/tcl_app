/// Modèle représentant une délégation administrative
/// Table de référence pour les délégations dans la hiérarchie territoriale
class DelegationModel {
  final int codeDeleg;         // Code unique de la délégation
  final int? codeGouv;        // Code du gouvernement associé
  final String? libelleFr;    // Libellé en français
  final String? libelleAr;    // Libellé en arabe
  final DateTime? createdAt;   // Date de création
  final DateTime? updatedAt;   // Date de dernière modification

  DelegationModel({
    required this.codeDeleg,
    this.codeGouv,
    this.libelleFr,
    this.libelleAr,
    this.createdAt,
    this.updatedAt,
  });

  /// Constructeur à partir des données JSON de Supabase
  factory DelegationModel.fromJson(Map<String, dynamic> json) {
    return DelegationModel(
      codeDeleg: json['CodeDeleg'],
      codeGouv: json['CodeGouv'],
      libelleFr: json['LibelleFr'],
      libelleAr: json['LibelleAr'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Conversion en JSON pour Supabase
  Map<String, dynamic> toJson() {
    return {
      'CodeDeleg': codeDeleg,
      'CodeGouv': codeGouv,
      'LibelleFr': libelleFr,
      'LibelleAr': libelleAr,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Représentation textuelle pour l'affichage
  @override
  String toString() {
    return '$codeDeleg - $libelleFr';
  }

  /// Comparaison basée sur le code
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DelegationModel &&
          runtimeType == other.runtimeType &&
          codeDeleg == other.codeDeleg;

  @override
  int get hashCode => codeDeleg.hashCode;
}
