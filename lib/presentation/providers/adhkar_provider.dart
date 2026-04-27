import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/adhkar_loader.dart';
import '../../data/datasources/local/tasbih_store.dart';
import '../../domain/entities/dhikr.dart';

final adhkarLoaderProvider = Provider<AdhkarLoader>((ref) => AdhkarLoader());

final adhkarBundleProvider = FutureProvider<AdhkarBundle>((ref) async {
  return ref.watch(adhkarLoaderProvider).loadAdhkar();
});

final divineNamesProvider = FutureProvider<List<DivineName>>((ref) async {
  return ref.watch(adhkarLoaderProvider).loadDivineNames();
});

final tasbihStoreProvider = Provider<TasbihStore>((ref) => TasbihStore());

class TasbihPhrase {
  const TasbihPhrase({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translationEn,
    this.target,
  });
  final String id;
  final String arabic;
  final String transliteration;
  final String translationEn;
  final int? target;
}

class TasbihPhrases {
  TasbihPhrases._();
  static const all = <TasbihPhrase>[
    TasbihPhrase(
      id: 'subhan_allah',
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'Subhan Allah',
      translationEn: 'Glory is to Allah',
      target: 33,
    ),
    TasbihPhrase(
      id: 'alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      translationEn: 'Praise is to Allah',
      target: 33,
    ),
    TasbihPhrase(
      id: 'allahu_akbar',
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      translationEn: 'Allah is the Greatest',
      target: 34,
    ),
    TasbihPhrase(
      id: 'la_ilaha_illa_allah',
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'La ilaha illa Allah',
      translationEn: 'There is no god but Allah',
      target: 100,
    ),
    TasbihPhrase(
      id: 'astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullah',
      translationEn: 'I seek the forgiveness of Allah',
      target: 100,
    ),
    TasbihPhrase(
      id: 'la_hawla',
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      translationEn: 'There is no power and no strength except with Allah',
      target: 100,
    ),
  ];

  static TasbihPhrase byIdOrFirst(String? id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return all.first;
  }
}

class TasbihState {
  const TasbihState({required this.phrase, required this.count, required this.loading});
  final TasbihPhrase phrase;
  final int count;
  final bool loading;

  TasbihState copyWith({TasbihPhrase? phrase, int? count, bool? loading}) =>
      TasbihState(
        phrase: phrase ?? this.phrase,
        count: count ?? this.count,
        loading: loading ?? this.loading,
      );
}

class TasbihController extends StateNotifier<TasbihState> {
  TasbihController(this._store)
      : super(TasbihState(phrase: TasbihPhrases.all.first, count: 0, loading: true)) {
    _bootstrap();
  }

  final TasbihStore _store;

  Future<void> _bootstrap() async {
    final selectedId = await _store.getSelectedPhrase();
    final phrase = TasbihPhrases.byIdOrFirst(selectedId);
    final count = await _store.getCount(phrase.id);
    state = TasbihState(phrase: phrase, count: count, loading: false);
  }

  Future<void> selectPhrase(TasbihPhrase phrase) async {
    await _store.setSelectedPhrase(phrase.id);
    final count = await _store.getCount(phrase.id);
    state = state.copyWith(phrase: phrase, count: count);
  }

  Future<void> increment() async {
    await _store.increment(state.phrase.id);
    state = state.copyWith(count: state.count + 1);
  }

  Future<void> reset() async {
    await _store.reset(state.phrase.id);
    state = state.copyWith(count: 0);
  }
}

final tasbihControllerProvider =
    StateNotifierProvider<TasbihController, TasbihState>((ref) {
  return TasbihController(ref.watch(tasbihStoreProvider));
});
