import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home/main_menu.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/dashboard/admin_dashboard.dart';
import '../screens/dashboard/agent_dashboard.dart';
import '../screens/establishment/establishment_form_new.dart';
import '../screens/establishment/establishment_list.dart';
import '../screens/establishment/establishment_map.dart';
import '../providers/auth_provider.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String adminDashboard = '/admin-dashboard';
  static const String agentDashboard = '/agent-dashboard';
  static const String establishmentForm = '/establishment-form';
  static const String establishmentList = '/establishment-list';
  static const String establishmentMap = '/establishment-map';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isAuthenticated 
                ? const MainMenu() 
                : const LoginScreen();
            },
          ),
        );
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isAuthenticated 
                ? AdminDashboard() 
                : LoginScreen();
            },
          ),
        );
      
      case agentDashboard:
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isAuthenticated 
                ? AgentDashboard() 
                : const LoginScreen();
            },
          ),
        );
      
      case establishmentForm:
        return MaterialPageRoute(
          settings: settings, // Pass the settings with arguments
          builder: (_) => Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isAuthenticated 
                ? EstablishmentFormNew() 
                : const LoginScreen();
            },
          ),
        );
      
      case establishmentList:
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isAuthenticated 
                ? EstablishmentList() 
                : const LoginScreen();
            },
          ),
        );
      
      case establishmentMap:
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isAuthenticated 
                ? EstablishmentMapScreen() 
                : const LoginScreen();
            },
          ),
        );
      
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}