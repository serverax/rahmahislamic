import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../providers/prayer_provider.dart';
import '../../prayer/prayer_times_screen.dart';
import 'next_prayer_card.dart';

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
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.todaysPrayers,
                  style: Theme.of(context).textTheme.headlineMedium),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
                ),
                child: Text(l10n.viewAll),
              ),
            ],
          ),
          view.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(describePrayerError(e, l10n),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            data: (data) => Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    for (final entry in data.times.ordered)
                      ListTile(
                        dense: false,
                        leading: Icon(
                          PrayerTimesScreen.iconFor(entry.key),
                          color: AppColors.gold,
                        ),
                        title: Text(
                          PrayerTimesScreen.labelFor(context, entry.key),
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: AppColors.textWhite,
                          ),
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(entry.value),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColors.lightGold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
