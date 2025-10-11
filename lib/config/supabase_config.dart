import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Update these values with your actual Supabase project credentials
  // TODO: Replace with your correct project credentials from https://supabase.com/dashboard/project/ohtqdcudyzupndgxyyhn/settings/api
  static const String supabaseUrl = 'https://ohtqdcudyzupndgxyyhn.supabase.co'; // Replace with your actual URL
  static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9odHFkY3VkeXp1cG5kZ3h5eWhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU5NjU5OTcsImV4cCI6MjA3MTU0MTk5N30.CBB130f4vbFiiL6c8_4q-1V_gcX7gshWQULMkhuq4YM'; // Replace with your actual anon key
  
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
