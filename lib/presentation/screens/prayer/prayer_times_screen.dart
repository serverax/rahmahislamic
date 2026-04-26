import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/prayer_times.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import '../home/widgets/next_prayer_card.dart';
import 'prayer_settings_screen.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  static String labelFor(BuildContext context, Prayer p) {
    final l10n = AppLocalizations.of(context)!;
    switch (p) {
      case Prayer.fajr:
        return l10n.fajr;
      case Prayer.sunrise:
        return l10n.sunrise;
      case Prayer.dhuhr:
        return l10n.dhuhr;
      case Prayer.asr:
        return l10n.asr;
      case Prayer.maghrib:
        return l10n.maghrib;
      case Prayer.isha:
        return l10n.isha;
    }
  }

  static IconData iconFor(Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return PhosphorIconsFill.moonStars;
      case Prayer.sunrise:
        return PhosphorIconsFill.sunHorizon;
      case Prayer.dhuhr:
        return PhosphorIconsFill.sun;
      case Prayer.asr:
        return PhosphorIconsFill.sunDim;
      case Prayer.maghrib:
        return Icons.wb_twilight;
      case Prayer.isha:
        return PhosphorIconsFill.moon;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final view = ref.watch(prayerTimesProvider);
    final tick = ref.watch(clockTickProvider).value ?? DateTime.now();

    final localeStr = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMMEEEEd(localeStr);

    return Scaffold(
      appBar: RahmaAppBar(
        title: l10n.prayerTimes,
        actions: [
          IconButton(
            tooltip: l10n.prayerSettings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrayerSettingsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.gold,
        onRefresh: () async => ref.invalidate(prayerTimesProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
              child: Text(
                dateFmt.format(tick),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.lightGold,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const NextPrayerCard(),
            const SizedBox(height: 16),
            view.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => _FullErrorBlock(error: e),
              data: (data) {
                final current = data.times.currentAt(tick);
                final next = data.times.nextAfter(tick);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        l10n.todaysPrayers,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            for (final entry in data.times.ordered)
                              _PrayerRow(
                                prayer: entry.key,
                                time: entry.value,
                                isCurrent: current?.prayer == entry.key,
                                isNext: next.prayer == entry.key,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.prayer,
    required this.time,
    required this.isCurrent,
    required this.isNext,
  });

  final Prayer prayer;
  final DateTime time;
  final bool isCurrent;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final highlight = isNext;
    final fg = highlight ? AppColors.gold : AppColors.textWhite;

    final row = Container(
      decoration: BoxDecoration(
        color: isCurrent && !isNext ? AppColors.goldTint : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryDarkGreen,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: fg.withValues(alpha: 0.35)),
            ),
            child: Icon(PrayerTimesScreen.iconFor(prayer), color: fg, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              PrayerTimesScreen.labelFor(context, prayer),
              style: GoogleFonts.cairo(
                fontSize: highlight ? 20 : 18,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                color: fg,
              ),
            ),
          ),
          Text(
            DateFormat.Hm().format(time),
            style: GoogleFonts.inter(
              fontSize: highlight ? 22 : 20,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w400,
              color: fg,
            ),
          ),
        ],
      ),
    );

    if (!isNext) return row;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.goldTint,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold, width: 1.5),
        ),
        child: row,
      ),
    );
  }
}

class _FullErrorBlock extends ConsumerWidget {
  const _FullErrorBlock({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 36),
            const SizedBox(height: 12),
            Text(l10n.errorGeneric,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(describePrayerError(error, l10n),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => ref.invalidate(prayerTimesProvider),
              child: Text(l10n.retry),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrayerSettingsScreen()),
              ),
              child: Text(l10n.openSettings),
            ),
          ],
        ),
      ),
    );
  }
}
