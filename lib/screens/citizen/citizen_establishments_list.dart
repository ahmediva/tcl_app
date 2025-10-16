import 'package:flutter/material.dart';
import '../../models/citizen_model.dart';
import '../../models/etablissement_model.dart';

class CitizenEstablishmentsList extends StatefulWidget {
  final TCLCitizen citizen;
  final List<EtablissementModel> establishments;
  
  const CitizenEstablishmentsList({
    Key? key,
    required this.citizen,
    required this.establishments,
  }) : super(key: key);

  @override
  _CitizenEstablishmentsListState createState() => _CitizenEstablishmentsListState();
}

class _CitizenEstablishmentsListState extends State<CitizenEstablishmentsList> {
  String _searchQuery = '';
  List<EtablissementModel> _filteredEstablishments = [];

  @override
  void initState() {
    super.initState();
    _filteredEstablishments = widget.establishments;
  }

  void _filterEstablishments(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredEstablishments = widget.establishments;
      } else {
        _filteredEstablishments = widget.establishments.where((establishment) {
          final name = establishment.artNomCommerce?.toLowerCase() ?? '';
          final address = establishment.artAdresse?.toLowerCase() ?? '';
          final code = establishment.artNouvCode.toLowerCase();
          final searchLower = query.toLowerCase();
          
          return name.contains(searchLower) ||
                 address.contains(searchLower) ||
                 code.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes établissements (${widget.establishments.length})'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterEstablishments,
              decoration: InputDecoration(
                hintText: 'Rechercher un établissement...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredEstablishments.length} établissement(s) trouvé(s)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Establishments List
          Expanded(
            child: _filteredEstablishments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredEstablishments.length,
                    itemBuilder: (context, index) {
                      final establishment = _filteredEstablishments[index];
                      return _buildEstablishmentCard(establishment);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty 
                ? 'Aucun établissement trouvé'
                : 'Aucun résultat pour "$_searchQuery"',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Aucun établissement n\'est enregistré avec votre CIN'
                : 'Essayez avec d\'autres mots-clés',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstablishmentCard(EtablissementModel establishment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showEstablishmentDetails(establishment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          establishment.artNomCommerce ?? 'Établissement ${establishment.artNouvCode}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          establishment.artNouvCode,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(establishment.artEtat).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      establishment.artEtat == 1 ? 'Actif' : 'Inactif',
                      style: TextStyle(
                        color: _getStatusColor(establishment.artEtat),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      establishment.artAdresse ?? 'Adresse non spécifiée',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _getCategoryLabel(establishment.artCatArt),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.green[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Montant TCL: ${establishment.artMntTaxe?.toStringAsFixed(2) ?? '0.00'} DT',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today, size: 16, color: Colors.blue[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Période: ${establishment.artDebPer ?? 'N/A'} - ${establishment.artFinPer ?? 'N/A'}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
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

  void _showEstablishmentDetails(EtablissementModel establishment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(establishment.artNomCommerce ?? 'Détails de l\'établissement'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              _buildDetailRow('Code', establishment.artNouvCode),
              _buildDetailRow('Nom', establishment.artNomCommerce ?? 'Non spécifié'),
              _buildDetailRow('Adresse', establishment.artAdresse ?? 'Non spécifiée'),
              _buildDetailRow('Activité', _getActivityName(establishment.artCatArt)),
                _buildDetailRow('Surface couverte', '${establishment.artSurCouv?.toStringAsFixed(2) ?? '0.00'} m²'),
                _buildDetailRow('Montant TCL', '${establishment.artMntTaxe?.toStringAsFixed(2) ?? '0.00'} DT'),
                _buildDetailRow('Taxe immobilière', '${establishment.artTaxeImmobiliere?.toStringAsFixed(2) ?? '0.00'} DT'),
                _buildDetailRow('Statut', establishment.artEtat == 1 ? 'Actif (Paye taxe)' : 'Inactif (Ne paye pas)'),
                _buildDetailRow('Période', '${establishment.artDebPer ?? 'N/A'} - ${establishment.artFinPer ?? 'N/A'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int? status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 0:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? category) {
    // Simple category icon mapping
    if (category == null) return Icons.business;
    
    // You can expand this based on your category system
    return Icons.store;
  }

  String _getCategoryLabel(String? category) {
    if (category == null) return 'Non spécifiée';
    
    // You can expand this based on your category system
    return 'Catégorie $category';
  }

  String _getActivityName(String? categoryCode) {
    if (categoryCode == null) return 'Non spécifiée';
    
    // Find the activity name from the EtablissementModel options
    final activity = EtablissementModel.artCatActiviteOptions.firstWhere(
      (option) => option['value'] == categoryCode,
      orElse: () => {'value': categoryCode, 'label': 'Activité inconnue'},
    );
    
    return activity['label'] ?? 'Activité inconnue';
  }
}
