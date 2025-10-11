import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../providers/establishment_provider.dart';
import '../../models/etablissement_model.dart';

class EstablishmentList extends StatefulWidget {
  const EstablishmentList({Key? key}) : super(key: key);

  @override
  _EstablishmentListState createState() => _EstablishmentListState();
}

class _EstablishmentListState extends State<EstablishmentList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch establishments when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EstablishmentProvider>().fetchEtablissements();
    });
  }

  List<EtablissementModel> get _filteredEstablishments {
    final establishments = context.watch<EstablishmentProvider>().etablissements;
    if (_searchQuery.isEmpty) {
      return establishments;
    }
    return establishments.where((establishment) {
      final code = establishment.artNouvCode.toLowerCase();
      final nomCommerce = establishment.artNomCommerce?.toLowerCase() ?? '';
      final proprietaire = establishment.artProprietaire?.toLowerCase() ?? '';
      final cin = establishment.artRedCode?.toLowerCase() ?? '';
      final occupant = establishment.artOccup?.toLowerCase() ?? '';
      final adresse = establishment.artAdresse?.toLowerCase() ?? '';
      final agent = establishment.artAgent?.toLowerCase() ?? '';
  
      final searchLower = _searchQuery.toLowerCase();
      
      return code.contains(searchLower) ||
             nomCommerce.contains(searchLower) ||
             proprietaire.contains(searchLower) ||
             cin.contains(searchLower) ||
             occupant.contains(searchLower) ||
             adresse.contains(searchLower) ||
             agent.contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EstablishmentProvider>(
      builder: (context, provider, child) {
        return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Établissements'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.establishmentForm);
            },
            icon: Icon(Icons.add),
            tooltip: 'Ajouter un établissement',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un établissement...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        icon: Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Results Count
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_filteredEstablishments.length} établissement(s) trouvé(s)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredEstablishments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredEstablishments.length,
                        itemBuilder: (context, index) {
                          final establishment = _filteredEstablishments[index];
                          return _buildEstablishmentCard(establishment);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.establishmentForm);
        },
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Ajouter un établissement',
      ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'Aucun établissement enregistré'
                : 'Aucun résultat trouvé',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Commencez par ajouter un établissement'
                : 'Essayez avec d\'autres mots-clés',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.establishmentForm);
            },
            icon: Icon(Icons.add),
            label: Text('Ajouter un établissement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstablishmentCard(EtablissementModel establishment) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showEstablishmentDetails(establishment);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getStatusColor(establishment.artEtat).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(establishment.artCatArt),
                      color: _getStatusColor(establishment.artEtat),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                          establishment.artNomCommerce ?? 'Établissement ${establishment.artNouvCode}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          establishment.artAdresse ?? 'Adresse non disponible',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(establishment.artEtat).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(establishment.artEtat),
                          style: TextStyle(
                            color: _getStatusColor(establishment.artEtat),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _showDeleteConfirmation(context, establishment),
                        icon: Icon(Icons.delete, color: Colors.red, size: 20),
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                        tooltip: 'Supprimer',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    _getCategoryLabel(establishment.artCatArt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.person, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    establishment.artProprietaire ?? 'Propriétaire non spécifié',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    establishment.artEtat == 0 
                        ? 'Taxe Immobilière: ${establishment.artTaxeImmobiliere?.toStringAsFixed(2) ?? '0.00'} DT'
                        : 'Montant TCL: ${establishment.artMntTaxe?.toStringAsFixed(2) ?? '0.00'} DT',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.calendar_today, size: 14, color: Colors.blue[600]),
                  SizedBox(width: 4),
                  Text(
                    'Période: ${establishment.artDebPer ?? 'N/A'} - ${establishment.artFinPer ?? 'N/A'}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.person_outline, size: 14, color: Colors.orange[600]),
                  SizedBox(width: 4),
                  Text(
                    'Agent: ${establishment.artAgent ?? 'Non spécifié'}',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(int? artEtat) {
    if (artEtat == null) return Colors.grey;
    switch (artEtat) {
      case 1:
        return Colors.green; // Actif
      case 0:
        return Colors.red; // Inactif
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(int? artEtat) {
    if (artEtat == null) return 'Inconnu';
    switch (artEtat) {
      case 1:
        return 'Actif';
      case 0:
        return 'Inactif';
      default:
        return 'Inconnu';
    }
  }

  // Liste des catégories d'articles
  static const List<Map<String, String>> categoriesArticle = [
    {"code": "2", "libelle": "مطار"},
    {"code": "3", "libelle": "بيع مرطبات"},
    {"code": "4", "libelle": "بيع الخبز"},
    {"code": "5", "libelle": "مخبزة"},
    {"code": "6", "libelle": "مطعم"},
    {"code": "7", "libelle": "بيع الحليب ومشتقاته"},
    {"code": "8", "libelle": "بيع الدجاج والبيض"},
    {"code": "10", "libelle": "صنع المرطبات"},
    {"code": "11", "libelle": "بيع الزيت"},
    {"code": "12", "libelle": "معصرة زيتون"},
    {"code": "13", "libelle": "فطائري"},
    {"code": "14", "libelle": "معمل مصيرات غذائية"},
    {"code": "15", "libelle": "رحي الحبوب والتوابل"},
    {"code": "16", "libelle": "بيع الفواكه الجافة"},
    {"code": "17", "libelle": "بيع الخضر والغلال"},
    {"code": "18", "libelle": "بيع مواد غذائية بالجملة"},
    {"code": "19", "libelle": "بيع التوابل"},
    {"code": "20", "libelle": "بيع التبغ"},
    {"code": "21", "libelle": "مطار"},
    {"code": "22", "libelle": "بيع مادة القهوة"},
    {"code": "23", "libelle": "مقهى"},
    {"code": "24", "libelle": "مدرسة"},
    {"code": "25", "libelle": "حانة"},
    {"code": "26", "libelle": "مغازة"},
    {"code": "27", "libelle": "صيدلية"},
    {"code": "28", "libelle": "طبيب عام"},
    {"code": "29", "libelle": "طبيب مختص"},
    {"code": "30", "libelle": "بيطري"},
    {"code": "31", "libelle": "مخبر تحاليل طبية"},
    {"code": "32", "libelle": "جزار"},
    {"code": "33", "libelle": "اسطبل"},
    {"code": "34", "libelle": "تربية الحيوانات"},
    {"code": "35", "libelle": "بيع العلف"},
    {"code": "36", "libelle": "حداد"},
    {"code": "37", "libelle": "بيع مواد حديدية وكهربائية"},
    {"code": "38", "libelle": "بيع أجهزة منزلية"},
    {"code": "39", "libelle": "مطالة ودهن"},
    {"code": "40", "libelle": "بيع مواد فلاحية"},
    {"code": "41", "libelle": "تعاونية الخدمات الفلاحية"},
    {"code": "42", "libelle": "بيع البلاستيك والمطاط"},
    {"code": "43", "libelle": "بيع الأجهزة القديمة"},
    {"code": "44", "libelle": "معمل أسلاك كهربائية"},
    {"code": "45", "libelle": "بيع دهن ومشتقاته"},
    {"code": "46", "libelle": "بيع مواد البناء"},
    {"code": "47", "libelle": "ميكانيكي عام"},
    {"code": "48", "libelle": "اصلاح الدراجات"},
    {"code": "49", "libelle": "ترقيع العجلات"},
    {"code": "50", "libelle": "كهرباء السيارات"},
    {"code": "51", "libelle": "اصلاح الرادياتور"},
    {"code": "52", "libelle": "بيع قطع غيار السيارات"},
    {"code": "53", "libelle": "بيع قطع غيار الدراجات"},
    {"code": "54", "libelle": "محطة لغسل السيارات"},
    {"code": "55", "libelle": "تغليف الكراسي"},
    {"code": "56", "libelle": "اصلاح وبيع الساعات"},
    {"code": "57", "libelle": "اصلاح الراديو والتلفزة"},
    {"code": "58", "libelle": "بيع وإصلاح قطع غيار الالكترونيك"},
    {"code": "59", "libelle": "نقل على الكعب"},
    {"code": "60", "libelle": "بيع الأحذية"},
    {"code": "61", "libelle": "اصلاح الأحذية"},
    {"code": "62", "libelle": "صنع الأحذية"},
    {"code": "63", "libelle": "صناعة جلدية مشتقة"},
    {"code": "64", "libelle": "تارزي"},
    {"code": "65", "libelle": "معمل خياطة"},
    {"code": "66", "libelle": "بيع الأقمشة"},
    {"code": "67", "libelle": "معمل جوارب"},
    {"code": "68", "libelle": "بيع الملابس"},
    {"code": "69", "libelle": "حياكة الصوف"},
    {"code": "70", "libelle": "بيع الصوف"},
    {"code": "71", "libelle": "بيع الملابس القديمة"},
    {"code": "72", "libelle": "بيع الملابس الجاهزة"},
    {"code": "73", "libelle": "تنظيف بالفاتح"},
    {"code": "74", "libelle": "بيع مواد التنظيف"},
    {"code": "75", "libelle": "بيع العطورات"},
    {"code": "76", "libelle": "كاتب عمومي"},
    {"code": "77", "libelle": "عدل منفذ"},
    {"code": "78", "libelle": "عدل إشهاد"},
    {"code": "79", "libelle": "محامي"},
    {"code": "80", "libelle": "نيابة تأمين"},
    {"code": "81", "libelle": "إدارة"},
    {"code": "82", "libelle": "روضة أطفال"},
    {"code": "83", "libelle": "بيع أدوات مدرسية"},
    {"code": "84", "libelle": "مدرسة تعليم السياقة"},
    {"code": "85", "libelle": "معهد خاص"},
    {"code": "86", "libelle": "حضانة"},
    {"code": "87", "libelle": "مكتب دراسات"},
    {"code": "88", "libelle": "وكالة أسفار"},
    {"code": "89", "libelle": "بيع الأكلة الخفيفة"},
    {"code": "90", "libelle": "بنك"},
    {"code": "91", "libelle": "قاعة سينما"},
    {"code": "92", "libelle": "مركز عمومي للاتصالات"},
    {"code": "93", "libelle": "حمام"},
    {"code": "94", "libelle": "حلاق"},
    {"code": "95", "libelle": "مصاغة"},
    {"code": "96", "libelle": "إصلاح وصنع المفاتيح"},
    {"code": "97", "libelle": "بيع أشرطة سمعية"},
    {"code": "98", "libelle": "بيع وكراء أشرطة فيديو"},
    {"code": "99", "libelle": "مصور"},
    {"code": "100", "libelle": "نجار"},
    {"code": "1000", "libelle": "نزل"},
    {"code": "101", "libelle": "بيع الخشب ومشتقاته"},
    {"code": "102", "libelle": "قاعة عرض تجارة"},
    {"code": "103", "libelle": "بيع وتركيب البلور"},
    {"code": "104", "libelle": "تجارة الأليمينيوم"},
    {"code": "105", "libelle": "صنع الموزييك"},
    {"code": "106", "libelle": "صنع قوالب الجبس"},
    {"code": "107", "libelle": "بيع الفحم والغاز"},
    {"code": "108", "libelle": "اصلاح موافيد النفط"},
    {"code": "109", "libelle": "إصلاح الثلاجات"},
    {"code": "110", "libelle": "بيع المحروقات"},
    {"code": "111", "libelle": "محطة بنزين"},
    {"code": "112", "libelle": "بيع الغاز"},
    {"code": "113", "libelle": "مخزن"},
    {"code": "114", "libelle": "بيع الفخار"},
    {"code": "115", "libelle": "بيع السمك"},
    {"code": "116", "libelle": "بيع وإصلاح الساعات"},
    {"code": "117", "libelle": "حلاقة"},
    {"code": "118", "libelle": "Plombier"},
    {"code": "119", "libelle": "الرخام المركب"},
    {"code": "120", "libelle": "معمل فاروز - درويو"},
    {"code": "121", "libelle": "بيع الحراري"},
    {"code": "122", "libelle": "كراء لوازم الافراح"},
    {"code": "123", "libelle": "تاجر"},
    {"code": "124", "libelle": "مسجد"},
    {"code": "125", "libelle": "مخبر أسنان"},
    {"code": "126", "libelle": "قاعة العاب"},
    {"code": "127", "libelle": "Mercerie"},
    {"code": "128", "libelle": "مكتب عمدة"},
    {"code": "129", "libelle": "اصلاح آلات الخياطة"},
    {"code": "130", "libelle": "تعمير قوارير الإطفاء"},
    {"code": "131", "libelle": "تزويق"},
    {"code": "132", "libelle": "محل تمريض"},
    {"code": "133", "libelle": "حطاب"},
    {"code": "134", "libelle": "Supermarché"},
    {"code": "135", "libelle": "Faux- Bijoux"},
    {"code": "136", "libelle": "بيع النظارات"},
    {"code": "137", "libelle": "Electrique"},
    {"code": "138", "libelle": "TOURNEUR"},
    {"code": "139", "libelle": "بيع الحديد"},
    {"code": "140", "libelle": "قاعة عرض حدادة"},
    {"code": "141", "libelle": "صنع الفورية"},
    {"code": "142", "libelle": "خياطة"},
    {"code": "143", "libelle": "قاعة أفراح"},
    {"code": "144", "libelle": "بيع آلات الخياطة"},
    {"code": "145", "libelle": "مغازة"},
    {"code": "146", "libelle": "مطبعة وراقة"},
    {"code": "147", "libelle": "بيع الملابس والمحافظ الجلدية"},
    {"code": "148", "libelle": "قاعة عرض"},
    {"code": "149", "libelle": "صنع الكراسي"},
    {"code": "150", "libelle": "قاعة رياضية"},
    {"code": "151", "libelle": "صقل الرخام"},
    {"code": "152", "libelle": "مخبر صور"},
    {"code": "153", "libelle": "مهندس معماري"},
    {"code": "154", "libelle": "اصلاح وبيع البرابول"},
    {"code": "155", "libelle": "مدرسة خاصة"},
    {"code": "156", "libelle": "بيع مواد شبه طبية"},
    {"code": "157", "libelle": "بيع الموالح"},
    {"code": "158", "libelle": "قاعة إعلامية موجهة للطفل"},
    {"code": "159", "libelle": "مركز تبريد"},
    {"code": "177", "libelle": "بيع وتصليح الهاتف الجوال"},
    {"code": "178", "libelle": "بيع وتصليح الآلات الموسيقية"},
    {"code": "179", "libelle": "صناعات تقليدية"},
    {"code": "180", "libelle": "خدمات إعلامية"},
    {"code": "181", "libelle": "مكتب حسابات"},
    {"code": "182", "libelle": "نساج"},
    {"code": "183", "libelle": "مدرسة ابتدائية"},
    {"code": "184", "libelle": "TATOUAGE"},
    {"code": "185", "libelle": "معمل بلاستيك"},
    {"code": "186", "libelle": "دهن الموبيليا"},
    {"code": "187", "libelle": "وكالة عقارية"},
    {"code": "188", "libelle": "مرسم محلف"},
    {"code": "189", "libelle": "كراء السيارات"},
    {"code": "190", "libelle": "بيع الزهور"},
    {"code": "191", "libelle": "حزب سياسي"},
    {"code": "192", "libelle": "علاج طبيعي"},
    {"code": "193", "libelle": "بيع وإصلاح الحاسوب"},
    {"code": "194", "libelle": "مركب ترفيهي"},
    {"code": "195", "libelle": "وكالة إشهار"},
    {"code": "196", "libelle": "مدرسة خاصة"},
    {"code": "197", "libelle": "FRIGO"},
    {"code": "2000", "libelle": "محل شامل"},
    {"code": "2001", "libelle": "مدرسة تجميل"},
    {"code": "2002", "libelle": "خياطة الستائر"},
    {"code": "2003", "libelle": "بيع اللحوم"},
    {"code": "2004", "libelle": "بيع مواد التجميل"},
    {"code": "2005", "libelle": "بيع الطاقة الشمسية"},
    {"code": "2006", "libelle": "مركز الكفاءة للغات والإعلامية"},
    {"code": "2007", "libelle": "بيع مواد كهربائية"},
    {"code": "2008", "libelle": "التضامن الاجتماعي"},
    {"code": "2009", "libelle": "تصبير وتصدير السمك"},
    {"code": "2010", "libelle": "ديوان الحبوب"},
    {"code": "2011", "libelle": "معمل طماطم"},
    {"code": "2012", "libelle": "الدعم في مجال التعليم"},
    {"code": "2013", "libelle": "بيع المثلجات"},
    {"code": "2014", "libelle": "بيع المواد الغذائية والمطعم"},
  ];

  // Fonction pour obtenir le libellé d'une catégorie à partir de son code
  String _getCategoryLabel(String? categoryCode) {
    if (categoryCode == null) return 'Non spécifié';
    
    // Chercher dans la liste des catégories
    for (final category in categoriesArticle) {
      if (category['code'] == categoryCode) {
        return category['libelle'] ?? categoryCode;
      }
    }
    
    // Si le code n'est pas trouvé, retourner un message générique
    return 'Activité $categoryCode';
  }

  IconData _getCategoryIcon(String? artCatArt) {
    if (artCatArt == null) return Icons.business;
    switch (artCatArt.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'café':
      case 'cafe':
        return Icons.local_cafe;
      case 'commerce':
        return Icons.store;
      case 'hotel':
        return Icons.hotel;
      case 'pharmacie':
        return Icons.local_pharmacy;
      case 'banque':
        return Icons.account_balance;
      default:
        return Icons.business;
    }
  }

  void _showEstablishmentDetails(EtablissementModel establishment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(establishment.artNomCommerce ?? 'Établissement ${establishment.artNouvCode}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Code', establishment.artNouvCode),
              _buildDetailRow('Catégorie', _getCategoryLabel(establishment.artCatArt)),
              _buildDetailRow('Statut', _getStatusText(establishment.artEtat)),
              _buildDetailRow('Adresse', establishment.artAdresse ?? 'Non disponible'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
            ElevatedButton(
              onPressed: () {
                print('🔧 Modifying establishment: ${establishment.artNomCommerce}');
                Navigator.of(context).pop();
                // Navigate to edit form with establishment data
                Navigator.pushNamed(
                  context, 
                  AppRoutes.establishmentForm,
                  arguments: establishment,
                );
              },
              child: Text('Modifier'),
            ),
            ElevatedButton(
              onPressed: () => _showDeleteConfirmation(context, establishment),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, EtablissementModel establishment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer l\'établissement "${establishment.artNomCommerce ?? establishment.artNouvCode}" ?\n\nCette action est irréversible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close confirmation dialog
                Navigator.of(context).pop(); // Close details dialog
                await _deleteEstablishment(establishment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEstablishment(EtablissementModel establishment) async {
    try {
      final provider = Provider.of<EstablishmentProvider>(context, listen: false);
      final success = await provider.deleteEtablissement(establishment.artNouvCode);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Établissement supprimé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression de l\'établissement'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
