class DreamSymbol {
  const DreamSymbol({
    required this.id,
    required this.keywordsAr,
    required this.category,
    required this.meaningGeneralAr,
    required this.meaningSafeAr,
    required this.sourceAttribution,
  });

  final String id;
  final List<String> keywordsAr;
  final String category;
  final String meaningGeneralAr;
  final String meaningSafeAr;
  final String sourceAttribution;

  factory DreamSymbol.fromJson(Map<String, dynamic> json) => DreamSymbol(
        id: json['id'] as String,
        keywordsAr: ((json['keywords_ar'] as List<dynamic>?) ?? const [])
            .cast<String>(),
        category: json['category'] as String? ?? '',
        meaningGeneralAr: json['meaning_general_ar'] as String? ?? '',
        meaningSafeAr: json['meaning_safe_ar'] as String? ?? '',
        sourceAttribution: json['source_attribution'] as String? ?? '',
      );
}

class DreamSymbolBundle {
  const DreamSymbolBundle({
    required this.symbols,
    required this.blockedKeywords,
    required this.requiredDisclaimer,
  });

  final List<DreamSymbol> symbols;
  final List<String> blockedKeywords;
  final String requiredDisclaimer;
}

class DreamInterpretation {
  const DreamInterpretation({
    required this.dreamText,
    required this.matchedSymbols,
    required this.disclaimer,
    required this.timestamp,
  });

  final String dreamText;
  final List<DreamSymbol> matchedSymbols;
  final String disclaimer;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'dreamText': dreamText,
        'matchedSymbolIds': matchedSymbols.map((s) => s.id).toList(),
        'timestamp': timestamp.toIso8601String(),
      };

  factory DreamInterpretation.fromJson(
    Map<String, dynamic> json,
    Map<String, DreamSymbol> symbolsById,
    String disclaimer,
  ) =>
      DreamInterpretation(
        dreamText: json['dreamText'] as String,
        matchedSymbols: ((json['matchedSymbolIds'] as List<dynamic>?) ?? const [])
            .map((id) => symbolsById[id])
            .whereType<DreamSymbol>()
            .toList(),
        disclaimer: disclaimer,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

enum DreamSubmissionResult { ok, blockedContent, empty, dailyLimitHit }

class DreamException implements Exception {
  DreamException(this.code, this.message);
  final DreamSubmissionResult code;
  final String message;
  @override
  String toString() => 'DreamException($code): $message';
}
