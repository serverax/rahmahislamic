import 'dart:math';

/// Coordinates of the Kaaba in Mecca.
const double kKaabaLatitude = 21.4225;
const double kKaabaLongitude = 39.8262;

const double _earthRadiusKm = 6371.0;

/// Initial bearing (degrees clockwise from true north, 0-360) from
/// (lat, lng) toward the Kaaba.
///
/// This is the great-circle bearing, not a rhumb line. Phone compasses
/// report magnetic north; this helper does NOT correct for magnetic
/// declination — for an MVP that's acceptable; correction would require
/// the World Magnetic Model. Document this in the screen as "approximate".
double qiblaBearing(double lat, double lng) {
  final phi1 = lat * pi / 180;
  final phi2 = kKaabaLatitude * pi / 180;
  final dLambda = (kKaabaLongitude - lng) * pi / 180;

  final y = sin(dLambda) * cos(phi2);
  final x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(dLambda);

  final bearingRad = atan2(y, x);
  return (bearingRad * 180 / pi + 360) % 360;
}

/// Great-circle distance in kilometres from (lat, lng) to the Kaaba.
double distanceToMeccaKm(double lat, double lng) {
  final dLat = (kKaabaLatitude - lat) * pi / 180;
  final dLng = (kKaabaLongitude - lng) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat * pi / 180) *
          cos(kKaabaLatitude * pi / 180) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return _earthRadiusKm * c;
}

/// Convert a heading (e.g. compass reading) to a "delta" — degrees the
/// device needs to rotate clockwise to face the Qibla. Range: -180..180.
double rotationToQibla({required double heading, required double bearing}) {
  var delta = bearing - heading;
  while (delta > 180) {
    delta -= 360;
  }
  while (delta < -180) {
    delta += 360;
  }
  return delta;
}

double degToRad(double deg) => deg * pi / 180;
