class QuranBookmark {
  const QuranBookmark({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahName,
    required this.createdAt,
  });

  final int surahNumber;
  final int verseNumber;
  final String surahName;
  final DateTime createdAt;

  String get verseKey => '$surahNumber:$verseNumber';

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'surahName': surahName,
        'createdAt': createdAt.toIso8601String(),
      };

  factory QuranBookmark.fromJson(Map<String, dynamic> json) => QuranBookmark(
        surahNumber: (json['surahNumber'] as num).toInt(),
        verseNumber: (json['verseNumber'] as num).toInt(),
        surahName: json['surahName'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class QuranLastRead {
  const QuranLastRead({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahName,
    required this.timestamp,
  });

  final int surahNumber;
  final int verseNumber;
  final String surahName;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'surahName': surahName,
        'timestamp': timestamp.toIso8601String(),
      };

  factory QuranLastRead.fromJson(Map<String, dynamic> json) => QuranLastRead(
        surahNumber: (json['surahNumber'] as num).toInt(),
        verseNumber: (json['verseNumber'] as num).toInt(),
        surahName: json['surahName'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class QuranSearchHit {
  const QuranSearchHit({
    required this.surahNumber,
    required this.verseNumber,
    required this.verseKey,
    required this.snippet,
    required this.translationSnippet,
  });

  final int surahNumber;
  final int verseNumber;
  final String verseKey;
  final String snippet;
  final String translationSnippet;
}
