import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../providers/quran_provider.dart';
import '../quran_reader_screen.dart';

class ContinueReadingCard extends ConsumerWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lastRead = ref.watch(lastReadControllerProvider);
    return lastRead.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (record) {
        if (record == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QuranReaderScreen(
                    surahNumber: record.surahNumber,
                    surahName: record.surahName,
                    initialVerse: record.verseNumber,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.cardGreen, AppColors.secondaryGreen],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gold.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                      ),
                      child: const Icon(
                        PhosphorIconsFill.bookOpen,
                        color: AppColors.gold,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.continueReading,
                            style: GoogleFonts.inter(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            record.surahName,
                            style: GoogleFonts.inter(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.verseN(record.verseNumber),
                            style: GoogleFonts.inter(
                              color: AppColors.lightGold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.gold,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
