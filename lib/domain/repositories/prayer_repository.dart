import '../entities/prayer_settings.dart';
import '../entities/prayer_times.dart';

class LocationCoords {
  const LocationCoords({
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  final double latitude;
  final double longitude;
  final String label;
}

abstract class PrayerRepository {
  Future<LocationCoords> resolveLocation(PrayerSettings settings);

  Future<PrayerTimes> getTimesForToday({
    required LocationCoords location,
    required PrayerSettings settings,
  });
}

class PrayerLocationException implements Exception {
  PrayerLocationException(this.message);
  final String message;
  @override
  String toString() => 'PrayerLocationException: $message';
}
