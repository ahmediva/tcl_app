import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _useUsername = false; // Toggle between email and username login

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        bool success = false;
        
        if (_useUsername) {
          // Login with username
          print('Attempting login with username: ${_emailController.text.trim()}');
          success = await authProvider.loginWithUsername(
            _emailController.text.trim(),
            _passwordController.text,
          );
        } else {
          // Login with email
          print('Attempting login with email: ${_emailController.text.trim()}');
          success = await authProvider.login(
            _emailController.text.trim(),
            _passwordController.text,
          );
        }
        
        if (success) {
          print('Login successful!');
          // Navigate to appropriate dashboard based on user role
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.establishmentForm,
          );
        } else {
          print('Login failed');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please check your credentials.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Login error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleLoginMethod() {
    setState(() {
      _useUsername = !_useUsername;
      _emailController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TCL Login'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Title
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance,
                      size: 64,
                      color: Colors.blue[800],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'TCL Mobile App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    Text(
                      'Taxe sur les établissements',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Login Method Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login with: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _useUsername,
                    onChanged: (value) => _toggleLoginMethod(),
                  ),
                  Text(
                    _useUsername ? 'Username' : 'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Login Form
              CustomTextField(
                controller: _emailController,
                labelText: _useUsername ? 'Username' : 'Email',
                keyboardType: _useUsername 
                    ? TextInputType.text 
                    : TextInputType.emailAddress,
                validator: _useUsername 
                    ? Validators.validateUsername 
                    : Validators.validateEmail,
                prefixIcon: Icon(
                  _useUsername ? Icons.person : Icons.email,
                  color: Colors.blue[600] ?? Colors.blue,
                ),
              ),
              
              SizedBox(height: 16),
              
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: Validators.validatePassword,

              ),
              
              SizedBox(height: 24),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: _isLoading ? 'Logging in...' : 'Login',
                  onPressed: _isLoading ? null : _login,
                ),
              ),
              
              SizedBox(height: 24),
              
              // Additional Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue[600] ?? Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Register Account',
                      style: TextStyle(color: Colors.blue[600] ?? Colors.blue),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Debug Info (remove in production)
              if (true) // Set to false in production
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100] ?? Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300] ?? Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debug Info:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700] ?? Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Login Method: ${_useUsername ? "Username" : "Email"}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600] ?? Colors.grey),
                      ),
                      Text(
                        'Database: ${_useUsername ? "users.username" : "users.email"}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600] ?? Colors.grey),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}