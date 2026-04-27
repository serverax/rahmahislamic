import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/prayer_time_format.dart';
import '../../domain/entities/prayer_times.dart';
import '../providers/prayer_provider.dart';
import '../screens/prayer/prayer_times_screen.dart';

enum _BarState { loading, error, normal, soon, active }

/// Compact countdown bar (~40px). Shows the next prayer name and time-to-go.
/// State-aware:
///   - active : tinted gold, "It's time for X"  (within 60s after start)
///   - soon   : tinted yellow-gold, "X in 7 min"  (< 10 min away)
///   - normal : light surface, "X in 1h 23m"
///   - loading/error: minimal text, no surface
///
/// Tapping opens the full Prayer Times screen.
class PrayerCountdownBar extends ConsumerWidget {
  const PrayerCountdownBar({super.key});

  String _localizedName(AppLocalizations l10n, Prayer p) {
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final view = ref.watch(prayerTimesProvider);
    final tick = ref.watch(clockTickProvider).value ?? DateTime.now();

    return view.when(
      loading: () => _Shell(
        state: _BarState.loading,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Text(l10n.loading, style: _textStyle()),
          ],
        ),
      ),
      error: (e, _) => _Shell(
        state: _BarState.error,
        child: Text(l10n.noLocationYet, style: _textStyle()),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
        ),
      ),
      data: (data) {
        final next = data.times.nextAfter(tick);
        final remaining = next.time.difference(tick);
        final current = data.times.currentAt(tick);
        final isJustStarted = current != null &&
            tick.difference(current.time).inSeconds < 60;
        final isSoon = remaining.inMinutes < 10 && remaining.inMinutes >= 0;

        final state = isJustStarted
            ? _BarState.active
            : (isSoon ? _BarState.soon : _BarState.normal);

        final prayerName = isJustStarted
            ? _localizedName(l10n, current.prayer)
            : _localizedName(l10n, next.prayer);

        final label = isJustStarted
            ? l10n.activeState(prayerName)
            : (isSoon
                ? '$prayerName ${l10n.soonState(remaining.inMinutes < 1 ? 1 : remaining.inMinutes)}'
                : '$prayerName • ${formatPrayerTime(next.time, isArabic: isArabic)}');

        return _Shell(
          state: state,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
          ),
          child: Row(
            children: [
              Icon(
                state == _BarState.active
                    ? PhosphorIconsFill.mosque
                    : PhosphorIconsRegular.clock,
                size: 16,
                color: _foregroundFor(state),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle(state),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 11,
                color: _foregroundFor(state).withValues(alpha: 0.7),
              ),
            ],
          ),
        );
      },
    );
  }
}

TextStyle _textStyle([_BarState state = _BarState.normal]) {
  return GoogleFonts.inter(
    color: _foregroundFor(state),
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );
}

Color _foregroundFor(_BarState state) {
  switch (state) {
    case _BarState.active:
      return AppColors.gold;
    case _BarState.soon:
      return AppColors.lightGold;
    case _BarState.normal:
      return AppColors.lightGold;
    case _BarState.loading:
      return AppColors.mutedText;
    case _BarState.error:
      return AppColors.mutedText;
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.state, required this.child, this.onTap});
  final _BarState state;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = switch (state) {
      _BarState.active => AppColors.gold.withValues(alpha: 0.18),
      _BarState.soon => AppColors.gold.withValues(alpha: 0.10),
      _BarState.normal => AppColors.cardGreen,
      _BarState.loading => AppColors.cardGreen,
      _BarState.error => AppColors.cardGreen,
    };
    final borderAlpha = switch (state) {
      _BarState.active => 0.6,
      _BarState.soon => 0.45,
      _BarState.normal => 0.25,
      _BarState.loading => 0.15,
      _BarState.error => 0.25,
    };

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: borderAlpha),
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
