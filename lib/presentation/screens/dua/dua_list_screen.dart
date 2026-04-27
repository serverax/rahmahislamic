import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/dua.dart';
import '../../providers/dua_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import 'dua_detail_screen.dart';

class DuaListScreen extends ConsumerWidget {
  const DuaListScreen({super.key, this.embedded = false});

  final bool embedded;

  static IconData iconFor(String key) {
    switch (key) {
      case 'shield':
        return PhosphorIconsFill.shield;
      case 'compass':
        return PhosphorIconsFill.compass;
      case 'bookOpen':
        return PhosphorIconsFill.bookOpen;
      case 'handsPraying':
        return PhosphorIconsFill.handsPraying;
      case 'star':
        return PhosphorIconsFill.star;
      case 'heart':
      default:
        return PhosphorIconsFill.heart;
    }
  }

  static String localizedCategoryName(BuildContext context, DuaCategory cat) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    switch (cat.id) {
      case 'daily':
        return l10n.duaCategory_daily;
      case 'distress':
        return l10n.duaCategory_distress;
      case 'travel':
        return l10n.duaCategory_travel;
      case 'food':
        return l10n.duaCategory_food;
      case 'knowledge':
        return l10n.duaCategory_knowledge;
      case 'forgiveness':
        return l10n.duaCategory_forgiveness;
      case 'guidance':
        return l10n.duaCategory_guidance;
      default:
        return isArabic ? cat.nameAr : cat.nameEn;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bundle = ref.watch(duasBundleProvider);

    final body = bundle.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(e.toString(), textAlign: TextAlign.center),
        ),
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text(
            l10n.duaCategories,
            style: GoogleFonts.inter(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ...data.categories.map((cat) {
            final items = data.forCategory(cat.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _CategoryRow(
                category: cat,
                count: items.length,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DuaDetailScreen(
                      category: cat,
                      duas: items,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );

    if (embedded) return body;
    return Scaffold(
      appBar: RahmaAppBar(title: l10n.dua),
      body: body,
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.count,
    required this.onTap,
  });

  final DuaCategory category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = DuaListScreen.localizedCategoryName(context, category);
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: AppColors.cardGreen,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
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
                child: Icon(
                  DuaListScreen.iconFor(category.icon),
                  color: AppColors.gold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.duaCount(count),
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
