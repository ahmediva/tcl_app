import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;

  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    // Listen to authentication state changes
    AuthService().authStateChanges.listen((authState) {
      setState(() {
        if (authState.session?.user != null) {
          // In a real implementation, you would fetch the full user data from your database
          _user = UserModel(
            id: authState.session!.user!.id,
            email: authState.session!.user!.email ?? '',
            name: authState.session!.user!.userMetadata?['name'] ?? '',
            role: 'agent', // Default role, would be fetched from database in real implementation
          );
        } else {
          _user = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // If user is null, show login screen
    // Otherwise, show the child widget (main app)
    return _user == null ? widget.child : Container(); // Placeholder for actual navigation logic
  }
}
