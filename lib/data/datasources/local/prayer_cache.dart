import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/prayer_times.dart';

class PrayerCache {
  static String _key(DateTime date, double lat, double lng) {
    final d =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'prayer_times_${d}_${lat.toStringAsFixed(1)}_${lng.toStringAsFixed(1)}';
  }

  Future<PrayerTimes?> get({
    required DateTime date,
    required double latitude,
    required double longitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(date, latitude, longitude));
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final t = PrayerTimes.fromJson(json);
      return PrayerTimes(
        date: t.date,
        fajr: t.fajr,
        sunrise: t.sunrise,
        dhuhr: t.dhuhr,
        asr: t.asr,
        maghrib: t.maghrib,
        isha: t.isha,
        latitude: t.latitude,
        longitude: t.longitude,
        locationLabel: t.locationLabel,
        source: PrayerTimesSource.cache,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> put(PrayerTimes times) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(times.date, times.latitude, times.longitude),
      jsonEncode(times.toJson()),
    );
  }
}
