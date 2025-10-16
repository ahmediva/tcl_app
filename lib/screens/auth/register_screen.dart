import 'package:flutter/material.dart';
import '../../services/citizen_service.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _hasEstablishments = false;

  @override
  void dispose() {
    _cinController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkEstablishments() async {
    if (_cinController.text.length == 8) {
      final hasEstablishments = await CitizenService().hasEstablishments(_cinController.text);
      setState(() {
        _hasEstablishments = hasEstablishments;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final citizen = await CitizenService().registerCitizen(
          cin: _cinController.text.trim(),
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          numeroTelephone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        );
        
        if (citizen != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inscription réussie ! Vous pouvez maintenant consulter vos établissements.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de l\'inscription. Veuillez réessayer.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Une erreur est survenue: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 64,
                        color: Colors.blue[800],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Inscription Citoyen',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Consultez vos établissements',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // CIN Field
                CustomTextField(
                  controller: _cinController,
                  labelText: 'CIN *',
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  onChanged: (value) => _checkEstablishments(),
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
                
                // Establishment check result
                if (_cinController.text.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _hasEstablishments ? Colors.green[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _hasEstablishments ? Colors.green[200]! : Colors.orange[200]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _hasEstablishments ? Icons.check_circle : Icons.info,
                          color: _hasEstablishments ? Colors.green[600] : Colors.orange[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _hasEstablishments 
                                ? 'Établissements trouvés pour ce CIN'
                                : 'Aucun établissement trouvé pour ce CIN',
                            style: TextStyle(
                              fontSize: 14,
                              color: _hasEstablishments ? Colors.green[700] : Colors.orange[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Name Fields
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _prenomController,
                        labelText: 'Prénom *',
                        validator: Validators.validateName,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _nomController,
                        labelText: 'Nom *',
                        validator: Validators.validateName,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email *',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                
                const SizedBox(height: 16),
                
                // Phone Field
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Téléphone',
                  keyboardType: TextInputType.phone,
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
                
                const SizedBox(height: 16),
                
                // Password Fields
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Mot de passe *',
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                
                const SizedBox(height: 16),
                
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirmer le mot de passe *',
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Register Button
                CustomButton(
                  text: _isLoading ? 'Inscription...' : 'S\'inscrire',
                  onPressed: _isLoading ? null : _register,
                ),
                
                const SizedBox(height: 16),
                
                // Login Link
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    'Déjà un compte ? Se connecter',
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
