class DuaCategory {
  const DuaCategory({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.icon,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String icon;

  factory DuaCategory.fromJson(Map<String, dynamic> json) => DuaCategory(
        id: json['id'] as String,
        nameEn: json['name_en'] as String,
        nameAr: json['name_ar'] as String,
        icon: json['icon'] as String? ?? 'heart',
      );
}

class Dua {
  const Dua({
    required this.id,
    required this.categoryId,
    required this.arabic,
    required this.transliteration,
    required this.translationEn,
    required this.source,
  });

  final String id;
  final String categoryId;
  final String arabic;
  final String transliteration;
  final String translationEn;
  final String source;

  factory Dua.fromJson(Map<String, dynamic> json) => Dua(
        id: json['id'] as String,
        categoryId: json['category'] as String,
        arabic: json['arabic'] as String,
        transliteration: json['transliteration'] as String? ?? '',
        translationEn: json['translation_en'] as String? ?? '',
        source: json['source'] as String? ?? '',
      );
}
