import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/supabase_config.dart';
import 'routes/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/establishment_provider.dart';
import 'providers/citizen_provider.dart';
import 'widgets/auth/auth_wrapper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const TCLApp());
}

class TCLApp extends StatelessWidget {
  const TCLApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => EstablishmentProvider()),
        ChangeNotifierProvider(create: (context) => CitizenProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'TCL Mobile App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.blue[800],
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: AuthWrapper(
              child: authProvider.isAuthenticated 
                ? const MainMenu() 
                : const LoginScreen(),
            ),
            onGenerateRoute: AppRoutes.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}