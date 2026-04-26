import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/device/location_service.dart';
import '../../data/datasources/local/prayer_cache.dart';
import '../../data/datasources/remote/aladhan_api.dart';
import '../../data/repositories/prayer_repository_impl.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/repositories/prayer_repository.dart';
import 'prayer_settings_provider.dart';

final aladhanApiProvider = Provider<AladhanApi>((ref) => AladhanApi());
final prayerCacheProvider = Provider<PrayerCache>((ref) => PrayerCache());
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  return PrayerRepositoryImpl(
    api: ref.watch(aladhanApiProvider),
    cache: ref.watch(prayerCacheProvider),
    locationService: ref.watch(locationServiceProvider),
  );
});

class PrayerTimesView {
  const PrayerTimesView({required this.times, required this.location});
  final PrayerTimes times;
  final LocationCoords location;
}

final prayerTimesProvider =
    FutureProvider.autoDispose<PrayerTimesView>((ref) async {
  final settings = ref.watch(prayerSettingsProvider);
  final repo = ref.watch(prayerRepositoryProvider);
  final location = await repo.resolveLocation(settings);
  final times = await repo.getTimesForToday(location: location, settings: settings);
  return PrayerTimesView(times: times, location: location);
});

final clockTickProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});
