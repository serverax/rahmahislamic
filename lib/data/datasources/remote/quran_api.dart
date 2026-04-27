import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../domain/entities/ayah.dart';
import '../../../domain/entities/quran_bookmark.dart';
import '../../../domain/entities/surah.dart';
import '../../../domain/repositories/quran_repository.dart';

const String _kBase = 'https://api.quran.com/api/v4';
const int _kSahihIntlTranslationId = 131;

class QuranApi {
  QuranApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Surah>> fetchChapters({String language = 'en'}) async {
    final uri = Uri.parse('$_kBase/chapters').replace(queryParameters: {'language': language});
    final res = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw QuranException('chapters HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final chapters = body['chapters'] as List<dynamic>;
    return chapters.map((c) => Surah.fromJson(c as Map<String, dynamic>)).toList();
  }

  Future<List<Ayah>> fetchVerses({
    required int surahNumber,
    int translationId = _kSahihIntlTranslationId,
    String language = 'en',
  }) async {
    final uri = Uri.parse('$_kBase/verses/by_chapter/$surahNumber').replace(queryParameters: {
      'translations': translationId.toString(),
      'language': language,
      'fields': 'text_uthmani,verse_key,juz_number',
      'words': 'false',
      'per_page': '300',
    });
    final res = await _client.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw QuranException('verses HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final verses = body['verses'] as List<dynamic>;
    return verses
        .map((v) => Ayah.fromJson(v as Map<String, dynamic>, surahNumber))
        .toList();
  }

  Future<List<QuranSearchHit>> search(String query, {String language = 'en'}) async {
    if (query.trim().isEmpty) return const [];
    final uri = Uri.parse('$_kBase/search').replace(queryParameters: {
      'q': query,
      'size': '20',
      'page': '1',
      'language': language,
    });
    final res = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw QuranException('search HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final search = body['search'] as Map<String, dynamic>?;
    final results = (search?['results'] as List<dynamic>?) ?? const [];
    return results.map((r) {
      final m = r as Map<String, dynamic>;
      final verseKey = m['verse_key'] as String? ?? '';
      final parts = verseKey.split(':');
      final surahNum = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
      final verseNum = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      final translations = m['translations'] as List<dynamic>?;
      final transText = translations != null && translations.isNotEmpty
          ? (translations.first as Map<String, dynamic>)['text'] as String? ?? ''
          : '';
      return QuranSearchHit(
        surahNumber: surahNum,
        verseNumber: verseNum,
        verseKey: verseKey,
        snippet: m['text'] as String? ?? '',
        translationSnippet: _stripHtml(transText),
      );
    }).toList();
  }

  static String _stripHtml(String s) {
    final tagPattern = RegExp(r'<[^>]+>');
    return s.replaceAll(tagPattern, '').trim();
  }
}
