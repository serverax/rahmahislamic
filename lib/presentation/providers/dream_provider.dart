import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/dream_history_store.dart';
import '../../data/datasources/local/dream_loader.dart';
import '../../domain/entities/dream_symbol.dart';

final dreamLoaderProvider = Provider<DreamLoader>((ref) => DreamLoader());

final dreamHistoryStoreProvider =
    Provider<DreamHistoryStore>((ref) => DreamHistoryStore());

final dreamBundleProvider = FutureProvider<DreamSymbolBundle>((ref) async {
  return ref.watch(dreamLoaderProvider).load();
});

class DreamSubmission {
  const DreamSubmission({
    required this.dreamText,
    required this.maritalStatus,
    required this.gender,
    required this.dreamTime,
    required this.emotion,
  });

  final String dreamText;
  final String? maritalStatus;
  final String? gender;
  final String? dreamTime;
  final String? emotion;
}

/// Pure-Dart dream interpreter.
/// - Lowercases + strips diacritics (lightweight)
/// - Tokenises on whitespace
/// - Matches each symbol if any of its keywords_ar appears as a token
/// Returns matched symbols in source order.
List<DreamSymbol> interpretDream(String dreamText, List<DreamSymbol> all) {
  if (dreamText.trim().isEmpty) return const [];
  final normalized = _normalize(dreamText);
  final tokens = normalized.split(RegExp(r'\s+'));
  final tokenSet = tokens.toSet();
  final out = <DreamSymbol>[];
  for (final s in all) {
    final matched = s.keywordsAr.any((kw) {
      final n = _normalize(kw);
      // direct token match OR substring match (covers "ماءً" variants)
      return tokenSet.contains(n) || normalized.contains(n);
    });
    if (matched) out.add(s);
  }
  return out;
}

bool isBlocked(String dreamText, List<String> blockedKeywords) {
  final normalized = _normalize(dreamText);
  for (final kw in blockedKeywords) {
    if (normalized.contains(_normalize(kw))) return true;
  }
  return false;
}

String _normalize(String input) {
  // Strip Arabic diacritics, normalize hamzas, ta-marbuta, alif-maqsura.
  var s = input;
  s = s.replaceAll(RegExp(r'[ؐ-ًؚ-ٰٟۖ-ۭ]'), '');
  s = s.replaceAll('ـ', '');
  s = s
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي');
  return s.toLowerCase().trim();
}
