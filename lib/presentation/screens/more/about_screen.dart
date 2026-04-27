import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/rahma_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _appVersion = '1.0.0';

  void _showComingSoon(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        backgroundColor: AppColors.cardGreen,
        duration: const Duration(seconds: 2),
        content: Text(
          l10n.comingSoon,
          style: const TextStyle(color: AppColors.textWhite),
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: RahmaAppBar(title: l10n.about),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [AppColors.lightGold, AppColors.gold],
                    ),
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
                const SizedBox(height: 12),
                Text(
                  'Rahma / رحمة',
                  style: GoogleFonts.inter(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.version} $_appVersion',
                  style: GoogleFonts.inter(
                    color: AppColors.mutedText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.gold, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      l10n.scholarReviewNoteTitle,
                      style: GoogleFonts.inter(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.scholarReviewNoteBody,
                  style: GoogleFonts.cairo(
                    color: AppColors.lightGold,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(text: l10n.credits),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.creditsBody,
                style: GoogleFonts.inter(
                  color: AppColors.textWhite,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.shieldCheck,
                      color: AppColors.gold),
                  title: Text(l10n.privacyPolicy),
                  trailing: Text(
                    l10n.comingSoon,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => _showComingSoon(context),
                ),
                const Divider(height: 1, color: AppColors.primaryDarkGreen),
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.fileText,
                      color: AppColors.gold),
                  title: Text(l10n.termsOfService),
                  trailing: Text(
                    l10n.comingSoon,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => _showComingSoon(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.gold,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
