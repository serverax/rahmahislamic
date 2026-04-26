import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../domain/entities/prayer_settings.dart';
import '../../../domain/entities/prayer_times.dart';

class AladhanApi {
  AladhanApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _base = 'https://api.aladhan.com/v1/timings';

  Future<PrayerTimes> fetchTimings({
    required DateTime date,
    required double latitude,
    required double longitude,
    required CalculationMethod method,
    required AsrSchool school,
    required String locationLabel,
  }) async {
    final unix = (date.millisecondsSinceEpoch ~/ 1000).toString();
    final uri = Uri.parse('$_base/$unix').replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'method': method.aladhanId.toString(),
      'school': school.aladhanId.toString(),
    });

    final res = await _client.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw AladhanException('HTTP ${res.statusCode}: ${res.body}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final code = body['code'] as int?;
    if (code != 200) {
      throw AladhanException('API code $code');
    }
    final data = body['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;

    DateTime parseTime(String hhmm) {
      final clean = hhmm.split(' ').first;
      final parts = clean.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      return DateTime(date.year, date.month, date.day, h, m);
    }

    return PrayerTimes(
      date: DateTime(date.year, date.month, date.day),
      fajr: parseTime(timings['Fajr'] as String),
      sunrise: parseTime(timings['Sunrise'] as String),
      dhuhr: parseTime(timings['Dhuhr'] as String),
      asr: parseTime(timings['Asr'] as String),
      maghrib: parseTime(timings['Maghrib'] as String),
      isha: parseTime(timings['Isha'] as String),
      latitude: latitude,
      longitude: longitude,
      locationLabel: locationLabel,
      source: PrayerTimesSource.network,
    );
  }
}

class AladhanException implements Exception {
  AladhanException(this.message);
  final String message;
  @override
  String toString() => 'AladhanException: $message';
}
