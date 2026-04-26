import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';

class SupabaseBootstrap {
  SupabaseBootstrap._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> init() async {
    if (_initialized) return;
    if (!Env.hasSupabase) return;
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      debug: false,
    );
    _initialized = true;
  }

  static SupabaseClient? get clientOrNull =>
      _initialized ? Supabase.instance.client : null;
}
