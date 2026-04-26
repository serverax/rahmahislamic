import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/prayer_time_format.dart';
import '../../../../domain/entities/prayer_times.dart';
import '../../../providers/prayer_provider.dart';
import '../../../widgets/section_header.dart';
import '../../prayer/prayer_times_screen.dart';
import 'daily_inspiration_card.dart';
import 'next_prayer_card.dart';
import 'quick_access_grid.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final view = ref.watch(prayerTimesProvider);
    final tick = ref.watch(clockTickProvider).value ?? DateTime.now();

    return RefreshIndicator(
      color: AppColors.gold,
      onRefresh: () async => ref.invalidate(prayerTimesProvider),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _Greeting(now: tick),
          const SizedBox(height: 16),
          const NextPrayerCard(),
          SectionHeader(label: l10n.quickAccess),
          const QuickAccessGrid(),
          SectionHeader(
            label: l10n.todaysPrayers,
            trailing: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
              ),
              child: Text(l10n.viewAll),
            ),
          ),
          view.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => const SizedBox.shrink(),
            data: (data) => _CompactPrayerStrip(times: data.times),
          ),
          const SizedBox(height: 24),
          const DailyInspirationCard(),
        ],
      ),
    );
  }
}

class _CompactPrayerStrip extends StatelessWidget {
  const _CompactPrayerStrip({required this.times});
  final PrayerTimes times;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        itemCount: times.ordered.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final entry = times.ordered[i];
          return Container(
            width: 92,
            decoration: BoxDecoration(
              color: AppColors.cardGreen,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.goldBorderSoft),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  PrayerTimesScreen.iconFor(entry.key),
                  color: AppColors.gold,
                  size: 22,
                ),
                Text(
                  PrayerTimesScreen.labelFor(context, entry.key),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formatPrayerTime(entry.value, isArabic: isArabic),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.lightGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.now});
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'As-salāmu ʿalaykum',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.lightGold,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dateFmt.format(now),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
