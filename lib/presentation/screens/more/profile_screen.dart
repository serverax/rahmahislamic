import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/icon_assets.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/rahma_app_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _busy = false;

  Future<void> _signIn() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await AuthController.signInAnonymously();
    } on AuthException catch (e) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.cardGreen,
        duration: const Duration(seconds: 5),
        content: Text(
          '${l10n.signInUnavailable}\n${e.message}',
          style: const TextStyle(color: AppColors.textWhite),
        ),
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    try {
      await AuthController.signOut();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authStateProvider);
    final user = auth.value;

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
                  user == null ? l10n.guestSubtitle : l10n.signedInAs,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.lightGold,
                    fontSize: 13,
                  ),
                ),
                if (user != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.signedInId(_shortId(user)),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.mutedText,
                      fontSize: 11,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (user == null)
                  ElevatedButton.icon(
                    onPressed: _busy ? null : _signIn,
                    icon: _busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(PhosphorIconsRegular.signIn, size: 18),
                    label: Text(_busy ? l10n.signingIn : l10n.signInAnonymously),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _signOut,
                    icon: _busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(PhosphorIconsRegular.signOut, size: 18),
                    label: Text(l10n.signOut),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _shortId(fb.User u) {
  final id = u.uid;
  if (id.length <= 12) return id;
  return '${id.substring(0, 6)}…${id.substring(id.length - 4)}';
}
