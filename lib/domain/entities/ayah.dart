class Ayah {
  const Ayah({
    required this.surahNumber,
    required this.verseNumber,
    required this.verseKey,
    required this.juzNumber,
    required this.textArabic,
    required this.translation,
  });

  final int surahNumber;
  final int verseNumber;
  final String verseKey;
  final int juzNumber;
  final String textArabic;
  final String translation;

  factory Ayah.fromJson(Map<String, dynamic> json, int surahNumber) {
    final translations = json['translations'] as List<dynamic>?;
    final firstTranslation = translations != null && translations.isNotEmpty
        ? (translations.first as Map<String, dynamic>)['text'] as String? ?? ''
        : '';
    return Ayah(
      surahNumber: surahNumber,
      verseNumber: (json['verse_number'] as num).toInt(),
      verseKey: json['verse_key'] as String? ?? '$surahNumber:${json['verse_number']}',
      juzNumber: (json['juz_number'] as num?)?.toInt() ?? 0,
      textArabic: json['text_uthmani'] as String? ?? json['text_imlaei'] as String? ?? '',
      translation: _stripHtml(firstTranslation),
    );
  }

  static String _stripHtml(String s) {
    final tagPattern = RegExp(r'<[^>]+>');
    final supPattern = RegExp(r'\[\d+\]');
    return s.replaceAll(tagPattern, '').replaceAll(supPattern, '').trim();
  }
}
