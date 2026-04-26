import 'package:adhan/adhan.dart' as adhan;

import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/device/location_service.dart';
import '../datasources/local/prayer_cache.dart';
import '../datasources/remote/aladhan_api.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  PrayerRepositoryImpl({
    required this.api,
    required this.cache,
    required this.locationService,
  });

  final AladhanApi api;
  final PrayerCache cache;
  final LocationService locationService;

  @override
  Future<LocationCoords> resolveLocation(PrayerSettings settings) async {
    if (settings.locationMode == LocationMode.manual) {
      final c = settings.manualCity;
      return LocationCoords(
        latitude: c.latitude,
        longitude: c.longitude,
        label: '${c.nameEn} / ${c.nameAr}',
      );
    }
    final pos = await locationService.getCurrent();
    return LocationCoords(
      latitude: pos.latitude,
      longitude: pos.longitude,
      label: 'Current location',
    );
  }

  @override
  Future<PrayerTimes> getTimesForToday({
    required LocationCoords location,
    required PrayerSettings settings,
  }) async {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    final cached = await cache.get(
      date: dateOnly,
      latitude: location.latitude,
      longitude: location.longitude,
    );
    if (cached != null) return cached;

    try {
      final fresh = await api.fetchTimings(
        date: dateOnly,
        latitude: location.latitude,
        longitude: location.longitude,
        method: settings.method,
        school: settings.asrSchool,
        locationLabel: location.label,
      );
      await cache.put(fresh);
      return fresh;
    } catch (_) {
      return _offlineFallback(
        date: dateOnly,
        location: location,
        settings: settings,
      );
    }
  }

  PrayerTimes _offlineFallback({
    required DateTime date,
    required LocationCoords location,
    required PrayerSettings settings,
  }) {
    final coords = adhan.Coordinates(location.latitude, location.longitude);
    final params = _adhanMethod(settings.method).getParameters();
    params.madhab = settings.asrSchool == AsrSchool.hanafi ? adhan.Madhab.hanafi : adhan.Madhab.shafi;
    final dateComponents = adhan.DateComponents(date.year, date.month, date.day);
    final times = adhan.PrayerTimes(coords, dateComponents, params);

    return PrayerTimes(
      date: date,
      fajr: times.fajr.toLocal(),
      sunrise: times.sunrise.toLocal(),
      dhuhr: times.dhuhr.toLocal(),
      asr: times.asr.toLocal(),
      maghrib: times.maghrib.toLocal(),
      isha: times.isha.toLocal(),
      latitude: location.latitude,
      longitude: location.longitude,
      locationLabel: location.label,
      source: PrayerTimesSource.offline,
    );
  }

  adhan.CalculationMethod _adhanMethod(CalculationMethod m) {
    switch (m) {
      case CalculationMethod.muslimWorldLeague:
        return adhan.CalculationMethod.muslim_world_league;
      case CalculationMethod.egyptian:
        return adhan.CalculationMethod.egyptian;
      case CalculationMethod.karachi:
        return adhan.CalculationMethod.karachi;
      case CalculationMethod.ummAlQura:
        return adhan.CalculationMethod.umm_al_qura;
      case CalculationMethod.dubai:
        return adhan.CalculationMethod.dubai;
      case CalculationMethod.northAmerica:
        return adhan.CalculationMethod.north_america;
    }
  }
}
