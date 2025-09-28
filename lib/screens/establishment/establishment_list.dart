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
      final name = establishment.artNomCommerce?.toLowerCase() ?? '';
      final address = establishment.artTexteAdresse?.toLowerCase() ?? '';
      final category = establishment.artCatArt?.toLowerCase() ?? '';
      final searchLower = _searchQuery.toLowerCase();
      
      return name.contains(searchLower) ||
             address.contains(searchLower) ||
             category.contains(searchLower);
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
                          establishment.artTexteAdresse ?? 'Adresse non disponible',
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
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    establishment.artCatArt ?? 'Non spécifié',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    establishment.artLatitude != null && establishment.artLongitude != null
                        ? '${establishment.artLatitude!.toStringAsFixed(4)}, ${establishment.artLongitude!.toStringAsFixed(4)}'
                        : 'Coordonnées non disponibles',
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
              _buildDetailRow('Adresse', establishment.artTexteAdresse ?? 'Non disponible'),
              _buildDetailRow('Catégorie', establishment.artCatArt ?? 'Non spécifié'),
              _buildDetailRow('Statut', _getStatusText(establishment.artEtat)),
              _buildDetailRow('Arrondissement', establishment.artArrond),
              _buildDetailRow('Rue', establishment.artRue),
              if (establishment.artLatitude != null && establishment.artLongitude != null)
                _buildDetailRow('Coordonnées', '${establishment.artLatitude!.toStringAsFixed(4)}, ${establishment.artLongitude!.toStringAsFixed(4)}'),
              if (establishment.artMntTaxe != null)
                _buildDetailRow('Montant Taxe', '${establishment.artMntTaxe!.toStringAsFixed(2)} TND'),
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
