class EtablissementModel {
  // Primary fields
  final String artNouvCode;
  final int? artDebPer;
  final int? artFinPer;
  final int? artImp;
  final double? artTauxPres;
  final DateTime? artDateDebImp;
  final DateTime? artDateFinImp;
  final double? artMntTaxe;
  final String? artAgentSaisie;
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
  
  // Additional fields from complete schema
  final String? artNumDos;
  final String? artSourMaj;
  final String? artNumMaj;
  final DateTime? artDateMaj;
  final String? artSour;
  final String? artNumSour;
  final DateTime? artDateSour;
  final DateTime? artDateBlocage;
  final String? artTypeTaxe;
  final int? artImpFNAH;
  final double? artMntTaxeTib;
  final double? artMntTaxeFnah;
  final String? artAgentCont;
  final DateTime? artDateCont;
  final String? artNumAvis;
  final String? artVred;
  final String? artTypeRue;
  final String? artNumRue;
  final String? artBis;
  final String? artBloc;
  final int? artOrdreBloc;
  final String? artCodePos;
  final String? artSectBur;
  final int? artPresNet;
  final int? artPresEcl;
  final int? artPresCh;
  final int? artPresTr;
  final int? artPresEauU;
  final int? artPresEauP;
  final int? artPresAut;
  final double? artSurTotCont;
  final double? artSurCouvCont;
  final double? artLoyeeAnn;
  final String? artConstArt;
  final String? artCompArt;
  final String? artUtilArt;
  final String? artTitreFonc;
  final double? artValVen;
  final double? artDens;
  final DateTime? artDatePoss;
  final DateTime? artDateImp;
  final String? artSitu;
  final double? artFrontNord;
  final double? artFrontSud;
  final double? artFrontEst;
  final double? artFrontOuest;
  final DateTime? artDateEtat;
  final String? artCodeAvTrans;
  final String? artCodeApTrans;
  final int? artDerAnneeRole;
  final int? artDerAnnee_1Role;
  final String? artCite;
  final String? artsecteur;
  final String? artCellule;
  final String? artNomResid;
  final String? artNomImmeuble;
  final String? artEtage;
  final String? artAppart;
  final String? artTypeHabit;
  final String? artActivSecond;
  final String? artEnseigne;
  final String? artNomAgent;
  final DateTime? artDateRecens;
  final String? typeCollect;
  final String? artIdMiseAJour;
  final String? artDeclCode;
  final String? artAgentDecl;
  final String? artQualDecl;
  
  // System fields
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
    this.artAgentSaisie,
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
    this.artNumDos,
    this.artSourMaj,
    this.artNumMaj,
    this.artDateMaj,
    this.artSour,
    this.artNumSour,
    this.artDateSour,
    this.artDateBlocage,
    this.artTypeTaxe,
    this.artImpFNAH,
    this.artMntTaxeTib,
    this.artMntTaxeFnah,
    this.artAgentCont,
    this.artDateCont,
    this.artNumAvis,
    this.artVred,
    this.artTypeRue,
    this.artNumRue,
    this.artBis,
    this.artBloc,
    this.artOrdreBloc,
    this.artCodePos,
    this.artSectBur,
    this.artPresNet,
    this.artPresEcl,
    this.artPresCh,
    this.artPresTr,
    this.artPresEauU,
    this.artPresEauP,
    this.artPresAut,
    this.artSurTotCont,
    this.artSurCouvCont,
    this.artLoyeeAnn,
    this.artConstArt,
    this.artCompArt,
    this.artUtilArt,
    this.artTitreFonc,
    this.artValVen,
    this.artDens,
    this.artDatePoss,
    this.artDateImp,
    this.artSitu,
    this.artFrontNord,
    this.artFrontSud,
    this.artFrontEst,
    this.artFrontOuest,
    this.artDateEtat,
    this.artCodeAvTrans,
    this.artCodeApTrans,
    this.artDerAnneeRole,
    this.artDerAnnee_1Role,
    this.artCite,
    this.artsecteur,
    this.artCellule,
    this.artNomResid,
    this.artNomImmeuble,
    this.artEtage,
    this.artAppart,
    this.artTypeHabit,
    this.artActivSecond,
    this.artEnseigne,
    this.artNomAgent,
    this.artDateRecens,
    this.typeCollect,
    this.artIdMiseAJour,
    this.artDeclCode,
    this.artAgentDecl,
    this.artQualDecl,
    this.createdAt,
    this.updatedAt,
  });

  factory EtablissementModel.fromJson(Map<String, dynamic> json) {
    return EtablissementModel(
      artNouvCode: json['ArtNouvCode'] ?? '',
      artDebPer: json['ArtDebPer'],
      artFinPer: json['ArtFinPer'],
      artImp: json['ArtImp'],
      artTauxPres: _parseDouble(json['ArtTauxPres']),
      artDateDebImp: _parseDateTime(json['ArtDateDebImp']),
      artDateFinImp: _parseDateTime(json['ArtDateFinImp']),
      artMntTaxe: _parseDouble(json['ArtMntTaxe']),
      artAgentSaisie: json['ArtAgentSaisie'],
      artDateSaisie: _parseDateTime(json['ArtDateSaisie']),
      artRedCode: json['ArtRedCode'],
      artMond: json['ArtMond'],
      artOccup: json['ArtOccup'],
      artArrond: json['ArtArrond'] ?? '',
      artRue: json['ArtRue'] ?? '',
      artTexteAdresse: json['ArtTexteAdresse'],
      artSurTot: _parseDouble(json['ArtSurTot']),
      artSurCouv: _parseDouble(json['ArtSurCouv']),
      artPrixRef: _parseDouble(json['ArtPrixRef']),
      artCatArt: json['ArtCatArt'],
      artQualOccup: json['ArtQualOccup'],
      artSurCont: _parseDouble(json['ArtSurCont']),
      artSurDecl: _parseDouble(json['ArtSurDecl']),
      artPrixMetre: _parseDouble(json['ArtPrixMetre']),
      artBaseTaxe: json['ArtBaseTaxe'],
      artEtat: json['ArtEtat'],
      artTaxeOffice: json['ArtTaxeOffice'],
      artNumRole: json['ArtNumRole'],
      codeGouv: json['CodeGouv'],
      codeDeleg: json['CodeDeleg'],
      codeImeda: json['CodeImeda'],
      codeCom: json['CodeCom'],
      redTypePrpor: json['RedTypePrpor'],
      artTelDecl: json['ArtTelDecl'],
      artEmailDecl: json['ArtEmailDecl'],
      artCommentaire: json['ArtCommentaire'],
      artCatActivite: json['ArtCatActivite'],
      artNomCommerce: json['ArtNomCommerce'],
      artOccupVoie: json['ArtOccupVoie'],
      artLatitude: _parseDouble(json['ArtLatitude']),
      artLongitude: _parseDouble(json['ArtLongitude']),
      artNumDos: json['ArtNumDos'],
      artSourMaj: json['ArtSourMaj'],
      artNumMaj: json['ArtNumMaj'],
      artDateMaj: _parseDateTime(json['ArtDateMaj']),
      artSour: json['ArtSour'],
      artNumSour: json['ArtNumSour'],
      artDateSour: _parseDateTime(json['ArtDateSour']),
      artDateBlocage: _parseDateTime(json['ArtDateBlocage']),
      artTypeTaxe: json['ArtTypeTaxe'],
      artImpFNAH: json['ArtImpFNAH'],
      artMntTaxeTib: _parseDouble(json['ArtMntTaxeTib']),
      artMntTaxeFnah: _parseDouble(json['ArtMntTaxeFnah']),
      artAgentCont: json['ArtAgentCont'],
      artDateCont: _parseDateTime(json['ArtDateCont']),
      artNumAvis: json['ArtNumAvis'],
      artVred: json['ArtVred'],
      artTypeRue: json['ArtTypeRue'],
      artNumRue: json['ArtNumRue'],
      artBis: json['ArtBis'],
      artBloc: json['ArtBloc'],
      artOrdreBloc: json['ArtOrdreBloc'],
      artCodePos: json['ArtCodePos'],
      artSectBur: json['ArtSectBur'],
      artPresNet: json['ArtPresNet'],
      artPresEcl: json['ArtPresEcl'],
      artPresCh: json['ArtPresCh'],
      artPresTr: json['ArtPresTr'],
      artPresEauU: json['ArtPresEauU'],
      artPresEauP: json['ArtPresEauP'],
      artPresAut: json['ArtPresAut'],
      artSurTotCont: _parseDouble(json['ArtSurTotCont']),
      artSurCouvCont: _parseDouble(json['ArtSurCouvCont']),
      artLoyeeAnn: _parseDouble(json['ArtLoyeeAnn']),
      artConstArt: json['ArtConstArt'],
      artCompArt: json['ArtCompArt'],
      artUtilArt: json['ArtUtilArt'],
      artTitreFonc: json['ArtTitreFonc'],
      artValVen: _parseDouble(json['ArtValVen']),
      artDens: _parseDouble(json['ArtDens']),
      artDatePoss: _parseDateTime(json['ArtDatePoss']),
      artDateImp: _parseDateTime(json['ArtDateImp']),
      artSitu: json['ArtSitu'],
      artFrontNord: _parseDouble(json['ArtFrontNord']),
      artFrontSud: _parseDouble(json['ArtFrontSud']),
      artFrontEst: _parseDouble(json['ArtFrontEst']),
      artFrontOuest: _parseDouble(json['ArtFrontOuest']),
      artDateEtat: _parseDateTime(json['ArtDateEtat']),
      artCodeAvTrans: json['ArtCodeAvTrans'],
      artCodeApTrans: json['ArtCodeApTrans'],
      artDerAnneeRole: json['ArtDerAnneeRole'],
      artDerAnnee_1Role: json['ArtDerAnnee_1Role'],
      artCite: json['ArtCite'],
      artsecteur: json['Artsecteur'],
      artCellule: json['ArtCellule'],
      artNomResid: json['ArtNomResid'],
      artNomImmeuble: json['ArtNomImmeuble'],
      artEtage: json['ArtEtage'],
      artAppart: json['ArtAppart'],
      artTypeHabit: json['ArtTypeHabit'],
      artActivSecond: json['ArtActivSecond'],
      artEnseigne: json['ArtEnseigne'],
      artNomAgent: json['ArtNomAgent'],
      artDateRecens: _parseDateTime(json['ArtDateRecens']),
      typeCollect: json['TypeCollect'],
      artIdMiseAJour: json['ArtIdMiseAJour'],
      artDeclCode: json['ArtDeclCode'],
      artAgentDecl: json['ArtAgentDecl'],
      artQualDecl: json['ArtQualDecl'],
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ArtNouvCode': artNouvCode,
      'ArtDebPer': artDebPer,
      'ArtFinPer': artFinPer,
      'ArtImp': artImp,
      'ArtTauxPres': artTauxPres,
      'ArtDateDebImp': artDateDebImp?.toIso8601String(),
      'ArtDateFinImp': artDateFinImp?.toIso8601String(),
      'ArtMntTaxe': artMntTaxe,
      'ArtAgentSaisie': artAgentSaisie,
      'ArtDateSaisie': artDateSaisie?.toIso8601String(),
      'ArtRedCode': artRedCode,
      'ArtMond': artMond,
      'ArtOccup': artOccup,
      'ArtArrond': artArrond,
      'ArtRue': artRue,
      'ArtTexteAdresse': artTexteAdresse,
      'ArtSurTot': artSurTot,
      'ArtSurCouv': artSurCouv,
      'ArtPrixRef': artPrixRef,
      'ArtCatArt': artCatArt,
      'ArtQualOccup': artQualOccup,
      'ArtSurCont': artSurCont,
      'ArtSurDecl': artSurDecl,
      'ArtPrixMetre': artPrixMetre,
      'ArtBaseTaxe': artBaseTaxe,
      'ArtEtat': artEtat,
      'ArtTaxeOffice': artTaxeOffice,
      'ArtNumRole': artNumRole,
      'CodeGouv': codeGouv,
      'CodeDeleg': codeDeleg,
      'CodeImeda': codeImeda,
      'CodeCom': codeCom,
      'RedTypePrpor': redTypePrpor,
      'ArtTelDecl': artTelDecl,
      'ArtEmailDecl': artEmailDecl,
      'ArtCommentaire': artCommentaire,
      'ArtCatActivite': artCatActivite,
      'ArtNomCommerce': artNomCommerce,
      'ArtOccupVoie': artOccupVoie,
      'ArtLatitude': artLatitude,
      'ArtLongitude': artLongitude,
      'ArtNumDos': artNumDos,
      'ArtSourMaj': artSourMaj,
      'ArtNumMaj': artNumMaj,
      'ArtDateMaj': artDateMaj?.toIso8601String(),
      'ArtSour': artSour,
      'ArtNumSour': artNumSour,
      'ArtDateSour': artDateSour?.toIso8601String(),
      'ArtDateBlocage': artDateBlocage?.toIso8601String(),
      'ArtTypeTaxe': artTypeTaxe,
      'ArtImpFNAH': artImpFNAH,
      'ArtMntTaxeTib': artMntTaxeTib,
      'ArtMntTaxeFnah': artMntTaxeFnah,
      'ArtAgentCont': artAgentCont,
      'ArtDateCont': artDateCont?.toIso8601String(),
      'ArtNumAvis': artNumAvis,
      'ArtVred': artVred,
      'ArtTypeRue': artTypeRue,
      'ArtNumRue': artNumRue,
      'ArtBis': artBis,
      'ArtBloc': artBloc,
      'ArtOrdreBloc': artOrdreBloc,
      'ArtCodePos': artCodePos,
      'ArtSectBur': artSectBur,
      'ArtPresNet': artPresNet,
      'ArtPresEcl': artPresEcl,
      'ArtPresCh': artPresCh,
      'ArtPresTr': artPresTr,
      'ArtPresEauU': artPresEauU,
      'ArtPresEauP': artPresEauP,
      'ArtPresAut': artPresAut,
      'ArtSurTotCont': artSurTotCont,
      'ArtSurCouvCont': artSurCouvCont,
      'ArtLoyeeAnn': artLoyeeAnn,
      'ArtConstArt': artConstArt,
      'ArtCompArt': artCompArt,
      'ArtUtilArt': artUtilArt,
      'ArtTitreFonc': artTitreFonc,
      'ArtValVen': artValVen,
      'ArtDens': artDens,
      'ArtDatePoss': artDatePoss?.toIso8601String(),
      'ArtDateImp': artDateImp?.toIso8601String(),
      'ArtSitu': artSitu,
      'ArtFrontNord': artFrontNord,
      'ArtFrontSud': artFrontSud,
      'ArtFrontEst': artFrontEst,
      'ArtFrontOuest': artFrontOuest,
      'ArtDateEtat': artDateEtat?.toIso8601String(),
      'ArtCodeAvTrans': artCodeAvTrans,
      'ArtCodeApTrans': artCodeApTrans,
      'ArtDerAnneeRole': artDerAnneeRole,
      'ArtDerAnnee_1Role': artDerAnnee_1Role,
      'ArtCite': artCite,
      'Artsecteur': artsecteur,
      'ArtCellule': artCellule,
      'ArtNomResid': artNomResid,
      'ArtNomImmeuble': artNomImmeuble,
      'ArtEtage': artEtage,
      'ArtAppart': artAppart,
      'ArtTypeHabit': artTypeHabit,
      'ArtActivSecond': artActivSecond,
      'ArtEnseigne': artEnseigne,
      'ArtNomAgent': artNomAgent,
      'ArtDateRecens': artDateRecens?.toIso8601String(),
      'TypeCollect': typeCollect,
      'ArtIdMiseAJour': artIdMiseAJour,
      'ArtDeclCode': artDeclCode,
      'ArtAgentDecl': artAgentDecl,
      'ArtQualDecl': artQualDecl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods for parsing
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Copy with method for updates
  EtablissementModel copyWith({
    String? artNouvCode,
    int? artDebPer,
    int? artFinPer,
    int? artImp,
    double? artTauxPres,
    DateTime? artDateDebImp,
    DateTime? artDateFinImp,
    double? artMntTaxe,
    String? artAgentSaisie,
    DateTime? artDateSaisie,
    String? artRedCode,
    String? artMond,
    String? artOccup,
    String? artArrond,
    String? artRue,
    String? artTexteAdresse,
    double? artSurTot,
    double? artSurCouv,
    double? artPrixRef,
    String? artCatArt,
    String? artQualOccup,
    double? artSurCont,
    double? artSurDecl,
    double? artPrixMetre,
    int? artBaseTaxe,
    int? artEtat,
    String? artTaxeOffice,
    String? artNumRole,
    int? codeGouv,
    int? codeDeleg,
    int? codeImeda,
    String? codeCom,
    int? redTypePrpor,
    String? artTelDecl,
    String? artEmailDecl,
    String? artCommentaire,
    int? artCatActivite,
    String? artNomCommerce,
    int? artOccupVoie,
    double? artLatitude,
    double? artLongitude,
    String? artNumDos,
    String? artSourMaj,
    String? artNumMaj,
    DateTime? artDateMaj,
    String? artSour,
    String? artNumSour,
    DateTime? artDateSour,
    DateTime? artDateBlocage,
    String? artTypeTaxe,
    int? artImpFNAH,
    double? artMntTaxeTib,
    double? artMntTaxeFnah,
    String? artAgentCont,
    DateTime? artDateCont,
    String? artNumAvis,
    String? artVred,
    String? artTypeRue,
    String? artNumRue,
    String? artBis,
    String? artBloc,
    int? artOrdreBloc,
    String? artCodePos,
    String? artSectBur,
    int? artPresNet,
    int? artPresEcl,
    int? artPresCh,
    int? artPresTr,
    int? artPresEauU,
    int? artPresEauP,
    int? artPresAut,
    double? artSurTotCont,
    double? artSurCouvCont,
    double? artLoyeeAnn,
    String? artConstArt,
    String? artCompArt,
    String? artUtilArt,
    String? artTitreFonc,
    double? artValVen,
    double? artDens,
    DateTime? artDatePoss,
    DateTime? artDateImp,
    String? artSitu,
    double? artFrontNord,
    double? artFrontSud,
    double? artFrontEst,
    double? artFrontOuest,
    DateTime? artDateEtat,
    String? artCodeAvTrans,
    String? artCodeApTrans,
    int? artDerAnneeRole,
    int? artDerAnnee_1Role,
    String? artCite,
    String? artsecteur,
    String? artCellule,
    String? artNomResid,
    String? artNomImmeuble,
    String? artEtage,
    String? artAppart,
    String? artTypeHabit,
    String? artActivSecond,
    String? artEnseigne,
    String? artNomAgent,
    DateTime? artDateRecens,
    String? typeCollect,
    String? artIdMiseAJour,
    String? artDeclCode,
    String? artAgentDecl,
    String? artQualDecl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EtablissementModel(
      artNouvCode: artNouvCode ?? this.artNouvCode,
      artDebPer: artDebPer ?? this.artDebPer,
      artFinPer: artFinPer ?? this.artFinPer,
      artImp: artImp ?? this.artImp,
      artTauxPres: artTauxPres ?? this.artTauxPres,
      artDateDebImp: artDateDebImp ?? this.artDateDebImp,
      artDateFinImp: artDateFinImp ?? this.artDateFinImp,
      artMntTaxe: artMntTaxe ?? this.artMntTaxe,
      artAgentSaisie: artAgentSaisie ?? this.artAgentSaisie,
      artDateSaisie: artDateSaisie ?? this.artDateSaisie,
      artRedCode: artRedCode ?? this.artRedCode,
      artMond: artMond ?? this.artMond,
      artOccup: artOccup ?? this.artOccup,
      artArrond: artArrond ?? this.artArrond,
      artRue: artRue ?? this.artRue,
      artTexteAdresse: artTexteAdresse ?? this.artTexteAdresse,
      artSurTot: artSurTot ?? this.artSurTot,
      artSurCouv: artSurCouv ?? this.artSurCouv,
      artPrixRef: artPrixRef ?? this.artPrixRef,
      artCatArt: artCatArt ?? this.artCatArt,
      artQualOccup: artQualOccup ?? this.artQualOccup,
      artSurCont: artSurCont ?? this.artSurCont,
      artSurDecl: artSurDecl ?? this.artSurDecl,
      artPrixMetre: artPrixMetre ?? this.artPrixMetre,
      artBaseTaxe: artBaseTaxe ?? this.artBaseTaxe,
      artEtat: artEtat ?? this.artEtat,
      artTaxeOffice: artTaxeOffice ?? this.artTaxeOffice,
      artNumRole: artNumRole ?? this.artNumRole,
      codeGouv: codeGouv ?? this.codeGouv,
      codeDeleg: codeDeleg ?? this.codeDeleg,
      codeImeda: codeImeda ?? this.codeImeda,
      codeCom: codeCom ?? this.codeCom,
      redTypePrpor: redTypePrpor ?? this.redTypePrpor,
      artTelDecl: artTelDecl ?? this.artTelDecl,
      artEmailDecl: artEmailDecl ?? this.artEmailDecl,
      artCommentaire: artCommentaire ?? this.artCommentaire,
      artCatActivite: artCatActivite ?? this.artCatActivite,
      artNomCommerce: artNomCommerce ?? this.artNomCommerce,
      artOccupVoie: artOccupVoie ?? this.artOccupVoie,
      artLatitude: artLatitude ?? this.artLatitude,
      artLongitude: artLongitude ?? this.artLongitude,
      artNumDos: artNumDos ?? this.artNumDos,
      artSourMaj: artSourMaj ?? this.artSourMaj,
      artNumMaj: artNumMaj ?? this.artNumMaj,
      artDateMaj: artDateMaj ?? this.artDateMaj,
      artSour: artSour ?? this.artSour,
      artNumSour: artNumSour ?? this.artNumSour,
      artDateSour: artDateSour ?? this.artDateSour,
      artDateBlocage: artDateBlocage ?? this.artDateBlocage,
      artTypeTaxe: artTypeTaxe ?? this.artTypeTaxe,
      artImpFNAH: artImpFNAH ?? this.artImpFNAH,
      artMntTaxeTib: artMntTaxeTib ?? this.artMntTaxeTib,
      artMntTaxeFnah: artMntTaxeFnah ?? this.artMntTaxeFnah,
      artAgentCont: artAgentCont ?? this.artAgentCont,
      artDateCont: artDateCont ?? this.artDateCont,
      artNumAvis: artNumAvis ?? this.artNumAvis,
      artVred: artVred ?? this.artVred,
      artTypeRue: artTypeRue ?? this.artTypeRue,
      artNumRue: artNumRue ?? this.artNumRue,
      artBis: artBis ?? this.artBis,
      artBloc: artBloc ?? this.artBloc,
      artOrdreBloc: artOrdreBloc ?? this.artOrdreBloc,
      artCodePos: artCodePos ?? this.artCodePos,
      artSectBur: artSectBur ?? this.artSectBur,
      artPresNet: artPresNet ?? this.artPresNet,
      artPresEcl: artPresEcl ?? this.artPresEcl,
      artPresCh: artPresCh ?? this.artPresCh,
      artPresTr: artPresTr ?? this.artPresTr,
      artPresEauU: artPresEauU ?? this.artPresEauU,
      artPresEauP: artPresEauP ?? this.artPresEauP,
      artPresAut: artPresAut ?? this.artPresAut,
      artSurTotCont: artSurTotCont ?? this.artSurTotCont,
      artSurCouvCont: artSurCouvCont ?? this.artSurCouvCont,
      artLoyeeAnn: artLoyeeAnn ?? this.artLoyeeAnn,
      artConstArt: artConstArt ?? this.artConstArt,
      artCompArt: artCompArt ?? this.artCompArt,
      artUtilArt: artUtilArt ?? this.artUtilArt,
      artTitreFonc: artTitreFonc ?? this.artTitreFonc,
      artValVen: artValVen ?? this.artValVen,
      artDens: artDens ?? this.artDens,
      artDatePoss: artDatePoss ?? this.artDatePoss,
      artDateImp: artDateImp ?? this.artDateImp,
      artSitu: artSitu ?? this.artSitu,
      artFrontNord: artFrontNord ?? this.artFrontNord,
      artFrontSud: artFrontSud ?? this.artFrontSud,
      artFrontEst: artFrontEst ?? this.artFrontEst,
      artFrontOuest: artFrontOuest ?? this.artFrontOuest,
      artDateEtat: artDateEtat ?? this.artDateEtat,
      artCodeAvTrans: artCodeAvTrans ?? this.artCodeAvTrans,
      artCodeApTrans: artCodeApTrans ?? this.artCodeApTrans,
      artDerAnneeRole: artDerAnneeRole ?? this.artDerAnneeRole,
      artDerAnnee_1Role: artDerAnnee_1Role ?? this.artDerAnnee_1Role,
      artCite: artCite ?? this.artCite,
      artsecteur: artsecteur ?? this.artsecteur,
      artCellule: artCellule ?? this.artCellule,
      artNomResid: artNomResid ?? this.artNomResid,
      artNomImmeuble: artNomImmeuble ?? this.artNomImmeuble,
      artEtage: artEtage ?? this.artEtage,
      artAppart: artAppart ?? this.artAppart,
      artTypeHabit: artTypeHabit ?? this.artTypeHabit,
      artActivSecond: artActivSecond ?? this.artActivSecond,
      artEnseigne: artEnseigne ?? this.artEnseigne,
      artNomAgent: artNomAgent ?? this.artNomAgent,
      artDateRecens: artDateRecens ?? this.artDateRecens,
      typeCollect: typeCollect ?? this.typeCollect,
      artIdMiseAJour: artIdMiseAJour ?? this.artIdMiseAJour,
      artDeclCode: artDeclCode ?? this.artDeclCode,
      artAgentDecl: artAgentDecl ?? this.artAgentDecl,
      artQualDecl: artQualDecl ?? this.artQualDecl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
