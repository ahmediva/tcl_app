import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class PermissionsDialog extends StatefulWidget {
  final TCLUser user;

  const PermissionsDialog({Key? key, required this.user}) : super(key: key);

  @override
  _PermissionsDialogState createState() => _PermissionsDialogState();
}

class _PermissionsDialogState extends State<PermissionsDialog> {
  late bool _canCreateArticles;
  late bool _canEditArticles;
  late bool _canDeleteArticles;
  late bool _canManageUsers;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _canCreateArticles = widget.user.canCreateArticles;
    _canEditArticles = widget.user.canEditArticles;
    _canDeleteArticles = widget.user.canDeleteArticles;
    _canManageUsers = widget.user.canManageUsers;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.security, color: Colors.blue[800]),
          SizedBox(width: 8),
          Text('Permissions de ${widget.user.fullName}'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gérez les permissions de cet utilisateur :',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            
            _buildPermissionSection('Gestion des Articles', [
              _buildPermissionCheckbox(
                'Créer des articles',
                _canCreateArticles,
                (value) => setState(() => _canCreateArticles = value),
                Icons.add_circle_outline,
              ),
              _buildPermissionCheckbox(
                'Modifier des articles',
                _canEditArticles,
                (value) => setState(() => _canEditArticles = value),
                Icons.edit_outlined,
              ),
              _buildPermissionCheckbox(
                'Supprimer des articles',
                _canDeleteArticles,
                (value) => setState(() => _canDeleteArticles = value),
                Icons.delete_outline,
              ),
            ]),
            
            SizedBox(height: 16),
            
            
            SizedBox(height: 16),
            
            _buildPermissionSection('Administration', [
              _buildPermissionCheckbox(
                'Gérer les utilisateurs',
                _canManageUsers,
                (value) => setState(() => _canManageUsers = value),
                Icons.admin_panel_settings_outlined,
              ),
            ]),
            
            SizedBox(height: 16),
            
            // Quick action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _setDefaultPermissions,
                    child: Text('Par défaut'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.blue[800],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearAllPermissions,
                    child: Text('Tout désactiver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.red[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _savePermissions,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text('Sauvegarder'),
        ),
      ],
    );
  }

  Widget _buildPermissionSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildPermissionCheckbox(
    String title,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue[800],
          ),
        ],
      ),
    );
  }

  void _setDefaultPermissions() {
    setState(() {
      switch (widget.user.agentType) {
        case 'ADMIN':
          _canCreateArticles = true;
          _canEditArticles = true;
          _canDeleteArticles = true;
          _canManageUsers = true;
          break;
        case 'SUPERVISOR':
          _canCreateArticles = true;
          _canEditArticles = true;
          _canDeleteArticles = true;
          _canManageUsers = false;
          break;
        case 'CONTROL_AGENT':
          _canCreateArticles = true;
          _canEditArticles = true;
          _canDeleteArticles = false;
          _canManageUsers = false;
          break;
        case 'COLLECTOR':
          _canCreateArticles = true;
          _canEditArticles = false;
          _canDeleteArticles = false;
          _canManageUsers = false;
          break;
        case 'CONSULTANT':
          _canCreateArticles = false;
          _canEditArticles = false;
          _canDeleteArticles = false;
          _canManageUsers = false;
          break;
      }
    });
  }

  void _clearAllPermissions() {
    setState(() {
      _canCreateArticles = false;
      _canEditArticles = false;
      _canDeleteArticles = false;
      _canManageUsers = false;
    });
  }

  Future<void> _savePermissions() async {
    setState(() => _isLoading = true);

    try {
      final permissions = {
        'can_create_articles': _canCreateArticles,
        'can_edit_articles': _canEditArticles,
        'can_delete_articles': _canDeleteArticles,
        'can_manage_users': _canManageUsers,
      };

      final success = await AuthService().updateUserPermissions(
        widget.user.id,
        permissions,
      );

      if (success) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permissions mises à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Échec de la mise à jour des permissions');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
