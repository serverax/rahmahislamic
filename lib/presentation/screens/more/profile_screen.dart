import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/icon_assets.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/rahma_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: RahmaAppBar(title: l10n.profile),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.cardGreen, AppColors.secondaryGreen],
              ),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
            ),
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryDarkGreen,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.6),
                      width: 2,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    IconAssets.sheikh3D,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.guest,
                  style: GoogleFonts.cairo(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.guestSubtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.lightGold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.cardGreen,
                          duration: const Duration(seconds: 4),
                          content: Text(
                            l10n.signInComingSoon,
                            style: const TextStyle(color: AppColors.textWhite),
                          ),
                        ),
                      );
                  },
                  icon: const Icon(PhosphorIconsRegular.signIn, size: 18),
                  label: Text(l10n.signIn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
