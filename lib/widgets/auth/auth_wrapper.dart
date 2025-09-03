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
  TCLUser? _user;

  @override
  void initState() {
    super.initState();
    // Listen to authentication state changes
    AuthService().authStateChanges.listen((authState) {
      setState(() {
        if (authState.session?.user != null) {
          // In a real implementation, you would fetch the full user data from your database
          _user = TCLUser(
            id: authState.session!.user!.id,
            userCode: 'TEMP',
            username: authState.session!.user!.email ?? '',
            email: authState.session!.user!.email ?? '',
            passwordHash: '',
            firstName: authState.session!.user!.userMetadata?['name'] ?? '',
            lastName: '',
            agentType: 'CONSULTANT', // Default role, would be fetched from database in real implementation
            agentLevel: 'JUNIOR',
            permissions: UserPermissions(
              canCreateArticles: false,
              canEditArticles: false,
              canDeleteArticles: false,
              canViewReports: true,
              canExportData: false,
              canManageUsers: false,
            ),
            isActive: true,
            isVerified: authState.session!.user!.emailConfirmedAt != null,
            loginAttempts: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
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
