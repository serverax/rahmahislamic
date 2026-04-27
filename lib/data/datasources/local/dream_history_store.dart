import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const _kHistoryKey = 'dream_history_v1';
const _kWarningAcceptedKey = 'dream_warning_accepted_v1';
const _kDailyCountPrefix = 'dream_daily_count_v1_';

const int kFreeDailyDreamLimit = 3;

class DreamHistoryStore {
  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kHistoryKey);
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return const [];
    }
  }

  Future<void> append(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<Map<String, dynamic>>.from(await getHistory());
    list.insert(0, entry);
    // Cap history to last 50 entries to keep prefs small.
    final capped = list.take(50).toList();
    await prefs.setString(_kHistoryKey, jsonEncode(capped));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kHistoryKey);
  }

  Future<bool> hasAcceptedWarning() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kWarningAcceptedKey) ?? false;
  }

  Future<void> setWarningAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWarningAcceptedKey, true);
  }

  static String _todayKey() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$_kDailyCountPrefix$y-$m-$d';
  }

  Future<int> getTodayCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_todayKey()) ?? 0;
  }

  Future<void> incrementTodayCount() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _todayKey();
    final current = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, current + 1);
  }

  Future<bool> canSubmitDream() async {
    return (await getTodayCount()) < kFreeDailyDreamLimit;
  }
}
