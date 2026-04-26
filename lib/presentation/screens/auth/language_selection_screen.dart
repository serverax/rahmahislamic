import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/language_provider.dart';
import 'onboarding_screen.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  Future<void> _select(BuildContext context, WidgetRef ref, String code) async {
    await ref.read(languageControllerProvider.notifier).setLanguage(code);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [AppColors.lightGold, AppColors.gold],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'ر',
                    style: GoogleFonts.cairo(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.selectLanguage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.selectLanguageSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 48),
              _LanguageButton(
                label: 'English',
                subLabel: 'LTR',
                isPrimary: true,
                onTap: () => _select(context, ref, 'en'),
              ),
              const SizedBox(height: 16),
              _LanguageButton(
                label: 'العربية',
                subLabel: 'RTL',
                isPrimary: false,
                onTap: () => _select(context, ref, 'ar'),
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.label,
    required this.subLabel,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final String subLabel;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary ? AppColors.gold : AppColors.cardGreen;
    final fgColor = isPrimary ? AppColors.primaryDarkGreen : AppColors.textWhite;
    final subColor = isPrimary
        ? AppColors.primaryDarkGreen.withValues(alpha: 0.7)
        : AppColors.mutedText;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: isPrimary
                ? null
                : Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: fgColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: fgColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: subColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
