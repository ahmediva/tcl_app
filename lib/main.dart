import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/supabase_config.dart';
import 'routes/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/arrondissement_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ArrondissementProvider()),
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
            initialRoute: AppRoutes.login,
            onGenerateRoute: AppRoutes.generateRoute,
            home: FutureBuilder(
              future: authProvider.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Initializing TCL App...'),
                        ],
                      ),
                    ),
                  );
                }
                
                // Check if user is authenticated
                if (authProvider.isAuthenticated) {
                  // Navigate to appropriate dashboard based on user role
                  if (authProvider.isAdmin) {
                    return Navigator(
                      onGenerateRoute: AppRoutes.generateRoute,
                      initialRoute: AppRoutes.adminDashboard,
                    );
                  } else {
                    return Navigator(
                      onGenerateRoute: AppRoutes.generateRoute,
                      initialRoute: AppRoutes.agentDashboard,
                    );
                  }
                } else {
                  // Show login screen
                  return Navigator(
                    onGenerateRoute: AppRoutes.generateRoute,
                    initialRoute: AppRoutes.login,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
