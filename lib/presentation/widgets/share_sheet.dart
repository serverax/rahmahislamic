import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';

/// Plain-text content to share. The repository owns the formatting
/// decision; this widget just sends the string verbatim.
class ShareContent {
  const ShareContent({required this.text, this.subject});
  final String text;
  final String? subject;
}

/// Bottom sheet with two options: copy to clipboard + system share.
/// Save-as-image is deliberately not here; it requires camera-roll
/// permissions and a deprecated gallery-saver plugin. Add if/when needed.
class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key, required this.content});
  final ShareContent content;

  static Future<void> show(BuildContext context, ShareContent content) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardGreen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ShareSheet(content: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              l10n.shareContent,
              style: GoogleFonts.inter(
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              constraints: const BoxConstraints(maxHeight: 160),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryDarkGreen,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
              ),
              child: SingleChildScrollView(
                child: Text(
                  content.text,
                  style: GoogleFonts.inter(
                    color: AppColors.lightGold,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _Action(
                    icon: Icons.copy_outlined,
                    label: l10n.copyText,
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: content.text));
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            backgroundColor: AppColors.cardGreen,
                            duration: const Duration(seconds: 2),
                            content: Text(
                              l10n.copiedToClipboard,
                              style: const TextStyle(color: AppColors.textWhite),
                            ),
                          ));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Action(
                    icon: Icons.share_outlined,
                    label: l10n.shareVia,
                    primary: true,
                    onTap: () async {
                      final box = context.findRenderObject() as RenderBox?;
                      Navigator.of(context).pop();
                      await Share.share(
                        content.text,
                        subject: content.subject,
                        sharePositionOrigin: box != null
                            ? box.localToGlobal(Offset.zero) & box.size
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final fg = primary ? AppColors.primaryDarkGreen : AppColors.gold;
    final bg = primary ? AppColors.gold : AppColors.gold.withValues(alpha: 0.1);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: primary
                ? null
                : Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: fg,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
