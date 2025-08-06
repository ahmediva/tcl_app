import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/dashboard/admin_dashboard.dart';
import '../screens/dashboard/agent_dashboard.dart';
import '../screens/establishment/establishment_form.dart';
import '../screens/establishment/establishment_list.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String adminDashboard = '/admin-dashboard';
  static const String agentDashboard = '/agent-dashboard';
  static const String establishmentForm = '/establishment-form';
  static const String establishmentList = '/establishment-list';

  // Generate route based on route name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => AdminDashboard());
      case agentDashboard:
        return MaterialPageRoute(builder: (_) => AgentDashboard());
      case establishmentForm:
        return MaterialPageRoute(builder: (_) => EstablishmentForm());
      case establishmentList:
        return MaterialPageRoute(builder: (_) => EstablishmentList());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
