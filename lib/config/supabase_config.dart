import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Update these values with your actual Supabase project credentials
  static const String supabaseUrl = 'https://xaxeysxgnewojfoakglt.supabase.co';
  static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhheGV5c3hnbmV3b2pmb2FrZ2x0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY0ODM4ODAsImV4cCI6MjA3MjA1OTg4MH0.xB6XIbD50QL20Wv3nqBDvqC2QPiP58Fzs-X4-puaiWY';
  
  static Supabase? _instance;
  
  static Future<void> initialize() async {
    _instance ??= await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }
  
  static Supabase get instance {
    if (_instance == null) {
      throw Exception('Supabase has not been initialized yet.');
    }
    return _instance!;
  }
  
  static SupabaseClient get client {
    return instance.client;
  }
}
