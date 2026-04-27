import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../../domain/entities/dream_symbol.dart';

class DreamLoader {
  Future<DreamSymbolBundle> load() async {
    final raw = await rootBundle.loadString('assets/data/dream_symbols.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final symbols = ((json['symbols'] as List<dynamic>?) ?? const [])
        .map((s) => DreamSymbol.fromJson(s as Map<String, dynamic>))
        .toList();
    final blocked = ((json['blocked_keywords'] as List<dynamic>?) ?? const [])
        .cast<String>();
    final disclaimer = json['_disclaimer_required_in_ui'] as String? ??
        'هذا تفسير عام وليس حكماً مؤكداً، والله أعلم.';
    return DreamSymbolBundle(
      symbols: symbols,
      blockedKeywords: blocked,
      requiredDisclaimer: disclaimer,
    );
  }
}
