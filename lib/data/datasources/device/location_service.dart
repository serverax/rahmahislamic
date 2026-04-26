import 'package:geolocator/geolocator.dart';

import '../../../domain/repositories/prayer_repository.dart';

class LocationService {
  Future<({double latitude, double longitude})> getCurrent() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw PrayerLocationException('LOCATION_SERVICE_DISABLED');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw PrayerLocationException('LOCATION_PERMISSION_DENIED');
    }
    if (permission == LocationPermission.deniedForever) {
      throw PrayerLocationException('LOCATION_PERMISSION_DENIED_FOREVER');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return (latitude: position.latitude, longitude: position.longitude);
  }
}
