enum Prayer { fajr, sunrise, dhuhr, asr, maghrib, isha }

class PrayerTimes {
  const PrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.latitude,
    required this.longitude,
    required this.locationLabel,
    required this.source,
  });

  final DateTime date;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final double latitude;
  final double longitude;
  final String locationLabel;
  final PrayerTimesSource source;

  DateTime timeFor(Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return fajr;
      case Prayer.sunrise:
        return sunrise;
      case Prayer.dhuhr:
        return dhuhr;
      case Prayer.asr:
        return asr;
      case Prayer.maghrib:
        return maghrib;
      case Prayer.isha:
        return isha;
    }
  }

  List<MapEntry<Prayer, DateTime>> get ordered => [
        MapEntry(Prayer.fajr, fajr),
        MapEntry(Prayer.sunrise, sunrise),
        MapEntry(Prayer.dhuhr, dhuhr),
        MapEntry(Prayer.asr, asr),
        MapEntry(Prayer.maghrib, maghrib),
        MapEntry(Prayer.isha, isha),
      ];

  ({Prayer prayer, DateTime time}) nextAfter(DateTime now) {
    for (final e in ordered) {
      if (e.value.isAfter(now)) return (prayer: e.key, time: e.value);
    }
    return (prayer: Prayer.fajr, time: fajr.add(const Duration(days: 1)));
  }

  ({Prayer prayer, DateTime time})? currentAt(DateTime now) {
    Prayer? current;
    DateTime? currentTime;
    for (final e in ordered) {
      if (!e.value.isAfter(now)) {
        current = e.key;
        currentTime = e.value;
      }
    }
    if (current == null || currentTime == null) return null;
    return (prayer: current, time: currentTime);
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'fajr': fajr.toIso8601String(),
        'sunrise': sunrise.toIso8601String(),
        'dhuhr': dhuhr.toIso8601String(),
        'asr': asr.toIso8601String(),
        'maghrib': maghrib.toIso8601String(),
        'isha': isha.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'locationLabel': locationLabel,
        'source': source.name,
      };

  factory PrayerTimes.fromJson(Map<String, dynamic> json) => PrayerTimes(
        date: DateTime.parse(json['date'] as String),
        fajr: DateTime.parse(json['fajr'] as String),
        sunrise: DateTime.parse(json['sunrise'] as String),
        dhuhr: DateTime.parse(json['dhuhr'] as String),
        asr: DateTime.parse(json['asr'] as String),
        maghrib: DateTime.parse(json['maghrib'] as String),
        isha: DateTime.parse(json['isha'] as String),
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        locationLabel: json['locationLabel'] as String,
        source: PrayerTimesSource.values
            .firstWhere((s) => s.name == json['source'], orElse: () => PrayerTimesSource.cache),
      );
}

enum PrayerTimesSource { network, cache, offline }
