import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/icon_assets.dart';
import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../prayer/prayer_times_screen.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final tiles = <_TileSpec>[
      _TileSpec(
        label: l10n.prayerTimes,
        visual: const _ImageIcon(IconAssets.mosque),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
        ),
      ),
      _TileSpec(
        label: l10n.quran,
        visual: const _ImageIcon(IconAssets.quran),
        onTap: () => _comingSoon(context, l10n),
      ),
      _TileSpec(
        label: l10n.adhkar,
        visual: const _ImageIcon(IconAssets.tasbih),
        onTap: () => _comingSoon(context, l10n),
      ),
      _TileSpec(
        label: l10n.dua,
        visual: const _ImageIcon(IconAssets.duaHands),
        onTap: () => _comingSoon(context, l10n),
      ),
      _TileSpec(
        label: l10n.qibla,
        visual: const _GlyphIcon(PhosphorIconsRegular.compass),
        onTap: () => _comingSoon(context, l10n),
      ),
      _TileSpec(
        label: l10n.namesOfAllah,
        visual: const _GlyphIcon(PhosphorIconsRegular.star),
        onTap: () => _comingSoon(context, l10n),
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: tiles.map((t) => _Tile(spec: t)).toList(),
    );
  }

  void _comingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.cardGreen,
          content: Text(
            l10n.comingInNextSlice,
            style: const TextStyle(color: AppColors.textWhite),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class _TileSpec {
  const _TileSpec({required this.label, required this.visual, required this.onTap});
  final String label;
  final Widget visual;
  final VoidCallback onTap;
}

class _ImageIcon extends StatelessWidget {
  const _ImageIcon(this.path);
  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: 56,
      height: 56,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class _GlyphIcon extends StatelessWidget {
  const _GlyphIcon(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gold.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      child: Icon(icon, color: AppColors.gold, size: 26),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.spec});
  final _TileSpec spec;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardGreen,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: spec.onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 56, child: Center(child: spec.visual)),
              const SizedBox(height: 8),
              Text(
                spec.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
