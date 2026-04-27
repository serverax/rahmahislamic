import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/env.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/remote/supabase_client.dart';
import 'firebase_options.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Env.load();
  } catch (e) {
    if (kDebugMode) debugPrint('No .env file loaded: $e');
  }

  try {
    await SupabaseBootstrap.init();
  } catch (e) {
    if (kDebugMode) debugPrint('Supabase init skipped: $e');
  }

  // Firebase: best-effort. Throws on Windows/Linux desktop where the
  // project isn't configured; Android/iOS are wired via firebase_options.
  // Wrapped in try/catch so the app still boots on dev platforms without
  // a Firebase-supported runtime.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) debugPrint('Firebase init skipped: $e');
  }

  runApp(const ProviderScope(child: RahmaApp()));
}

class RahmaApp extends ConsumerWidget {
  const RahmaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(languageControllerProvider);

    return MaterialApp(
      title: 'Rahma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkGreenTheme(state.isArabic),
      locale: state.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      home: const SplashScreen(),
    );
  }
}
