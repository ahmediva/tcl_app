import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // These values come from the .env file
  static const String supabaseUrl = 'https://qcarizjplrrplvqskmqo.supabase.co';
  static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjYXJpempwbHJycGx2cXNrbXFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQyNTIzMTUsImV4cCI6MjA2OTgyODMxNX0.F7gN5n7vlO9rRkvCygtwU2oJvaNTVocjJhM71VUpnhg';
  
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
