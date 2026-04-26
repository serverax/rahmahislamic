enum CalculationMethod {
  muslimWorldLeague(aladhanId: 3, label: 'Muslim World League'),
  egyptian(aladhanId: 5, label: 'Egyptian General Authority'),
  karachi(aladhanId: 1, label: 'Karachi (University of Islamic Sciences)'),
  ummAlQura(aladhanId: 4, label: 'Umm al-Qura (Mecca)'),
  dubai(aladhanId: 8, label: 'Dubai'),
  northAmerica(aladhanId: 2, label: 'ISNA (North America)');

  const CalculationMethod({required this.aladhanId, required this.label});

  final int aladhanId;
  final String label;
}

enum AsrSchool {
  shafi(aladhanId: 0, label: 'Standard (Shafi, Maliki, Hanbali)'),
  hanafi(aladhanId: 1, label: 'Hanafi');

  const AsrSchool({required this.aladhanId, required this.label});

  final int aladhanId;
  final String label;
}

enum LocationMode { auto, manual }

class PresetCity {
  const PresetCity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final double latitude;
  final double longitude;
}

class PresetCities {
  PresetCities._();

  static const all = <PresetCity>[
    PresetCity(id: 'mecca', nameEn: 'Mecca', nameAr: 'مكة المكرمة', latitude: 21.4225, longitude: 39.8262),
    PresetCity(id: 'medina', nameEn: 'Medina', nameAr: 'المدينة المنورة', latitude: 24.5247, longitude: 39.5692),
    PresetCity(id: 'jerusalem', nameEn: 'Jerusalem', nameAr: 'القدس', latitude: 31.7683, longitude: 35.2137),
    PresetCity(id: 'cairo', nameEn: 'Cairo', nameAr: 'القاهرة', latitude: 30.0444, longitude: 31.2357),
    PresetCity(id: 'istanbul', nameEn: 'Istanbul', nameAr: 'إسطنبول', latitude: 41.0082, longitude: 28.9784),
    PresetCity(id: 'riyadh', nameEn: 'Riyadh', nameAr: 'الرياض', latitude: 24.7136, longitude: 46.6753),
    PresetCity(id: 'dubai', nameEn: 'Dubai', nameAr: 'دبي', latitude: 25.2048, longitude: 55.2708),
    PresetCity(id: 'doha', nameEn: 'Doha', nameAr: 'الدوحة', latitude: 25.2854, longitude: 51.5310),
    PresetCity(id: 'amman', nameEn: 'Amman', nameAr: 'عمّان', latitude: 31.9454, longitude: 35.9284),
    PresetCity(id: 'baghdad', nameEn: 'Baghdad', nameAr: 'بغداد', latitude: 33.3152, longitude: 44.3661),
    PresetCity(id: 'tehran', nameEn: 'Tehran', nameAr: 'طهران', latitude: 35.6892, longitude: 51.3890),
    PresetCity(id: 'karachi', nameEn: 'Karachi', nameAr: 'كراتشي', latitude: 24.8607, longitude: 67.0011),
    PresetCity(id: 'lahore', nameEn: 'Lahore', nameAr: 'لاهور', latitude: 31.5497, longitude: 74.3436),
    PresetCity(id: 'jakarta', nameEn: 'Jakarta', nameAr: 'جاكرتا', latitude: -6.2088, longitude: 106.8456),
    PresetCity(id: 'kualalumpur', nameEn: 'Kuala Lumpur', nameAr: 'كوالالمبور', latitude: 3.1390, longitude: 101.6869),
    PresetCity(id: 'london', nameEn: 'London', nameAr: 'لندن', latitude: 51.5074, longitude: -0.1278),
    PresetCity(id: 'newyork', nameEn: 'New York', nameAr: 'نيويورك', latitude: 40.7128, longitude: -74.0060),
    PresetCity(id: 'toronto', nameEn: 'Toronto', nameAr: 'تورنتو', latitude: 43.6532, longitude: -79.3832),
  ];

  static PresetCity? byId(String? id) {
    if (id == null) return null;
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }
}

class PrayerSettings {
  const PrayerSettings({
    required this.method,
    required this.asrSchool,
    required this.locationMode,
    required this.manualCityId,
    required this.notificationsEnabled,
    required this.minutesBefore,
  });

  final CalculationMethod method;
  final AsrSchool asrSchool;
  final LocationMode locationMode;
  final String? manualCityId;
  final bool notificationsEnabled;
  final int minutesBefore;

  static const defaults = PrayerSettings(
    method: CalculationMethod.muslimWorldLeague,
    asrSchool: AsrSchool.shafi,
    locationMode: LocationMode.auto,
    manualCityId: 'mecca',
    notificationsEnabled: true,
    minutesBefore: 15,
  );

  PresetCity get manualCity => PresetCities.byId(manualCityId) ?? PresetCities.all.first;

  PrayerSettings copyWith({
    CalculationMethod? method,
    AsrSchool? asrSchool,
    LocationMode? locationMode,
    String? manualCityId,
    bool? notificationsEnabled,
    int? minutesBefore,
  }) {
    return PrayerSettings(
      method: method ?? this.method,
      asrSchool: asrSchool ?? this.asrSchool,
      locationMode: locationMode ?? this.locationMode,
      manualCityId: manualCityId ?? this.manualCityId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      minutesBefore: minutesBefore ?? this.minutesBefore,
    );
  }

  Map<String, dynamic> toJson() => {
        'method': method.name,
        'asrSchool': asrSchool.name,
        'locationMode': locationMode.name,
        'manualCityId': manualCityId,
        'notificationsEnabled': notificationsEnabled,
        'minutesBefore': minutesBefore,
      };

  factory PrayerSettings.fromJson(Map<String, dynamic> json) => PrayerSettings(
        method: CalculationMethod.values.firstWhere(
          (m) => m.name == json['method'],
          orElse: () => defaults.method,
        ),
        asrSchool: AsrSchool.values.firstWhere(
          (a) => a.name == json['asrSchool'],
          orElse: () => defaults.asrSchool,
        ),
        locationMode: LocationMode.values.firstWhere(
          (l) => l.name == json['locationMode'],
          orElse: () => defaults.locationMode,
        ),
        manualCityId: json['manualCityId'] as String? ?? defaults.manualCityId,
        notificationsEnabled:
            json['notificationsEnabled'] as bool? ?? defaults.notificationsEnabled,
        minutesBefore: (json['minutesBefore'] as num?)?.toInt() ?? defaults.minutesBefore,
      );
}
