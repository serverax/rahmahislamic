import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/prayer_countdown_bar.dart';
import '../dream/dream_warning_screen.dart';
import '../prayer/prayer_settings_screen.dart';
import 'about_screen.dart';
import 'app_settings_screen.dart';
import 'profile_screen.dart';

class MoreTab extends ConsumerWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        const PrayerCountdownBar(),
        const SizedBox(height: 16),
        _Row(
          icon: PhosphorIconsRegular.userCircle,
          title: l10n.profile,
          subtitle: l10n.profileFeatureSubtitle,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          ),
        ),
        const SizedBox(height: 10),
        _Row(
          icon: PhosphorIconsRegular.gear,
          title: l10n.appSettings,
          subtitle: l10n.appSettingsSubtitle,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AppSettingsScreen()),
          ),
        ),
        const SizedBox(height: 10),
        _Row(
          icon: PhosphorIconsRegular.clock,
          title: l10n.prayerSettings,
          subtitle: l10n.prayerSettingsSubtitle,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PrayerSettingsScreen()),
          ),
        ),
        const SizedBox(height: 10),
        Consumer(
          builder: (ctx, innerRef, _) => _Row(
            icon: PhosphorIconsRegular.moonStars,
            title: l10n.dreamInterpretation,
            subtitle: l10n.moreFeatureExperimental,
            onTap: () => DreamFeatureEntry.open(ctx, innerRef),
          ),
        ),
        const SizedBox(height: 10),
        _Row(
          icon: PhosphorIconsRegular.info,
          title: l10n.about,
          subtitle: l10n.aboutSubtitle,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AboutScreen()),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: Icon(icon, color: AppColors.gold, size: 22),
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
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
