// Complete EtablissementModel with all required fields from ARTICLE table
class EtablissementModel {
  // Static reference data for dropdowns and display

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
    {"value": "158", "label": "نادي اعلامية موجهة للطفل"},
    {"value": "159", "label": "مرکب تبرید"},
    {"value": "16", "label": "بيع الفواكه الجافة"},
    {"value": "17", "label": "بيع الخضر والغلال"},
    {"value": "176", "label": "بيع العسل"},
    {"value": "177", "label": "بيع مواد غذائية بالجملة"},
    {"value": "178", "label": "بيع التوابل"},
    {"value": "179", "label": "بيع الزهور"},
    {"value": "18", "label": "بيع التبغ"},
    {"value": "180", "label": "بيع مادة القهوة"},
    {"value": "181", "label": "بيع مرطبات"},
    {"value": "182", "label": "بيع العلف"},
    {"value": "183", "label": "بيع مواد حديدية وكهربائية"},
    {"value": "184", "label": "بيع أجهزة منزلية"},
    {"value": "185", "label": "بيع الخبز"},
    {"value": "186", "label": "بيع مواد فلاحية"},
    {"value": "187", "label": "بيع البلاستيك والحبال"},
    {"value": "188", "label": "بيع الاجهزة القديمة"},
    {"value": "189", "label": "بيع مواد البناء"},
    {"value": "190", "label": "بيع قطع غيار السيارات"},
    {"value": "191", "label": "بيع قطع غيار الدرجات"},
    {"value": "192", "label": "بيع الأحذية"},
    {"value": "193", "label": "بيع الأقمشة"},
    {"value": "194", "label": "بيع الحليب ومشتقاته"},
    {"value": "195", "label": "بيع الصوف"},
    {"value": "196", "label": "بيع الملابس القديمة"},
    {"value": "197", "label": "بيع الملابس الجاهزة"},
    {"value": "198", "label": "بيع مواد التنظيف"},
    {"value": "199", "label": "بيع العطورات"},
    {"value": "200", "label": "بيع الدجاج والبيض"},
    {"value": "201", "label": "بيع ادوات مدرسية"},
    {"value": "202", "label": "بيع الأكلة الخفيفة"},
    {"value": "203", "label": "بيع أشرطة سمعية"},
    {"value": "204", "label": "بيع وكراء أشرطة فيديو"},
    {"value": "205", "label": "بيع اللحوم"},
    {"value": "206", "label": "بيع مواد التجميل"},
    {"value": "207", "label": "بيع الطاقة الشمسية"},
    {"value": "208", "label": "بيع مواد كهربائية"},
    {"value": "209", "label": "بيع المثلجات"},
    {"value": "210", "label": "بيع المواد الغذائية والمطعم"},
    {"value": "211", "label": "صناعات تقليدية"},
    {"value": "212", "label": "معمل بلاستيك"},
    {"value": "213", "label": "معمل اسلاك كهربائية"},
    {"value": "214", "label": "معمل دهن ومشتقاته"},
    {"value": "215", "label": "صنع الأحذية"},
    {"value": "216", "label": "صناعة جلدية عتيقة"},
    {"value": "217", "label": "معمل خياطة"},
    {"value": "218", "label": "معمل جوارب"},
    {"value": "219", "label": "معمل زربية"},
    {"value": "220", "label": "تصبير وتصدير السمك"},
    {"value": "221", "label": "معمل طماطم"},
    {"value": "222", "label": "بيع وتصليح الهاتف الجوال"},
    {"value": "223", "label": "بيع وتصليح الآلات الموسيقية"},
    {"value": "224", "label": "بيع واصلاح الحاسوب"},
    {"value": "225", "label": "اصلاح الدراجات"},
    {"value": "226", "label": "ترقيع العجلات"},
    {"value": "227", "label": "مدرسة ابتدائية"},
    {"value": "228", "label": "مدرسة خاصة"},
    {"value": "229", "label": "روضة أطفال"},
    {"value": "230", "label": "مدرسة تعليم السياقة"},
    {"value": "231", "label": "معهد خاص"},
    {"value": "232", "label": "حضانة"},
    {"value": "233", "label": "TATOUAGE"},
    {"value": "234", "label": "FRIGO"},
    {"value": "235", "label": "دهن الموبيليا"},
    {"value": "236", "label": "وكالة عقارية"},
    {"value": "237", "label": "كراء السيارات"},
    {"value": "238", "label": "حزب سياسي"},
    {"value": "239", "label": "علاج طبيعي"},
    {"value": "240", "label": "مركب ترفيهي"},
    {"value": "241", "label": "عطار"},
    {"value": "242", "label": "محل شاعر"},
    {"value": "243", "label": "مقهى"},
    {"value": "244", "label": "مشرية"},
    {"value": "245", "label": "حانة"},
    {"value": "246", "label": "مغازة"},
    {"value": "247", "label": "جزار"},
    {"value": "248", "label": "اسطبل"},
    {"value": "249", "label": "تربية الحيوانات"},
    {"value": "250", "label": "حداد"},
    {"value": "251", "label": "مطالة ودهن"},
    {"value": "252", "label": "تعاضدية الخدمات الفلاحية"},
    {"value": "253", "label": "محطة لغسل السيارات"},
    {"value": "254", "label": "تغليف الكراسي"},
    {"value": "255", "label": "نقش على الخشب"},
    {"value": "256", "label": "مطعم"},
    {"value": "257", "label": "نارزی"},
    {"value": "258", "label": "حياكة الصوف"},
    {"value": "259", "label": "تنظيف بالشائح"},
    {"value": "260", "label": "مصاغة"},
    {"value": "261", "label": "ديوان الحبوب"},
    {"value": "262", "label": "مكتب حسابات"},
    {"value": "263", "label": "مترجم محلف"},
    {"value": "264", "label": "وكالة إشهار"},
    {"value": "265", "label": "صيدلية"},
    {"value": "266", "label": "طبيب عام"},
    {"value": "267", "label": "طبيب مختص"},
    {"value": "268", "label": "بيطري"},
    {"value": "269", "label": "مخبر تحاليل طبية"},
    {"value": "270", "label": "ميكانيك عام"},
    {"value": "271", "label": "كهرباء السيارات"},
    {"value": "272", "label": "إصلاح الرادياتور"},
    {"value": "273", "label": "إصلاح وبيع الساعات"},
    {"value": "274", "label": "إصلاح الراديو والتلفزة"},
    {"value": "275", "label": "إصلاح وصنع المفاتيح"},
    {"value": "276", "label": "كاتب عمومي"},
    {"value": "277", "label": "عدل منفذ"},
    {"value": "278", "label": "عدل إشهاد"},
    {"value": "279", "label": "محامي"},
    {"value": "280", "label": "نيابة تأمين"},
    {"value": "281", "label": "إدارة"},
    {"value": "282", "label": "مكتب دراسات"},
    {"value": "283", "label": "وكالة أسفار"},
    {"value": "284", "label": "بنك"},
    {"value": "285", "label": "قاعة سينما"},
    {"value": "286", "label": "مركز عمومي للاتصالات"},
    {"value": "287", "label": "حمام"},
    {"value": "288", "label": "حلاق"},
    {"value": "289", "label": "مصور"},
    {"value": "290", "label": "مركز الكفاءة للغات والإعلامية"},
    {"value": "291", "label": "التضامن الاجتماعي"},
    {"value": "292", "label": "الدعم في مجال التعليم"},
    {"value": "2000", "label": "مدرسة ابتدائية"},
    {"value": "2001", "label": "مدرسة خاصة"},
    {"value": "2002", "label": "روضة أطفال"},
    {"value": "2003", "label": "مدرسة تعليم السياقة"},
    {"value": "2004", "label": "معهد خاص"},
    {"value": "2005", "label": "حضانة"},
    {"value": "2006", "label": "مدرسة ابتدائية"},
    {"value": "2007", "label": "مدرسة خاصة"},
    {"value": "2008", "label": "روضة أطفال"},
    {"value": "2009", "label": "مدرسة تعليم السياقة"},
    {"value": "2010", "label": "معهد خاص"},
    {"value": "2011", "label": "حضانة"},
    {"value": "2012", "label": "مدرسة ابتدائية"},
    {"value": "2013", "label": "مدرسة خاصة"},
    {"value": "2014", "label": "روضة أطفال"},
  ];

  // Essential fields only - to avoid database schema issues
  final String artNouvCode;           // Article Nouveau Code (REQUIRED)
  final String? artAgent;             // Agent
  final String? artOccup;             // Occupant
  final String? artNomCommerce;       // Nom Commerce
  final String? artAdresse;           // Adresse complète
  final String? artProprietaire;      // Nom du propriétaire
  final String? artRedCode;           // CIN du propriétaire
  final int? artTelDecl;              // Téléphone domicile (8 chiffres max)
  final String? artCatArt;            // Catégorie Article (Activité)
  final double? artSurCouv;          // Surface Couverte (pour calcul taxe)
  final int? artServitudesMunicipales;  // Nombre de servitudes municipales (1-5)
  final int? artAutresServitudes;       // Autres servitudes (0 ou 1 - case à cocher)
  final double? prixm2;              // Prix par mètre carré (pour calcul taxe immobilière)
  final double? artTauxPres;         // Taux Prestation (pour calcul taxe)
  final double? artMntTaxe;          // Montant de la Taxe (calculé automatiquement)
  final double? artChiffreAffairesLocal;  // Chiffre d'affaires brut local
  final double? artExportations;          // Exportations
  final double? artTaxeImmobiliere;       // Taxe immobilière (minimum)
  final double? artLatitude;              // Latitude
  final double? artLongitude;             // Longitude
  final String? artDebPer;           // Début Période
  final String? artFinPer;           // Fin Période
  final int? artEtat;                 // 1 paye taxe, 0 ne paye pas
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EtablissementModel({
    required this.artNouvCode,
    this.artAgent,
    this.artOccup,
    this.artNomCommerce,
    this.artAdresse,
    this.artProprietaire,
    this.artRedCode,
    this.artTelDecl,
    this.artCatArt,
    this.artSurCouv,
    this.artServitudesMunicipales,
    this.artAutresServitudes,
    this.prixm2,
    this.artTauxPres,
    this.artMntTaxe,
    this.artChiffreAffairesLocal,
    this.artExportations,
    this.artTaxeImmobiliere,
    this.artLatitude,
    this.artLongitude,
    this.artDebPer,
    this.artFinPer,
    this.artEtat,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor from JSON
  factory EtablissementModel.fromJson(Map<String, dynamic> json) {
    return EtablissementModel(
      artNouvCode: json['artnouvcode'] ?? '',
      artAgent: json['artagent'],
      artOccup: json['artoccup'],
      artNomCommerce: json['artnomcommerce'],
      artAdresse: json['artadresse'],
      artProprietaire: json['artproprietaire'],
      artRedCode: json['artredcode'],
      artTelDecl: json['artteldecl'] != null ? int.tryParse(json['artteldecl'].toString()) : null,
      artCatArt: json['artcatart'],
      artSurCouv: json['artsurcouv'] != null ? double.tryParse(json['artsurcouv'].toString()) : null,
      artServitudesMunicipales: json['artservitudesmunicipales'] != null ? int.tryParse(json['artservitudesmunicipales'].toString()) : null,
      artAutresServitudes: json['artautresservitudes'] != null ? int.tryParse(json['artautresservitudes'].toString()) : null,
      prixm2: json['prixm2'] != null ? double.tryParse(json['prixm2'].toString()) : null,
      artTauxPres: json['arttauxpres'] != null ? double.tryParse(json['arttauxpres'].toString()) : null,
      artMntTaxe: json['artmnttaxe'] != null ? double.tryParse(json['artmnttaxe'].toString()) : null,
      artChiffreAffairesLocal: json['artchiffreaffaireslocal'] != null ? double.tryParse(json['artchiffreaffaireslocal'].toString()) : null,
      artExportations: json['artexportations'] != null ? double.tryParse(json['artexportations'].toString()) : null,
      artTaxeImmobiliere: json['arttaxeimmobiliere'] != null ? double.tryParse(json['arttaxeimmobiliere'].toString()) : null,
      artLatitude: json['artlatitude'] != null ? double.tryParse(json['artlatitude'].toString()) : null,
      artLongitude: json['artlongitude'] != null ? double.tryParse(json['artlongitude'].toString()) : null,
      artDebPer: json['artdebper'],
      artFinPer: json['artfinper'],
      artEtat: json['artetat'],
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'artnouvcode': artNouvCode,
      'artagent': artAgent,
      'artoccup': artOccup,
      'artnomcommerce': artNomCommerce,
      'artadresse': artAdresse,
      'artproprietaire': artProprietaire,
      'artredcode': artRedCode,
      'artteldecl': artTelDecl?.toString(),
      'artcatart': artCatArt,
      'artsurcouv': artSurCouv?.toString(),
      'artservitudesmunicipales': artServitudesMunicipales?.toString(),
      'artautresservitudes': artAutresServitudes?.toString(),
      'prixm2': prixm2?.toString(),
      'arttauxpres': artTauxPres?.toString(),
      'artmnttaxe': artMntTaxe?.toString(),
      'artchiffreaffaireslocal': artChiffreAffairesLocal?.toString(),
      'artexportations': artExportations?.toString(),
      'arttaxeimmobiliere': artTaxeImmobiliere?.toString(),
      'artlatitude': artLatitude?.toString(),
      'artlongitude': artLongitude?.toString(),
      'artdebper': artDebPer,
      'artfinper': artFinPer,
      'artetat': artEtat,
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
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  // Copy with method for updates
  EtablissementModel copyWith({
    String? artNouvCode,
    String? artAgent,
    String? artOccup,
    String? artNomCommerce,
    String? artAdresse,
    String? artProprietaire,
    String? artRedCode,
    int? artTelDecl,
    String? artCatArt,
    double? artSurCouv,
    int? artServitudesMunicipales,
    int? artAutresServitudes,
    double? prixm2,
    double? artTauxPres,
    double? artMntTaxe,
    double? artChiffreAffairesLocal,
    double? artExportations,
    double? artTaxeImmobiliere,
    double? artLatitude,
    double? artLongitude,
    String? artDebPer,
    String? artFinPer,
    int? artEtat,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EtablissementModel(
      artNouvCode: artNouvCode ?? this.artNouvCode,
      artAgent: artAgent ?? this.artAgent,
      artOccup: artOccup ?? this.artOccup,
      artNomCommerce: artNomCommerce ?? this.artNomCommerce,
      artAdresse: artAdresse ?? this.artAdresse,
      artProprietaire: artProprietaire ?? this.artProprietaire,
      artRedCode: artRedCode ?? this.artRedCode,
      artTelDecl: artTelDecl ?? this.artTelDecl,
      artCatArt: artCatArt ?? this.artCatArt,
      artSurCouv: artSurCouv ?? this.artSurCouv,
      artServitudesMunicipales: artServitudesMunicipales ?? this.artServitudesMunicipales,
      artAutresServitudes: artAutresServitudes ?? this.artAutresServitudes,
      prixm2: prixm2 ?? this.prixm2,
      artTauxPres: artTauxPres ?? this.artTauxPres,
      artMntTaxe: artMntTaxe ?? this.artMntTaxe,
      artChiffreAffairesLocal: artChiffreAffairesLocal ?? this.artChiffreAffairesLocal,
      artExportations: artExportations ?? this.artExportations,
      artTaxeImmobiliere: artTaxeImmobiliere ?? this.artTaxeImmobiliere,
      artLatitude: artLatitude ?? this.artLatitude,
      artLongitude: artLongitude ?? this.artLongitude,
      artDebPer: artDebPer ?? this.artDebPer,
      artFinPer: artFinPer ?? this.artFinPer,
      artEtat: artEtat ?? this.artEtat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  @override
  String toString() {
    return 'EtablissementModel(artNouvCode: $artNouvCode, artNomCommerce: $artNomCommerce, artAdresse: $artAdresse)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EtablissementModel && other.artNouvCode == artNouvCode;
  }

  @override
  int get hashCode => artNouvCode.hashCode;
}