import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'add_edit_user_screen.dart';
import 'permissions_dialog.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<TCLUser> _allUsers = [];
  List<TCLUser> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await AuthService().getAllUsers();
      setState(() {
        _allUsers = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des utilisateurs: $e')),
      );
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers.where((user) {
          final fullName = user.fullName.toLowerCase();
          final email = user.email.toLowerCase();
          final userCode = user.userCode.toLowerCase();
          final agentType = user.agentType.toLowerCase();
          final searchLower = query.toLowerCase();
          
          return fullName.contains(searchLower) ||
                 email.contains(searchLower) ||
                 userCode.contains(searchLower) ||
                 agentType.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Utilisateurs'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un utilisateur',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterUsers('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterUsers,
            ),
          ),
          
          // User statistics
          _buildUserStats(),
          
          // Users list
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Aucun utilisateur trouvé'
                                  : 'Aucun résultat pour "$_searchQuery"',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return _buildUserCard(user);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildUserStats() {
    final totalUsers = _allUsers.length;
    final activeUsers = _allUsers.where((u) => u.isActive).length;
    final adminUsers = _allUsers.where((u) => u.isAdmin).length;
    final supervisorUsers = _allUsers.where((u) => u.isSupervisor).length;
    final controlAgents = _allUsers.where((u) => u.isControlAgent).length;
    final collectors = _allUsers.where((u) => u.isCollector).length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques des Utilisateurs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Total', totalUsers.toString(), Colors.blue),
              ),
              Expanded(
                child: _buildStatItem('Actifs', activeUsers.toString(), Colors.green),
              ),
              Expanded(
                child: _buildStatItem('Admins', adminUsers.toString(), Colors.red),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Contrôle', controlAgents.toString(), Colors.orange),
              ),
              Expanded(
                child: _buildStatItem('Collecteurs', collectors.toString(), Colors.purple),
              ),
              Expanded(
                child: _buildStatItem('Superviseurs', supervisorUsers.toString(), Colors.teal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
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

  Widget _buildUserCard(TCLUser user) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getUserTypeColor(user.agentType),
          child: Text(
            user.prenom[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${user.email} • ${user.userCode}'),
            Text(
              _getUserTypeLabel(user.agentType),
              style: TextStyle(
                color: _getUserTypeColor(user.agentType),
                fontWeight: FontWeight.w500,
              ),
            ),
            // Zone d'assignation (optionnel)
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusChip(user.isActive),
            SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) => _handleUserAction(value, user),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Modifier'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'permissions',
                  child: Row(
                    children: [
                      Icon(Icons.security, size: 18),
                      SizedBox(width: 8),
                      Text('Permissions'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: user.isActive ? 'deactivate' : 'activate',
                  child: Row(
                    children: [
                      Icon(
                        user.isActive ? Icons.block : Icons.check_circle,
                        size: 18,
                        color: user.isActive ? Colors.red : Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text(user.isActive ? 'Désactiver' : 'Activer'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showUserDetails(user),
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Text(
        isActive ? 'Actif' : 'Inactif',
        style: TextStyle(
          fontSize: 12,
          color: isActive ? Colors.green[800] : Colors.red[800],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getUserTypeColor(String agentType) {
    switch (agentType) {
      case 'ADMIN':
        return Colors.red;
      case 'SUPERVISOR':
        return Colors.orange;
      case 'CONTROL_AGENT':
        return Colors.blue;
      case 'COLLECTOR':
        return Colors.purple;
      case 'CONSULTANT':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getUserTypeLabel(String agentType) {
    switch (agentType) {
      case 'ADMIN':
        return 'Administrateur';
      case 'SUPERVISOR':
        return 'Superviseur';
      case 'CONTROL_AGENT':
        return 'Agent de Contrôle';
      case 'COLLECTOR':
        return 'Collecteur';
      case 'CONSULTANT':
        return 'Consultant';
      default:
        return agentType;
    }
  }

  void _handleUserAction(String action, TCLUser user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'permissions':
        _showPermissionsDialog(user);
        break;
      case 'activate':
      case 'deactivate':
        _toggleUserStatus(user);
        break;
      case 'delete':
        _showDeleteConfirmation(user);
        break;
    }
  }

  void _showUserDetails(TCLUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails de l\'utilisateur'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Nom complet', user.fullName),
              _buildDetailRow('Email', user.email),
              _buildDetailRow('CIN', user.userCode),
              _buildDetailRow('Type d\'agent', _getUserTypeLabel(user.agentType)),
              if (user.numeroTelephone != null) _buildDetailRow('Téléphone', user.numeroTelephone!),
              _buildDetailRow('Statut', user.isActive ? 'Actif' : 'Inactif'),
              SizedBox(height: 16),
              Text(
                'Permissions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildPermissionRow('Créer articles', user.canCreateArticles),
              _buildPermissionRow('Modifier articles', user.canEditArticles),
              _buildPermissionRow('Supprimer articles', user.canDeleteArticles),
              _buildPermissionRow('Gérer utilisateurs', user.canManageUsers),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditUserDialog(user);
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String permission, bool hasPermission) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            hasPermission ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: hasPermission ? Colors.green : Colors.red,
          ),
          SizedBox(width: 8),
          Text(permission),
        ],
      ),
    );
  }

  void _showAddUserDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditUserScreen(),
      ),
    );
    
    if (result == true) {
      await _loadUsers();
    }
  }

  void _showEditUserDialog(TCLUser user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditUserScreen(user: user),
      ),
    );
    
    if (result == true) {
      await _loadUsers();
    }
  }

  void _showPermissionsDialog(TCLUser user) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => PermissionsDialog(user: user),
    );
    
    if (result == true) {
      await _loadUsers();
    }
  }

  Future<void> _toggleUserStatus(TCLUser user) async {
    try {
      final success = await AuthService().toggleUserStatus(user.id, !user.isActive);
      if (success) {
        await _loadUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              user.isActive 
                  ? 'Utilisateur désactivé avec succès'
                  : 'Utilisateur activé avec succès'
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Échec de la mise à jour du statut');
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

  void _showDeleteConfirmation(TCLUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer l\'utilisateur "${user.fullName}" ?\n\n'
          'Cette action est irréversible.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteUser(user);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(TCLUser user) async {
    try {
      final success = await AuthService().deleteUser(user.id);
      if (success) {
        await _loadUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Utilisateur supprimé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Échec de la suppression');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
