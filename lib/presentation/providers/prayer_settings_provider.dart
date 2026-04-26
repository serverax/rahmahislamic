import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/prayer_settings.dart';

const _prefsKey = 'prayer_settings_v1';

class PrayerSettingsController extends StateNotifier<PrayerSettings> {
  PrayerSettingsController() : super(PrayerSettings.defaults) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      state = PrayerSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt cache — keep defaults.
    }
  }

  Future<void> _persist(PrayerSettings next) async {
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(next.toJson()));
  }

  Future<void> setMethod(CalculationMethod method) =>
      _persist(state.copyWith(method: method));

  Future<void> setAsrSchool(AsrSchool school) =>
      _persist(state.copyWith(asrSchool: school));

  Future<void> setLocationMode(LocationMode mode) =>
      _persist(state.copyWith(locationMode: mode));

  Future<void> setManualCity(String cityId) =>
      _persist(state.copyWith(manualCityId: cityId));

  Future<void> setNotificationsEnabled(bool enabled) =>
      _persist(state.copyWith(notificationsEnabled: enabled));

  Future<void> setMinutesBefore(int minutes) =>
      _persist(state.copyWith(minutesBefore: minutes));
}

final prayerSettingsProvider =
    StateNotifierProvider<PrayerSettingsController, PrayerSettings>((ref) {
  return PrayerSettingsController();
});
