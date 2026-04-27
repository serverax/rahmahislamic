import '../../domain/entities/ayah.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/local/quran_cache.dart';
import '../datasources/remote/quran_api.dart';

class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl({required this.api, required this.cache});

  final QuranApi api;
  final QuranCache cache;

  @override
  Future<List<Surah>> getChapters() async {
    final cached = await cache.getChapters();
    if (cached != null && cached.isNotEmpty) return cached;
    final fresh = await api.fetchChapters();
    await cache.setChapters(fresh);
    return fresh;
  }

  @override
  Future<List<Ayah>> getVersesForChapter(int surahNumber) async {
    final cached = await cache.getVerses(surahNumber);
    if (cached != null && cached.isNotEmpty) return cached;
    final fresh = await api.fetchVerses(surahNumber: surahNumber);
    await cache.setVerses(surahNumber, fresh);
    return fresh;
  }

  @override
  Future<List<QuranSearchHit>> search(String query) => api.search(query);

  @override
  Future<List<QuranBookmark>> getBookmarks() => cache.getBookmarks();

  @override
  Future<void> addBookmark(QuranBookmark bookmark) async {
    final all = List<QuranBookmark>.from(await cache.getBookmarks());
    all.removeWhere(
      (b) => b.surahNumber == bookmark.surahNumber && b.verseNumber == bookmark.verseNumber,
    );
    all.add(bookmark);
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await cache.setBookmarks(all);
  }

  @override
  Future<void> removeBookmark({required int surahNumber, required int verseNumber}) async {
    final all = List<QuranBookmark>.from(await cache.getBookmarks());
    all.removeWhere((b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber);
    await cache.setBookmarks(all);
  }

  @override
  Future<bool> isBookmarked({required int surahNumber, required int verseNumber}) async {
    final all = await cache.getBookmarks();
    return all.any((b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber);
  }

  @override
  Future<QuranLastRead?> getLastRead() => cache.getLastRead();

  @override
  Future<void> setLastRead(QuranLastRead lastRead) => cache.setLastRead(lastRead);
}
