import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/dhikr.dart';
import '../../providers/adhkar_provider.dart';
import '../../widgets/prayer_countdown_bar.dart';
import '../../widgets/rahma_app_bar.dart';
import 'adhkar_reader_screen.dart';
import 'names_of_allah_screen.dart';
import 'tasbih_counter_screen.dart';

class AdhkarHomeScreen extends ConsumerWidget {
  const AdhkarHomeScreen({super.key, this.embedded = false});

  final bool embedded;

  static IconData iconFor(String key) {
    switch (key) {
      case 'sunHorizon':
        return PhosphorIconsFill.sunHorizon;
      case 'sunset':
        return Icons.wb_twilight;
      case 'mosque':
        return PhosphorIconsFill.mosque;
      case 'moon':
        return PhosphorIconsFill.moon;
      case 'sun':
        return PhosphorIconsFill.sun;
      case 'shield':
        return PhosphorIconsFill.shield;
      case 'heart':
      default:
        return PhosphorIconsFill.heart;
    }
  }

  static String localizedCategoryName(BuildContext context, DhikrCategory cat) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    switch (cat.id) {
      case 'morning':
        return l10n.category_morning;
      case 'evening':
        return l10n.category_evening;
      case 'after_salah':
        return l10n.category_after_salah;
      case 'sleep':
        return l10n.category_sleep;
      case 'wake':
        return l10n.category_wake;
      case 'protection':
        return l10n.category_protection;
      case 'daily':
        return l10n.category_daily;
      default:
        return isArabic ? cat.nameAr : cat.nameEn;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bundle = ref.watch(adhkarBundleProvider);

    final body = bundle.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(e.toString(), textAlign: TextAlign.center),
        ),
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const PrayerCountdownBar(),
          const SizedBox(height: 16),
          Text(
            l10n.adhkar,
            style: GoogleFonts.inter(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: data.categories
                .map((cat) => _CategoryCard(
                      category: cat,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AdhkarReaderScreen(category: cat),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          _FeatureRow(
            icon: PhosphorIconsFill.circlesThreePlus,
            title: l10n.tasbihCounter,
            subtitle: l10n.tapAnywhereToCount,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TasbihCounterScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: PhosphorIconsFill.star,
            title: l10n.asmaUlHusna,
            subtitle: l10n.asmaUlHusnaSubtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NamesOfAllahScreen()),
            ),
          ),
        ],
      ),
    );

    if (embedded) return body;
    return Scaffold(
      appBar: RahmaAppBar(title: l10n.adhkar),
      body: body,
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});
  final DhikrCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = AdhkarHomeScreen.localizedCategoryName(context, category);
    final icon = AdhkarHomeScreen.iconFor(category.icon);
    return Material(
      color: AppColors.cardGreen,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withValues(alpha: 0.12),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                ),
                child: Icon(icon, color: AppColors.gold, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.2,
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

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.cardGreen,
                AppColors.gold.withValues(alpha: 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                ),
                child: Icon(icon, color: AppColors.gold, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
