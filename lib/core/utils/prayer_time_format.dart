import 'package:intl/intl.dart' hide TextDirection;

const _arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

String _toArabicDigits(String s) => s.split('').map((c) {
      final code = c.codeUnitAt(0);
      if (code >= 0x30 && code <= 0x39) return _arabicDigits[code - 0x30];
      return c;
    }).join();

String formatPrayerTime(DateTime t, {required bool isArabic}) {
  if (!isArabic) {
    return DateFormat('h:mm a').format(t);
  }
  final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final mm = t.minute.toString().padLeft(2, '0');
  final hh = hour12.toString().padLeft(2, '0');
  final period = t.hour >= 12 ? 'م' : 'ص';
  return '${_toArabicDigits(hh)}:${_toArabicDigits(mm)} $period';
}
