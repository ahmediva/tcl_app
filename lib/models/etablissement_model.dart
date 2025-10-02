class EtablissementModel {
  // Static reference data for dropdowns and display
  static const List<Map<String, String>> arrondissements = [
    {"code": "01", "libelle": "01حي البستان_"},
    {"code": "02", "libelle": "02حي الجنان_"},
    {"code": "03", "libelle": "03حي المستشفى_"},
    {"code": "04", "libelle": "04حي القصيبة_"},
    {"code": "05", "libelle": "05الحي الشرقي_"},
    {"code": "06", "libelle": "06وسط المدينة_"},
    {"code": "07", "libelle": "07حي الرياض_"},
    {"code": "08", "libelle": "08حي الزهور_"},
    {"code": "09", "libelle": "09حي المرداس_"},
    {"code": "10", "libelle": "10حي الشاطئ_"},
    {"code": "11", "libelle": "عين قرنز"},
    {"code": "12", "libelle": "تقديمـان"},
    {"code": "13", "libelle": "الذروة"},
    {"code": "14", "libelle": "عمادة وادي الخطف معتمدية قليبية"},
    {"code": "15", "libelle": "عمادة قليبية الغربية معتمدية قليبية"},
    {"code": "16", "libelle": "بني رزين"},
  ];

  static const List<Map<String, String>> etatOptions = [
    {"value": "1", "label": "Paye Taxe"},
    {"value": "0", "label": "Ne Paye Pas"},
  ];

  static const List<Map<String, String>> redTypePrporOptions = [
    {"value": "1", "label": "Type 1"},
    {"value": "2", "label": "Type 2"},
    {"value": "3", "label": "Type 3"},
  ];

  static const List<Map<String, String>> artCatActiviteOptions = [
    {"value": "2", "label": "مطار"},
    {"value": "3", "label": "بيع مرطبات"},
    {"value": "4", "label": "بيع الخبز"},
    {"value": "5", "label": "مخبزة"},
    {"value": "6", "label": "مطعم"},
    {"value": "7", "label": "بيع الحليب ومشتقاته"},
    {"value": "8", "label": "بيع الدجاج والبيض"},
    {"value": "10", "label": "صنع المرطبات"},
    {"value": "11", "label": "بيع الزيت"},
    {"value": "12", "label": "معصرة زيتون"},
    {"value": "13", "label": "فطائري"},
    {"value": "14", "label": "معمل مصيرات غذائية"},
    {"value": "15", "label": "رحي الحبوب والتوابل"},
    {"value": "16", "label": "بيع الفواكه الجافة"},
    {"value": "17", "label": "بيع الخضر والغلال"},
    {"value": "18", "label": "بيع مواد غذائية بالجملة"},
    {"value": "19", "label": "بيع التوابل"},
    {"value": "20", "label": "بيع التبغ"},
    {"value": "21", "label": "مطار"},
    {"value": "22", "label": "بيع مادة القهوة"},
    {"value": "23", "label": "مقهى"},
    {"value": "24", "label": "مدرسة"},
    {"value": "25", "label": "حانة"},
    {"value": "26", "label": "مغازة"},
    {"value": "27", "label": "صيدلية"},
    {"value": "28", "label": "طبيب عام"},
    {"value": "29", "label": "طبيب مختص"},
    {"value": "30", "label": "بيطري"},
    {"value": "31", "label": "مخبر تحاليل طبية"},
    {"value": "32", "label": "جزار"},
    {"value": "33", "label": "اسطبل"},
    {"value": "34", "label": "تربية الحيوانات"},
    {"value": "35", "label": "بيع العلف"},
    {"value": "36", "label": "حداد"},
    {"value": "37", "label": "بيع مواد حديدية وكهربائية"},
    {"value": "38", "label": "بيع أجهزة منزلية"},
    {"value": "39", "label": "مطالة ودهن"},
    {"value": "40", "label": "بيع مواد فلاحية"},
    {"value": "41", "label": "تعاونية الخدمات الفلاحية"},
    {"value": "42", "label": "بيع البلاستيك والمطاط"},
    {"value": "43", "label": "بيع الأجهزة القديمة"},
    {"value": "44", "label": "معمل أسلاك كهربائية"},
    {"value": "45", "label": "بيع دهن ومشتقاته"},
    {"value": "46", "label": "بيع مواد البناء"},
    {"value": "47", "label": "ميكانيكي عام"},
    {"value": "48", "label": "اصلاح الدراجات"},
    {"value": "49", "label": "ترقيع العجلات"},
    {"value": "50", "label": "كهرباء السيارات"},
    {"value": "51", "label": "اصلاح الرادياتور"},
    {"value": "52", "label": "بيع قطع غيار السيارات"},
    {"value": "53", "label": "بيع قطع غيار الدراجات"},
    {"value": "54", "label": "محطة لغسل السيارات"},
    {"value": "55", "label": "تغليف الكراسي"},
    {"value": "56", "label": "اصلاح وبيع الساعات"},
    {"value": "57", "label": "اصلاح الراديو والتلفزة"},
    {"value": "58", "label": "بيع وإصلاح قطع غيار الالكترونيك"},
    {"value": "59", "label": "نقل على الكعب"},
    {"value": "60", "label": "بيع الأحذية"},
    {"value": "61", "label": "اصلاح الأحذية"},
    {"value": "62", "label": "صنع الأحذية"},
    {"value": "63", "label": "صناعة جلدية مشتقة"},
    {"value": "64", "label": "تارزي"},
    {"value": "65", "label": "معمل خياطة"},
    {"value": "66", "label": "بيع الأقمشة"},
    {"value": "67", "label": "معمل جوارب"},
    {"value": "68", "label": "بيع الملابس"},
    {"value": "69", "label": "حياكة الصوف"},
    {"value": "70", "label": "بيع الصوف"},
    {"value": "71", "label": "بيع الملابس القديمة"},
    {"value": "72", "label": "بيع الملابس الجاهزة"},
    {"value": "73", "label": "تنظيف بالفاتح"},
    {"value": "74", "label": "بيع مواد التنظيف"},
    {"value": "75", "label": "بيع العطورات"},
    {"value": "76", "label": "كاتب عمومي"},
    {"value": "77", "label": "عدل منفذ"},
    {"value": "78", "label": "عدل إشهاد"},
    {"value": "79", "label": "محامي"},
    {"value": "80", "label": "نيابة تأمين"},
    {"value": "81", "label": "إدارة"},
    {"value": "82", "label": "روضة أطفال"},
    {"value": "83", "label": "بيع أدوات مدرسية"},
    {"value": "84", "label": "مدرسة تعليم السياقة"},
    {"value": "85", "label": "معهد خاص"},
    {"value": "86", "label": "حضانة"},
    {"value": "87", "label": "مكتب دراسات"},
    {"value": "88", "label": "وكالة أسفار"},
    {"value": "89", "label": "بيع الأكلة الخفيفة"},
    {"value": "90", "label": "بنك"},
    {"value": "91", "label": "قاعة سينما"},
    {"value": "92", "label": "مركز عمومي للاتصالات"},
    {"value": "93", "label": "حمام"},
    {"value": "94", "label": "حلاق"},
    {"value": "95", "label": "مصاغة"},
    {"value": "96", "label": "إصلاح وصنع المفاتيح"},
    {"value": "97", "label": "بيع أشرطة سمعية"},
    {"value": "98", "label": "بيع وكراء أشرطة فيديو"},
    {"value": "99", "label": "مصور"},
    {"value": "100", "label": "نجار"},
    {"value": "1000", "label": "نزل"},
    {"value": "101", "label": "بيع الخشب ومشتقاته"},
    {"value": "102", "label": "قاعة عرض تجارة"},
    {"value": "103", "label": "بيع وتركيب البلور"},
    {"value": "104", "label": "تجارة الأليمينيوم"},
    {"value": "105", "label": "صنع الموزييك"},
    {"value": "106", "label": "صنع قوالب الجبس"},
    {"value": "107", "label": "بيع الفحم والغاز"},
    {"value": "108", "label": "اصلاح موافيد النفط"},
    {"value": "109", "label": "إصلاح الثلاجات"},
    {"value": "110", "label": "بيع المحروقات"},
    {"value": "111", "label": "محطة بنزين"},
    {"value": "112", "label": "بيع الغاز"},
    {"value": "113", "label": "مخزن"},
    {"value": "114", "label": "بيع الفخار"},
    {"value": "115", "label": "بيع السمك"},
    {"value": "116", "label": "بيع وإصلاح الساعات"},
    {"value": "117", "label": "حلاقة"},
    {"value": "118", "label": "Plombier"},
    {"value": "119", "label": "الرخام المركب"},
    {"value": "120", "label": "معمل فاروز - درويو"},
    {"value": "121", "label": "بيع الحراري"},
    {"value": "122", "label": "كراء لوازم الافراح"},
    {"value": "123", "label": "تاجر"},
    {"value": "124", "label": "مسجد"},
    {"value": "125", "label": "مخبر أسنان"},
    {"value": "126", "label": "قاعة العاب"},
    {"value": "127", "label": "Mercerie"},
    {"value": "128", "label": "مكتب عمدة"},
    {"value": "129", "label": "اصلاح آلات الخياطة"},
    {"value": "130", "label": "تعمير قوارير الإطفاء"},
    {"value": "131", "label": "تزويق"},
    {"value": "132", "label": "محل تمريض"},
    {"value": "133", "label": "حطاب"},
    {"value": "134", "label": "Supermarché"},
    {"value": "135", "label": "Faux- Bijoux"},
    {"value": "136", "label": "بيع النظارات"},
    {"value": "137", "label": "Electrique"},
    {"value": "138", "label": "TOURNEUR"},
    {"value": "139", "label": "بيع الحديد"},
    {"value": "140", "label": "قاعة عرض حدادة"},
    {"value": "141", "label": "صنع الفورية"},
    {"value": "142", "label": "خراطة"},
    {"value": "143", "label": "قاعة أفراح"},
    {"value": "144", "label": "بيع آلات الخياطة"},
    {"value": "145", "label": "مغازة"},
    {"value": "146", "label": "مطبعة وراقة"},
    {"value": "147", "label": "بيع الملابس والمحافظ الجلدية"},
    {"value": "148", "label": "قاعة عرض"},
    {"value": "149", "label": "صنع الكراسي"},
    {"value": "150", "label": "قاعة رياضية"},
    {"value": "151", "label": "صقل الرخام"},
    {"value": "152", "label": "مخبر صور"},
    {"value": "153", "label": "مهندس معماري"},
    {"value": "154", "label": "اصلاح وبيع البرابول"},
    {"value": "155", "label": "مدرسة خاصة"},
    {"value": "156", "label": "بيع مواد شبه طبية"},
    {"value": "157", "label": "بيع الموالح"},
    {"value": "158", "label": "قاعة إعلامية موجهة للطفل"},
    {"value": "159", "label": "مركز تبريد"},
    {"value": "176", "label": "بيع العمل"},
    {"value": "177", "label": "بيع وتصليح الهاتف الجوال"},
    {"value": "178", "label": "بيع وتصليح الآلات الموسيقية"},
    {"value": "179", "label": "صناعات تقليدية"},
    {"value": "180", "label": "خدمات إعلامية"},
    {"value": "181", "label": "مكتب حسابات"},
    {"value": "182", "label": "نساج"},
    {"value": "183", "label": "مدرسة ابتدائية"},
    {"value": "184", "label": "TATOUAGE"},
    {"value": "185", "label": "معمل بلاستيك"},
    {"value": "186", "label": "دهن الموبيليا"},
    {"value": "187", "label": "وكالة عقارية"},
    {"value": "188", "label": "مرسم محلف"},
    {"value": "189", "label": "كراء السيارات"},
    {"value": "190", "label": "بيع الزهور"},
    {"value": "191", "label": "حزاب سياسي"},
    {"value": "192", "label": "علاج طبيعي"},
    {"value": "193", "label": "بيع وإصلاح الحاسوب"},
    {"value": "194", "label": "مركب ترفيهي"},
    {"value": "195", "label": "وكالة إشهار"},
    {"value": "196", "label": "مدرسة خاصة"},
    {"value": "197", "label": "FRIGO"},
    {"value": "2000", "label": "محل شامل"},
    {"value": "2001", "label": "مدرسة تجميل"},
    {"value": "2002", "label": "خياطة الستائر"},
    {"value": "2003", "label": "بيع اللحوم"},
    {"value": "2004", "label": "بيع مواد التجميل"},
    {"value": "2005", "label": "بيع الطاقة الشمسية"},
    {"value": "2006", "label": "مركز الكفاءة للغات والإعلامية"},
    {"value": "2007", "label": "بيع مواد كهربائية"},
    {"value": "2008", "label": "التضامن الاجتماعي"},
    {"value": "2009", "label": "تصبير وتصدير السمك"},
    {"value": "2010", "label": "ديوان الحبوب"},
    {"value": "2011", "label": "معمل طماطم"},
    {"value": "2012", "label": "الدعم في مجال التعليم"},
    {"value": "2013", "label": "بيع المثلجات"},
    {"value": "2014", "label": "بيع المواد الغذائية والمطعم"},
  ];

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

  // Helper methods for display
  String get displayArrondissement {
    final arrondissement = arrondissements.firstWhere(
      (a) => a["code"] == artArrond,
      orElse: () => {"code": artArrond, "libelle": artArrond},
    );
    return arrondissement["libelle"] ?? artArrond;
  }

  String get displayEtat {
    final etat = etatOptions.firstWhere(
      (e) => e["value"] == artEtat.toString(),
      orElse: () => {"value": artEtat.toString(), "label": artEtat.toString()},
    );
    return etat["label"] ?? artEtat.toString();
  }

  String get displayRedTypePrpor {
    if (redTypePrpor == null) return "Non défini";
    final type = redTypePrporOptions.firstWhere(
      (t) => t["value"] == redTypePrpor.toString(),
      orElse: () => {"value": redTypePrpor.toString(), "label": redTypePrpor.toString()},
    );
    return type["label"] ?? redTypePrpor.toString();
  }

  String get displayCatActivite {
    if (artCatActivite == null) return "Non défini";
    final categorie = artCatActiviteOptions.firstWhere(
      (c) => c["value"] == artCatActivite.toString(),
      orElse: () => {"value": artCatActivite.toString(), "label": artCatActivite.toString()},
    );
    return categorie["label"] ?? artCatActivite.toString();
  }

  String get displayImposable {
    return artImp == 1 ? "Oui" : "Non";
  }

  String get displayOccupVoie {
    return artOccupVoie == 1 ? "Oui" : "Non";
  }

  String get fullAddress {
    final parts = <String>[];
    if (artRue.isNotEmpty) parts.add(artRue);
    if (artTexteAdresse != null && artTexteAdresse!.isNotEmpty) {
      parts.add(artTexteAdresse!);
    }
    parts.add(displayArrondissement);
    return parts.join(", ");
  }

  bool get hasCoordinates => artLatitude != null && artLongitude != null;

  Map<String, double>? get coordinates {
    if (hasCoordinates) {
      return {
        'latitude': artLatitude!,
        'longitude': artLongitude!,
      };
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
