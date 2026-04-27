import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/quran_cache.dart';
import '../../data/datasources/remote/quran_api.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';

final quranApiProvider = Provider<QuranApi>((ref) => QuranApi());
final quranCacheProvider = Provider<QuranCache>((ref) => QuranCache());

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepositoryImpl(
    api: ref.watch(quranApiProvider),
    cache: ref.watch(quranCacheProvider),
  );
});

final chaptersProvider = FutureProvider<List<Surah>>((ref) async {
  return ref.watch(quranRepositoryProvider).getChapters();
});

final surahVersesProvider =
    FutureProvider.family.autoDispose<List<Ayah>, int>((ref, surahNumber) async {
  return ref.watch(quranRepositoryProvider).getVersesForChapter(surahNumber);
});

class BookmarksController extends StateNotifier<AsyncValue<List<QuranBookmark>>> {
  BookmarksController(this._repo) : super(const AsyncValue.loading()) {
    refresh();
  }

  final QuranRepository _repo;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final bookmarks = await _repo.getBookmarks();
      state = AsyncValue.data(bookmarks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(QuranBookmark bookmark) async {
    await _repo.addBookmark(bookmark);
    await refresh();
  }

  Future<void> remove({required int surahNumber, required int verseNumber}) async {
    await _repo.removeBookmark(surahNumber: surahNumber, verseNumber: verseNumber);
    await refresh();
  }
}

final bookmarksControllerProvider =
    StateNotifierProvider<BookmarksController, AsyncValue<List<QuranBookmark>>>((ref) {
  return BookmarksController(ref.watch(quranRepositoryProvider));
});

class LastReadController extends StateNotifier<AsyncValue<QuranLastRead?>> {
  LastReadController(this._repo) : super(const AsyncValue.loading()) {
    refresh();
  }

  final QuranRepository _repo;

  Future<void> refresh() async {
    try {
      final lastRead = await _repo.getLastRead();
      state = AsyncValue.data(lastRead);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> set(QuranLastRead lastRead) async {
    await _repo.setLastRead(lastRead);
    await refresh();
  }
}

final lastReadControllerProvider =
    StateNotifierProvider<LastReadController, AsyncValue<QuranLastRead?>>((ref) {
  return LastReadController(ref.watch(quranRepositoryProvider));
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider.autoDispose<List<QuranSearchHit>>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.length < 2) return const [];
  return ref.watch(quranRepositoryProvider).search(query);
});
