class EtablissementModel {
  final String artNouvCode;
  final int? artDebPer;
  final int? artFinPer;
  final int? artImp;
  final double? artTauxPres;
  final DateTime? artDateDebImp;
  final DateTime? artDateFinImp;
  final double? artMntTaxe;
  final String? artAgent;
  final DateTime? artDateSaisie;
  final String? artRedCode;
  final String? artMond;
  final String? artOccup;
  final String artArrond;
  final String artRue;
  final String? artTexteAdresse;
  final double? artSurTot;
  final double? artSurCouv;
  final double? artPrixRef;
  final String? artCatArt;
  final String? artQualOccup;
  final double? artSurCont;
  final double? artSurDecl;
  final double? artPrixMetre;
  final int? artBaseTaxe;
  final int? artEtat;
  final String? artTaxeOffice;
  final String? artNumRole;
  final int? codeGouv;
  final int? codeDeleg;
  final int? codeImeda;
  final String? codeCom;
  final int? redTypePrpor;
  final String? artTelDecl;
  final String? artEmailDecl;
  final String? artCommentaire;
  final int? artCatActivite;
  final String? artNomCommerce;
  final int? artOccupVoie;
  final double? artLatitude;
  final double? artLongitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EtablissementModel({
    required this.artNouvCode,
    this.artDebPer,
    this.artFinPer,
    this.artImp,
    this.artTauxPres,
    this.artDateDebImp,
    this.artDateFinImp,
    this.artMntTaxe,
    this.artAgent,
    this.artDateSaisie,
    this.artRedCode,
    this.artMond,
    this.artOccup,
    required this.artArrond,
    required this.artRue,
    this.artTexteAdresse,
    this.artSurTot,
    this.artSurCouv,
    this.artPrixRef,
    this.artCatArt,
    this.artQualOccup,
    this.artSurCont,
    this.artSurDecl,
    this.artPrixMetre,
    this.artBaseTaxe,
    this.artEtat,
    this.artTaxeOffice,
    this.artNumRole,
    this.codeGouv,
    this.codeDeleg,
    this.codeImeda,
    this.codeCom,
    this.redTypePrpor,
    this.artTelDecl,
    this.artEmailDecl,
    this.artCommentaire,
    this.artCatActivite,
    this.artNomCommerce,
    this.artOccupVoie,
    this.artLatitude,
    this.artLongitude,
    this.createdAt,
    this.updatedAt,
  });

  factory EtablissementModel.fromJson(Map<String, dynamic> json) {
    return EtablissementModel(
      artNouvCode: json['art_nouv_code'],
      artDebPer: json['art_deb_per'],
      artFinPer: json['art_fin_per'],
      artImp: json['art_imp'],
      artTauxPres: (json['art_taux_pres'] is double) ? json['art_taux_pres'] : double.tryParse(json['art_taux_pres']?.toString() ?? '0'),
      artDateDebImp: json['art_date_deb_imp'] != null ? DateTime.parse(json['art_date_deb_imp']) : null,
      artDateFinImp: json['art_date_fin_imp'] != null ? DateTime.parse(json['art_date_fin_imp']) : null,
      artMntTaxe: (json['art_mnt_taxe'] is double) ? json['art_mnt_taxe'] : double.tryParse(json['art_mnt_taxe']?.toString() ?? '0'),
      artAgent: json['art_agent'],
      artDateSaisie: json['art_date_saisie'] != null ? DateTime.parse(json['art_date_saisie']) : null,
      artRedCode: json['art_red_code'],
      artMond: json['art_mond'],
      artOccup: json['art_occup'],
      artArrond: json['art_arrond'],
      artRue: json['art_rue'],
      artTexteAdresse: json['art_texte_adresse'],
      artSurTot: (json['art_sur_tot'] is double) ? json['art_sur_tot'] : double.tryParse(json['art_sur_tot']?.toString() ?? '0'),
      artSurCouv: (json['art_sur_couv'] is double) ? json['art_sur_couv'] : double.tryParse(json['art_sur_couv']?.toString() ?? '0'),
      artPrixRef: (json['art_prix_ref'] is double) ? json['art_prix_ref'] : double.tryParse(json['art_prix_ref']?.toString() ?? '0'),
      artCatArt: json['art_cat_art'],
      artQualOccup: json['art_qual_occup'],
      artSurCont: (json['art_sur_cont'] is double) ? json['art_sur_cont'] : double.tryParse(json['art_sur_cont']?.toString() ?? '0'),
      artSurDecl: (json['art_sur_decl'] is double) ? json['art_sur_decl'] : double.tryParse(json['art_sur_decl']?.toString() ?? '0'),
      artPrixMetre: (json['art_prix_metre'] is double) ? json['art_prix_metre'] : double.tryParse(json['art_prix_metre']?.toString() ?? '0'),
      artBaseTaxe: json['art_base_taxe'],
      artEtat: json['art_etat'],
      artTaxeOffice: json['art_taxe_office'],
      artNumRole: json['art_num_role'],
      codeGouv: json['code_gouv'],
      codeDeleg: json['code_deleg'],
      codeImeda: json['code_imeda'],
      codeCom: json['code_com'],
      redTypePrpor: json['red_type_prpor'],
      artTelDecl: json['art_tel_decl'],
      artEmailDecl: json['art_email_decl'],
      artCommentaire: json['art_commentaire'],
      artCatActivite: json['art_cat_activite'],
      artNomCommerce: json['art_nom_commerce'],
      artOccupVoie: json['art_occup_voie'],
      artLatitude: (json['art_latitude'] is double) ? json['art_latitude'] : double.tryParse(json['art_latitude']?.toString() ?? '0'),
      artLongitude: (json['art_longitude'] is double) ? json['art_longitude'] : double.tryParse(json['art_longitude']?.toString() ?? '0'),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'art_nouv_code': artNouvCode,
      'art_deb_per': artDebPer,
      'art_fin_per': artFinPer,
      'art_imp': artImp,
      'art_taux_pres': artTauxPres,
      'art_date_deb_imp': artDateDebImp?.toIso8601String(),
      'art_date_fin_imp': artDateFinImp?.toIso8601String(),
      'art_mnt_taxe': artMntTaxe,
      'art_agent': artAgent,
      'art_date_saisie': artDateSaisie?.toIso8601String(),
      'art_red_code': artRedCode,
      'art_mond': artMond,
      'art_occup': artOccup,
      'art_arrond': artArrond,
      'art_rue': artRue,
      'art_texte_adresse': artTexteAdresse,
      'art_sur_tot': artSurTot,
      'art_sur_couv': artSurCouv,
      'art_prix_ref': artPrixRef,
      'art_cat_art': artCatArt,
      'art_qual_occup': artQualOccup,
      'art_sur_cont': artSurCont,
      'art_sur_decl': artSurDecl,
      'art_prix_metre': artPrixMetre,
      'art_base_taxe': artBaseTaxe,
      'art_etat': artEtat,
      'art_taxe_office': artTaxeOffice,
      'art_num_role': artNumRole,
      'code_gouv': codeGouv,
      'code_deleg': codeDeleg,
      'code_imeda': codeImeda,
      'code_com': codeCom,
      'red_type_prpor': redTypePrpor,
      'art_tel_decl': artTelDecl,
      'art_email_decl': artEmailDecl,
      'art_commentaire': artCommentaire,
      'art_cat_activite': artCatActivite,
      'art_nom_commerce': artNomCommerce,
      'art_occup_voie': artOccupVoie,
      'art_latitude': artLatitude,
      'art_longitude': artLongitude,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
