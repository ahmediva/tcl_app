import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class AddEditUserScreen extends StatefulWidget {
  final TCLUser? user; // null for add, user object for edit

  const AddEditUserScreen({Key? key, this.user}) : super(key: key);

  @override
  _AddEditUserScreenState createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedAgentType = 'collecteur';
  String _selectedAgentLevel = 'JUNIOR';
  
  // Permissions
  bool _canCreateArticles = false;
  bool _canEditArticles = false;
  bool _canDeleteArticles = false;
  bool _canManageUsers = false;

  bool _isLoading = false;
  bool _isEditMode = false;

  // Agent types and levels
  final List<Map<String, String>> _agentTypes = [
    {'value': 'admin', 'label': 'Administrateur'},
    {'value': 'superviseur', 'label': 'Superviseur'},
    {'value': 'controle', 'label': 'Agent de Contrôle'},
    {'value': 'collecteur', 'label': 'Collecteur'},
  ];

  final List<Map<String, String>> _agentLevels = [
    {'value': 'JUNIOR', 'label': 'Junior'},
    {'value': 'SENIOR', 'label': 'Senior'},
    {'value': 'EXPERT', 'label': 'Expert'},
  ];


  @override
  void initState() {
    super.initState();
    _isEditMode = widget.user != null;
    if (_isEditMode) {
      _initializeWithUserData();
    }
  }

  void _initializeWithUserData() {
    final user = widget.user!;
    _userCodeController.text = user.userCode;
    _emailController.text = user.email;
    _firstNameController.text = user.prenom;
    _lastNameController.text = user.nom;
    _phoneController.text = user.numeroTelephone ?? '';
    
    _selectedAgentType = user.agentType;
    _selectedAgentLevel = 'JUNIOR';
    
    // Set permissions
    _canCreateArticles = user.canCreateArticles;
    _canEditArticles = user.canEditArticles;
    _canDeleteArticles = user.canDeleteArticles;
    _canManageUsers = user.canManageUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Modifier Utilisateur' : 'Nouvel Utilisateur'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          if (_isEditMode)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _isLoading ? null : _saveUser,
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Informations Personnelles'),
                    _buildPersonalInfoSection(),
                    
                    
                    
                    SizedBox(height: 24),
                    _buildSectionHeader('Permissions'),
                    _buildPermissionsSection(),
                    
                    SizedBox(height: 32),
                    if (!_isEditMode) _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        TextFormField(
          controller: _userCodeController,
          decoration: InputDecoration(
            labelText: 'CIN *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge),
            helperText: '8 chiffres exactement',
          ),
          keyboardType: TextInputType.number,
          maxLength: 8,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le CIN est requis';
            }
            if (value.length != 8) {
              return 'Le CIN doit contenir exactement 8 chiffres';
            }
            if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
              return 'Le CIN ne doit contenir que des chiffres';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'L\'email est requis';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Format d\'email invalide';
            }
            return null;
          },
        ),
        if (!_isEditMode) ...[
          SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Mot de passe *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le mot de passe est requis';
              }
              if (value.length < 6) {
                return 'Le mot de passe doit contenir au moins 6 caractères';
              }
              return null;
            },
          ),
        ],
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Prénom *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le prénom est requis';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Nom *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  helperText: '8 chiffres exactement',
                ),
                keyboardType: TextInputType.number,
                maxLength: 8,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length != 8) {
                      return 'Le téléphone doit contenir exactement 8 chiffres';
                    }
                    if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
                      return 'Le téléphone ne doit contenir que des chiffres';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedAgentType,
                decoration: InputDecoration(
                  labelText: 'Type d\'Agent *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                items: _agentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type['value'],
                    child: Text(type['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAgentType = value!;
                    _updateDefaultPermissions();
                  });
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedAgentLevel,
                decoration: InputDecoration(
                  labelText: 'Niveau *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                items: _agentLevels.map((level) {
                  return DropdownMenuItem(
                    value: level['value'],
                    child: Text(level['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAgentLevel = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildPermissionsSection() {
    return Column(
      children: [
        _buildPermissionCheckbox(
          'Créer des articles',
          _canCreateArticles,
          (value) {
            setState(() => _canCreateArticles = value);
            _updateRoleFromPermissions();
          },
        ),
        _buildPermissionCheckbox(
          'Modifier des articles',
          _canEditArticles,
          (value) {
            setState(() => _canEditArticles = value);
            _updateRoleFromPermissions();
          },
        ),
        _buildPermissionCheckbox(
          'Supprimer des articles',
          _canDeleteArticles,
          (value) {
            setState(() => _canDeleteArticles = value);
            _updateRoleFromPermissions();
          },
        ),
        _buildPermissionCheckbox(
          'Gérer les utilisateurs',
          _canManageUsers,
          (value) {
            setState(() => _canManageUsers = value);
            _updateRoleFromPermissions();
          },
        ),
        SizedBox(height: 16),
        
        // Indicateur du rôle déterminé automatiquement
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getRoleColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getRoleColor().withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                _getRoleIcon(),
                color: _getRoleColor(),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Rôle déterminé : ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _getRoleLabel(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getRoleColor(),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _setDefaultPermissions,
                child: Text('Permissions par défaut'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.blue[800],
                ),
              ),
            ),
            SizedBox(width: 16),
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
    );
  }

  Widget _buildPermissionCheckbox(String title, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: (bool? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                _isEditMode ? 'Mettre à jour' : 'Créer l\'utilisateur',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  void _updateDefaultPermissions() {
    setState(() {
      switch (_selectedAgentType) {
        case 'admin':
          _canCreateArticles = true;
          _canEditArticles = true;
          _canDeleteArticles = true;
          _canManageUsers = true;
          break;
        case 'superviseur':
          _canCreateArticles = true;
          _canEditArticles = true;
          _canDeleteArticles = true;
          _canManageUsers = false;
          break;
        case 'controle':
          _canCreateArticles = true;
          _canEditArticles = true;
          _canDeleteArticles = false;
          _canManageUsers = false;
          break;
        case 'collecteur':
          _canCreateArticles = true;
          _canEditArticles = false;
          _canDeleteArticles = false;
          _canManageUsers = false;
          break;
      }
    });
  }

  // Logique intelligente : déterminer le rôle automatiquement selon les permissions
  void _updateRoleFromPermissions() {
    setState(() {
      if (_canManageUsers) {
        // Si peut gérer les utilisateurs = Admin
        _selectedAgentType = 'admin';
      } else if (_canDeleteArticles) {
        // Si peut supprimer = Superviseur
        _selectedAgentType = 'superviseur';
      } else if (_canEditArticles) {
        // Si peut modifier = Agent de contrôle
        _selectedAgentType = 'controle';
      } else if (_canCreateArticles) {
        // Si peut seulement créer = Collecteur
        _selectedAgentType = 'collecteur';
      } else {
        // Par défaut = Collecteur
        _selectedAgentType = 'collecteur';
        _canCreateArticles = true;
      }
    });
  }

  void _setDefaultPermissions() {
    _updateDefaultPermissions();
  }

  // Méthodes helper pour l'indicateur visuel
  String _getRoleLabel() {
    switch (_selectedAgentType) {
      case 'admin':
        return 'Administrateur';
      case 'superviseur':
        return 'Superviseur';
      case 'controle':
        return 'Agent de Contrôle';
      case 'collecteur':
        return 'Collecteur';
      default:
        return 'Collecteur';
    }
  }

  Color _getRoleColor() {
    switch (_selectedAgentType) {
      case 'admin':
        return Colors.red;
      case 'superviseur':
        return Colors.orange;
      case 'controle':
        return Colors.blue;
      case 'collecteur':
        return Colors.green;
      default:
        return Colors.green;
    }
  }

  IconData _getRoleIcon() {
    switch (_selectedAgentType) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'superviseur':
        return Icons.supervisor_account;
      case 'controle':
        return Icons.verified_user;
      case 'collecteur':
        return Icons.person;
      default:
        return Icons.person;
    }
  }

  void _clearAllPermissions() {
    setState(() {
      _canCreateArticles = false;
      _canEditArticles = false;
      _canDeleteArticles = false;
      _canManageUsers = false;
    });
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (_isEditMode) {
        // Update existing user
        final success = await AuthService().updateUser(
          widget.user!.id,
          userCode: _userCodeController.text,
          username: _userCodeController.text, // Use userCode as username
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          agentType: _selectedAgentType,
          agentLevel: _selectedAgentLevel,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          permissions: {
            'can_create_articles': _canCreateArticles,
            'can_edit_articles': _canEditArticles,
            'can_delete_articles': _canDeleteArticles,
            'can_manage_users': _canManageUsers,
          },
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Utilisateur mis à jour avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        } else {
          throw Exception('Échec de la mise à jour');
        }
      } else {
        // Create new user
        final success = await authProvider.registerUser(
          userCode: _userCodeController.text,
          username: _userCodeController.text, // Use userCode as username
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          agentType: _selectedAgentType,
          agentLevel: _selectedAgentLevel,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          customPermissions: {
            'can_create_articles': _canCreateArticles,
            'can_edit_articles': _canEditArticles,
            'can_delete_articles': _canDeleteArticles,
            'can_manage_users': _canManageUsers,
          },
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Utilisateur créé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        } else {
          throw Exception('Échec de la création');
        }
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
