import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/surah.dart';

class SurahListTile extends StatelessWidget {
  const SurahListTile({super.key, required this.surah, required this.onTap});

  final Surah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final placeLabel = surah.revelationPlace == RevelationPlace.medinan
        ? l10n.medinan
        : l10n.meccan;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 0.785398,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.12),
                          border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Text(
                      surah.number.toString(),
                      style: GoogleFonts.inter(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.nameSimple,
                      style: GoogleFonts.inter(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$placeLabel • ${surah.versesCount} ${AppLocalizations.of(context)!.verses}',
                      style: GoogleFonts.inter(
                        color: AppColors.mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                surah.nameArabic,
                style: GoogleFonts.cairo(
                  color: AppColors.lightGold,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
