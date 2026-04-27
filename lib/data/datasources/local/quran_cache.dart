import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/ayah.dart';
import '../../../domain/entities/quran_bookmark.dart';
import '../../../domain/entities/surah.dart';

const _kChaptersKey = 'quran_chapters_v1';
const _kVersesKeyPrefix = 'quran_verses_v1_';
const _kBookmarksKey = 'quran_bookmarks_v1';
const _kLastReadKey = 'quran_last_read_v1';

class QuranCache {
  Future<List<Surah>?> getChapters() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kChaptersKey);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((j) => Surah.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> setChapters(List<Surah> chapters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kChaptersKey, jsonEncode(chapters.map((s) => s.toJson()).toList()));
  }

  Future<List<Ayah>?> getVerses(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_kVersesKeyPrefix$surahNumber');
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((j) {
        final m = j as Map<String, dynamic>;
        return Ayah(
          surahNumber: (m['surahNumber'] as num).toInt(),
          verseNumber: (m['verseNumber'] as num).toInt(),
          verseKey: m['verseKey'] as String,
          juzNumber: (m['juzNumber'] as num?)?.toInt() ?? 0,
          textArabic: m['textArabic'] as String,
          translation: m['translation'] as String,
        );
      }).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> setVerses(int surahNumber, List<Ayah> verses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = verses
        .map((a) => {
              'surahNumber': a.surahNumber,
              'verseNumber': a.verseNumber,
              'verseKey': a.verseKey,
              'juzNumber': a.juzNumber,
              'textArabic': a.textArabic,
              'translation': a.translation,
            })
        .toList();
    await prefs.setString('$_kVersesKeyPrefix$surahNumber', jsonEncode(encoded));
  }

  Future<List<QuranBookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kBookmarksKey);
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((j) => QuranBookmark.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> setBookmarks(List<QuranBookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBookmarksKey, jsonEncode(bookmarks.map((b) => b.toJson()).toList()));
  }

  Future<QuranLastRead?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kLastReadKey);
    if (raw == null) return null;
    try {
      return QuranLastRead.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> setLastRead(QuranLastRead lastRead) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastReadKey, jsonEncode(lastRead.toJson()));
  }
}
