import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/dream_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import 'dream_input_screen.dart';

class DreamWarningScreen extends ConsumerWidget {
  const DreamWarningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: RahmaAppBar(title: l10n.dreamInterpretation),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error.withValues(alpha: 0.18),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.warning_amber_rounded,
                      size: 52, color: AppColors.error),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.dreamWarningTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.dreamWarningBodyEn,
                textAlign: TextAlign.center,
                textDirection: isArabic ? TextDirection.rtl : null,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  height: 1.7,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.science_outlined,
                        color: AppColors.gold, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.dreamReviewBanner,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.lightGold,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(dreamHistoryStoreProvider)
                      .setWarningAccepted();
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const DreamInputScreen(),
                    ),
                  );
                },
                child: Text(l10n.dreamAgree),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Convenience launcher: shows the warning screen if not yet accepted,
/// otherwise jumps straight to the input screen. Use this from any tile
/// that wants to enter the feature.
class DreamFeatureEntry {
  static Future<void> open(BuildContext context, WidgetRef ref) async {
    final accepted =
        await ref.read(dreamHistoryStoreProvider).hasAcceptedWarning();
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            accepted ? const DreamInputScreen() : const DreamWarningScreen(),
      ),
    );
  }
}
