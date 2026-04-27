import 'package:shared_preferences/shared_preferences.dart';

const _kTasbihPrefix = 'tasbih_count_v1_';
const _kTasbihPhraseKey = 'tasbih_phrase_v1';

class TasbihStore {
  Future<int> getCount(String phraseId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_kTasbihPrefix$phraseId') ?? 0;
  }

  Future<void> setCount(String phraseId, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_kTasbihPrefix$phraseId', value);
  }

  Future<void> increment(String phraseId) async {
    final prefs = await SharedPreferences.getInstance();
    final next = (prefs.getInt('$_kTasbihPrefix$phraseId') ?? 0) + 1;
    await prefs.setInt('$_kTasbihPrefix$phraseId', next);
  }

  Future<void> reset(String phraseId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_kTasbihPrefix$phraseId', 0);
  }

  Future<String?> getSelectedPhrase() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTasbihPhraseKey);
  }

  Future<void> setSelectedPhrase(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTasbihPhraseKey, id);
  }
}
