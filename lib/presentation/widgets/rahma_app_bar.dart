import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../core/theme/app_colors.dart';
import '../providers/prayer_provider.dart';

class RahmaAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const RahmaAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final tick = ref.watch(clockTickProvider).value ?? DateTime.now();

    return AppBar(
      title: Text(title),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: Center(
            child: _LiveClock(time: tick, isArabic: isArabic),
          ),
        ),
        ...?actions,
      ],
    );
  }
}

class _LiveClock extends StatelessWidget {
  const _LiveClock({required this.time, required this.isArabic});

  final DateTime time;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final text = isArabic ? _formatArabic(time) : _formatEnglish(time);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        style: GoogleFonts.inter(
          color: AppColors.gold,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  static String _formatEnglish(DateTime t) => DateFormat('h:mm a').format(t);

  static const _arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  static String _toArabicDigits(String s) =>
      s.split('').map((c) {
        final code = c.codeUnitAt(0);
        if (code >= 0x30 && code <= 0x39) return _arabicDigits[code - 0x30];
        return c;
      }).join();

  static String _formatArabic(DateTime t) {
    final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final mm = t.minute.toString().padLeft(2, '0');
    final hh = hour12.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'م' : 'ص';
    return '${_toArabicDigits(hh)}:${_toArabicDigits(mm)} $period';
  }
}
