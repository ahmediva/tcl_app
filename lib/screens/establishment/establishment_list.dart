import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class EstablishmentList extends StatefulWidget {
  const EstablishmentList({Key? key}) : super(key: key);

  @override
  _EstablishmentListState createState() => _EstablishmentListState();
}

class _EstablishmentListState extends State<EstablishmentList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample data - in real app, this would come from database
  final List<Map<String, dynamic>> _establishments = [
    {
      'id': '1',
      'name': 'Restaurant Le Tunisien',
      'address': 'Avenue Habib Bourguiba, Tunis',
      'category': 'Restaurant',
      'status': 'Actif',
      'latitude': 36.8065,
      'longitude': 10.1815,
    },
    {
      'id': '2',
      'name': 'Café Central',
      'address': 'Place de la République, Tunis',
      'category': 'Café',
      'status': 'Actif',
      'latitude': 36.8000,
      'longitude': 10.1800,
    },
    {
      'id': '3',
      'name': 'Boutique Mode',
      'address': 'Rue de la Liberté, Tunis',
      'category': 'Commerce',
      'status': 'Inactif',
      'latitude': 36.8100,
      'longitude': 10.1900,
    },
  ];

  List<Map<String, dynamic>> get _filteredEstablishments {
    if (_searchQuery.isEmpty) {
      return _establishments;
    }
    return _establishments.where((establishment) {
      return establishment['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             establishment['address'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             establishment['category'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
            child: _filteredEstablishments.isEmpty
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

  Widget _buildEstablishmentCard(Map<String, dynamic> establishment) {
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
                      color: _getStatusColor(establishment['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(establishment['category']),
                      color: _getStatusColor(establishment['status']),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          establishment['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          establishment['address'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(establishment['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      establishment['status'],
                      style: TextStyle(
                        color: _getStatusColor(establishment['status']),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    establishment['category'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    '${establishment['latitude'].toStringAsFixed(4)}, ${establishment['longitude'].toStringAsFixed(4)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'actif':
        return Colors.green;
      case 'inactif':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'café':
        return Icons.local_cafe;
      case 'commerce':
        return Icons.store;
      default:
        return Icons.business;
    }
  }

  void _showEstablishmentDetails(Map<String, dynamic> establishment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(establishment['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Adresse', establishment['address']),
              _buildDetailRow('Catégorie', establishment['category']),
              _buildDetailRow('Statut', establishment['status']),
              _buildDetailRow('Latitude', establishment['latitude'].toString()),
              _buildDetailRow('Longitude', establishment['longitude'].toString()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to edit form
                Navigator.pushNamed(context, AppRoutes.establishmentForm);
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
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
