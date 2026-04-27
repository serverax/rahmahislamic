import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/qibla_calc.dart';
import '../../../domain/repositories/prayer_repository.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/prayer_settings_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import '../prayer/prayer_settings_screen.dart';
import 'widgets/qibla_compass_painter.dart';

/// Materialised location + Qibla bearing/distance.
class _QiblaFix {
  const _QiblaFix({
    required this.location,
    required this.bearing,
    required this.distanceKm,
  });

  final LocationCoords location;
  final double bearing;
  final double distanceKm;
}

final qiblaFixProvider = FutureProvider.autoDispose<_QiblaFix>((ref) async {
  final settings = ref.watch(prayerSettingsProvider);
  final repo = ref.watch(prayerRepositoryProvider);
  final loc = await repo.resolveLocation(settings);
  return _QiblaFix(
    location: loc,
    bearing: qiblaBearing(loc.latitude, loc.longitude),
    distanceKm: distanceToMeccaKm(loc.latitude, loc.longitude),
  );
});

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final fix = ref.watch(qiblaFixProvider);

    return Scaffold(
      appBar: RahmaAppBar(title: l10n.qibla),
      body: fix.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(error: e),
        data: (data) => _QiblaCompassView(fix: data),
      ),
    );
  }
}

class _QiblaCompassView extends StatelessWidget {
  const _QiblaCompassView({required this.fix});
  final _QiblaFix fix;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final cardinalLabels = isArabic
        ? const ['ش', 'ق', 'ج', 'غ']
        : const ['N', 'E', 'S', 'W'];
    final fmt = NumberFormat('#,##0', isArabic ? 'ar' : 'en');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MetaRow(
              location: fix.location.label,
              bearing: '${fix.bearing.toStringAsFixed(1)}°',
              distance: '${fmt.format(fix.distanceKm)} ${l10n.kmAbbrev}',
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: StreamBuilder<CompassEvent?>(
                    stream: FlutterCompass.events,
                    builder: (ctx, snap) {
                      if (snap.connectionState == ConnectionState.waiting &&
                          snap.data == null) {
                        return _CompassPlaceholder(
                          message: l10n.loading,
                          bearing: fix.bearing,
                          cardinalLabels: cardinalLabels,
                        );
                      }
                      final heading = snap.data?.heading;
                      if (heading == null) {
                        return _NoCompassView(
                          bearing: fix.bearing,
                          cardinalLabels: cardinalLabels,
                          message: l10n.compassUnavailable,
                        );
                      }
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            painter: QiblaCompassPainter(
                              headingDeg: heading,
                              bearingDeg: fix.bearing,
                              cardinalLabels: cardinalLabels,
                            ),
                            size: Size.infinite,
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primaryDarkGreen,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.gold,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '🕋',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<CompassEvent?>(
              stream: FlutterCompass.events,
              builder: (ctx, snap) {
                final heading = snap.data?.heading;
                String hint;
                Color color;
                if (heading == null) {
                  hint = l10n.compassNeedsCalibration;
                  color = AppColors.mutedText;
                } else {
                  final delta = rotationToQibla(
                    heading: heading,
                    bearing: fix.bearing,
                  );
                  if (delta.abs() < 5) {
                    hint = l10n.facingQibla;
                    color = AppColors.gold;
                  } else if (delta > 0) {
                    hint = l10n.rotateRight(delta.toStringAsFixed(0));
                    color = AppColors.lightGold;
                  } else {
                    hint = l10n.rotateLeft(delta.abs().toStringAsFixed(0));
                    color = AppColors.lightGold;
                  }
                }
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIconsRegular.compass,
                        color: color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          hint,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              l10n.qiblaApproximateNote,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.location,
    required this.bearing,
    required this.distance,
  });

  final String location;
  final String bearing;
  final String distance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardGreen, AppColors.secondaryGreen],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.lightGold),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  style: GoogleFonts.inter(
                    color: AppColors.lightGold,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat(label: l10n.bearing, value: bearing),
              _Stat(label: l10n.distanceToMecca, value: distance),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.mutedText,
            fontSize: 11,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: AppColors.gold,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _CompassPlaceholder extends StatelessWidget {
  const _CompassPlaceholder({
    required this.message,
    required this.bearing,
    required this.cardinalLabels,
  });

  final String message;
  final double bearing;
  final List<String> cardinalLabels;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: QiblaCompassPainter(
            headingDeg: 0,
            bearingDeg: bearing,
            cardinalLabels: cardinalLabels,
          ),
          size: Size.infinite,
        ),
        const CircularProgressIndicator(),
      ],
    );
  }
}

class _NoCompassView extends StatelessWidget {
  const _NoCompassView({
    required this.bearing,
    required this.cardinalLabels,
    required this.message,
  });

  final double bearing;
  final List<String> cardinalLabels;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: QiblaCompassPainter(
            headingDeg: 0,
            bearingDeg: bearing,
            cardinalLabels: cardinalLabels,
          ),
          size: Size.infinite,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryDarkGreen.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: AppColors.lightGold,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = error.toString();
    final readable = s.contains('LOCATION_SERVICE_DISABLED')
        ? l10n.errorLocationDisabled
        : s.contains('LOCATION_PERMISSION_DENIED_FOREVER')
            ? l10n.errorLocationDeniedForever
            : s.contains('LOCATION_PERMISSION_DENIED')
                ? l10n.errorLocationDenied
                : s;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.error, size: 36),
            const SizedBox(height: 12),
            Text(
              l10n.errorGeneric,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              readable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => ref.invalidate(qiblaFixProvider),
              child: Text(l10n.retry),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PrayerSettingsScreen(),
                ),
              ),
              child: Text(l10n.openSettings),
            ),
          ],
        ),
      ),
    );
  }
}
