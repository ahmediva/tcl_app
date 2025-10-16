import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TCL Mobile App'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Card
            Card(
              color: Colors.blue[800],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.business, size: 60, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      'Gestion des Établissements',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Système TCL Municipal',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Menu Options
            Expanded(
              child: Column(
                children: [
                  // Add Establishment - Only show if user can create articles
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.canCreateArticles) {
                        return _buildMenuButton(
                          context,
                          icon: Icons.add_business,
                          title: 'Ajouter Établissement',
                          subtitle: 'Créer un nouvel établissement',
                          color: Colors.green,
                          onTap: () => Navigator.pushNamed(context, '/establishment-form'),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // List Establishments
                  _buildMenuButton(
                    context,
                    icon: Icons.list_alt,
                    title: 'Liste des Établissements',
                    subtitle: 'Consulter les établissements existants',
                    color: Colors.blue,
                    onTap: () => Navigator.pushNamed(context, '/establishment-list'),
                  ),
                  const SizedBox(height: 16),

                  // Map Establishments
                  _buildMenuButton(
                    context,
                    icon: Icons.map,
                    title: 'Carte des Établissements',
                    subtitle: 'Voir les établissements sur la carte',
                    color: Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/establishment-map'),
                  ),
                  const SizedBox(height: 16),

                  // Admin Section - Only show for admins
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.canManageUsers) {
                        return Column(
                          children: [
                            const Divider(),
                            const SizedBox(height: 16),
                            _buildMenuButton(
                              context,
                              icon: Icons.admin_panel_settings,
                              title: 'Gestion des Utilisateurs',
                              subtitle: 'Gérer les agents et leurs permissions',
                              color: Colors.red,
                              onTap: () => Navigator.pushNamed(context, '/user-management'),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}