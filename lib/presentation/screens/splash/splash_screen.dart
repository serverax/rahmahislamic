import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/language_provider.dart';
import '../auth/language_selection_screen.dart';
import '../auth/onboarding_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await ref.read(languageControllerProvider.notifier).load();
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final state = ref.read(languageControllerProvider);
    final next = !state.hasSelectedLanguage
        ? const LanguageSelectionScreen()
        : !state.onboardingDone
            ? const OnboardingScreen()
            : const HomeScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, secondary) => next,
        transitionsBuilder: (ctx, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDarkGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [AppColors.lightGold, AppColors.gold],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.35),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'ر',
                style: GoogleFonts.cairo(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDarkGreen,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Rahma',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.gold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'رحمة',
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.lightGold,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
