import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/prayer_times.dart';
import '../../providers/prayer_provider.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prayerTimes),
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
  });

  final Prayer prayer;
  final DateTime time;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final fg = isCurrent ? AppColors.gold : AppColors.textWhite;
    return Container(
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.gold.withValues(alpha: 0.08) : null,
        border: Border(
          left: BorderSide(
            color: isCurrent ? AppColors.gold : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryDarkGreen,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: fg.withValues(alpha: 0.3)),
            ),
            child: Icon(PrayerTimesScreen.iconFor(prayer), color: fg, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              PrayerTimesScreen.labelFor(context, prayer),
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                color: fg,
              ),
            ),
          ),
          Text(
            DateFormat.Hm().format(time),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
              color: fg,
            ),
          ),
        ],
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
            Icon(Icons.error_outline, color: AppColors.error, size: 36),
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
