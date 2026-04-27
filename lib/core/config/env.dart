import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get supabaseUrl =>
      dotenv.maybeGet('SUPABASE_URL') ?? const String.fromEnvironment('SUPABASE_URL');

  static String get supabaseAnonKey =>
      dotenv.maybeGet('SUPABASE_ANON_KEY') ??
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static String get islamicApiKey =>
      dotenv.maybeGet('ISLAMIC_API_KEY') ??
      const String.fromEnvironment('ISLAMIC_API_KEY');

  static bool get hasIslamicApi => islamicApiKey.isNotEmpty;
}
