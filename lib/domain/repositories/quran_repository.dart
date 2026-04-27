import '../entities/ayah.dart';
import '../entities/quran_bookmark.dart';
import '../entities/surah.dart';

abstract class QuranRepository {
  Future<List<Surah>> getChapters();
  Future<List<Ayah>> getVersesForChapter(int surahNumber);
  Future<List<QuranSearchHit>> search(String query);

  Future<List<QuranBookmark>> getBookmarks();
  Future<void> addBookmark(QuranBookmark bookmark);
  Future<void> removeBookmark({required int surahNumber, required int verseNumber});
  Future<bool> isBookmarked({required int surahNumber, required int verseNumber});

  Future<QuranLastRead?> getLastRead();
  Future<void> setLastRead(QuranLastRead lastRead);
}

class QuranException implements Exception {
  QuranException(this.message);
  final String message;
  @override
  String toString() => 'QuranException: $message';
}
