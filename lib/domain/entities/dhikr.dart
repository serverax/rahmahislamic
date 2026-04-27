class DhikrCategory {
  const DhikrCategory({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.icon,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String icon;

  factory DhikrCategory.fromJson(Map<String, dynamic> json) => DhikrCategory(
        id: json['id'] as String,
        nameEn: json['name_en'] as String,
        nameAr: json['name_ar'] as String,
        icon: json['icon'] as String? ?? 'heart',
      );
}

class Dhikr {
  const Dhikr({
    required this.id,
    required this.categoryId,
    required this.arabic,
    required this.transliteration,
    required this.translationEn,
    required this.repeat,
    required this.source,
  });

  final String id;
  final String categoryId;
  final String arabic;
  final String transliteration;
  final String translationEn;
  final int repeat;
  final String source;

  factory Dhikr.fromJson(Map<String, dynamic> json) => Dhikr(
        id: json['id'] as String,
        categoryId: json['category'] as String,
        arabic: json['arabic'] as String,
        transliteration: json['transliteration'] as String? ?? '',
        translationEn: json['translation_en'] as String? ?? '',
        repeat: (json['repeat'] as num?)?.toInt() ?? 1,
        source: json['source'] as String? ?? '',
      );
}

class DivineName {
  const DivineName({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaningEn,
  });

  final int number;
  final String arabic;
  final String transliteration;
  final String meaningEn;

  factory DivineName.fromJson(Map<String, dynamic> json) => DivineName(
        number: (json['n'] as num).toInt(),
        arabic: json['ar'] as String,
        transliteration: json['tr'] as String,
        meaningEn: json['en'] as String,
      );
}
