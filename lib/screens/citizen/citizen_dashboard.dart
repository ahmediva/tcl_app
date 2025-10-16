import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/citizen_model.dart';
import '../../models/etablissement_model.dart';
import '../../services/citizen_service.dart';
import '../../providers/citizen_provider.dart';
import 'citizen_establishments_list.dart';

class CitizenDashboard extends StatefulWidget {
  final TCLCitizen citizen;
  
  const CitizenDashboard({Key? key, required this.citizen}) : super(key: key);

  @override
  _CitizenDashboardState createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  List<EtablissementModel> _establishments = [];
  bool _isLoading = true;
  int _establishmentCount = 0;

  @override
  void initState() {
    super.initState();
    _loadEstablishments();
  }

  Future<void> _loadEstablishments() async {
    setState(() => _isLoading = true);
    
    try {
      final establishments = await CitizenService().getCitizenEstablishments(widget.citizen.cin);
      setState(() {
        _establishments = establishments;
        _establishmentCount = establishments.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord - ${widget.citizen.fullName}'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout from citizen provider
              final citizenProvider = Provider.of<CitizenProvider>(context, listen: false);
              citizenProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadEstablishments,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.blue[800]!, Colors.blue[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    widget.citizen.fullName.split(' ').map((e) => e[0]).join('').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bienvenue,',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        widget.citizen.fullName,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'CIN: ${widget.citizen.cin}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Statistics Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vos établissements',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    'Total',
                                    _establishmentCount.toString(),
                                    Colors.blue,
                                    Icons.business,
                                  ),
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    'Actifs',
                                    _establishments.where((e) => e.artEtat == 1).length.toString(),
                                    Colors.green,
                                    Icons.check_circle,
                                  ),
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    'Inactifs',
                                    _establishments.where((e) => e.artEtat == 0).length.toString(),
                                    Colors.orange,
                                    Icons.pause_circle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Establishments Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vos établissements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Row(
                          children: [
                            // Map button
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/citizen-map',
                                  arguments: {
                                    'citizen': widget.citizen,
                                    'establishments': _establishments,
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.map,
                                color: Colors.blue[600],
                              ),
                              tooltip: 'Voir sur la carte',
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CitizenEstablishmentsList(
                                      citizen: widget.citizen,
                                      establishments: _establishments,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Voir tout',
                                style: TextStyle(color: Colors.blue[600]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Establishments List
                    if (_establishments.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.business_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun établissement trouvé',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Aucun établissement n\'est enregistré avec votre CIN',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._establishments.take(3).map((establishment) => 
                        _buildEstablishmentCard(establishment)
                      ).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEstablishmentCard(EtablissementModel establishment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: establishment.artEtat == 1 ? Colors.green[100] : Colors.orange[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            establishment.artEtat == 1 ? Icons.check_circle : Icons.pause_circle,
            color: establishment.artEtat == 1 ? Colors.green[600] : Colors.orange[600],
            size: 24,
          ),
        ),
        title: Text(
          establishment.artNomCommerce ?? 'Établissement ${establishment.artNouvCode}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(establishment.artAdresse ?? 'Adresse non spécifiée'),
            const SizedBox(height: 4),
            Text(
              'Montant TCL: ${establishment.artMntTaxe?.toStringAsFixed(2) ?? '0.00'} DT',
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: establishment.artEtat == 1 ? Colors.green[100] : Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            establishment.artEtat == 1 ? 'Actif' : 'Inactif',
            style: TextStyle(
              color: establishment.artEtat == 1 ? Colors.green[700] : Colors.orange[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: () {
          // TODO: Show establishment details
        },
      ),
    );
  }
}
