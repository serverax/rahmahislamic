import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/prayer_times.dart';
import '../../../providers/prayer_provider.dart';
import '../../prayer/prayer_times_screen.dart';

class NextPrayerCard extends ConsumerWidget {
  const NextPrayerCard({super.key});

  String _label(BuildContext context, Prayer p) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final times = ref.watch(prayerTimesProvider);
    final tick = ref.watch(clockTickProvider).value ?? DateTime.now();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.cardGreen,
                AppColors.secondaryGreen,
              ],
            ),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: times.when(
            loading: () => _LoadingState(label: l10n.loading),
            error: (e, _) => _ErrorState(error: e),
            data: (view) {
              final next = view.times.nextAfter(tick);
              final remaining = next.time.difference(tick);
              final timeFmt = DateFormat.Hm();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: AppColors.gold),
                      const SizedBox(width: 6),
                      Text(
                        l10n.nextPrayer,
                        style: GoogleFonts.inter(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _label(context, next.prayer),
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeFmt.format(next.time),
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w300,
                                color: AppColors.lightGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l10n.nextPrayerIn,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDuration(remaining),
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.mutedText),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          view.location.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      _SourceChip(source: view.times.source),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

String _formatDuration(Duration d) {
  if (d.isNegative) return '0m';
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  if (h > 0) return '${h}h ${m}m';
  if (m > 0) return '${m}m ${s.toString().padLeft(2, '0')}s';
  return '${s}s';
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.source});
  final PrayerTimesSource source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, color) = switch (source) {
      PrayerTimesSource.network => (l10n.sourceNetwork, AppColors.success),
      PrayerTimesSource.cache => (l10n.sourceCache, AppColors.lightGold),
      PrayerTimesSource.offline => (l10n.sourceOffline, AppColors.mutedText),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  const _ErrorState({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final msg = describePrayerError(error, l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 18),
            const SizedBox(width: 8),
            Text(l10n.errorGeneric,
                style: GoogleFonts.inter(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        const SizedBox(height: 8),
        Text(msg, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton(
              onPressed: () => ref.invalidate(prayerTimesProvider),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ],
    );
  }
}

String describePrayerError(Object error, AppLocalizations l10n) {
  final s = error.toString();
  if (s.contains('LOCATION_SERVICE_DISABLED')) return l10n.errorLocationDisabled;
  if (s.contains('LOCATION_PERMISSION_DENIED_FOREVER')) {
    return l10n.errorLocationDeniedForever;
  }
  if (s.contains('LOCATION_PERMISSION_DENIED')) return l10n.errorLocationDenied;
  return s;
}
