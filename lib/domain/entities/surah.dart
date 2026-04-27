enum RevelationPlace { meccan, medinan }

class Surah {
  const Surah({
    required this.number,
    required this.nameSimple,
    required this.nameArabic,
    required this.translatedName,
    required this.versesCount,
    required this.revelationPlace,
    required this.revelationOrder,
  });

  final int number;
  final String nameSimple;
  final String nameArabic;
  final String translatedName;
  final int versesCount;
  final RevelationPlace revelationPlace;
  final int revelationOrder;

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: (json['id'] as num).toInt(),
        nameSimple: json['name_simple'] as String,
        nameArabic: json['name_arabic'] as String,
        translatedName: (json['translated_name'] as Map<String, dynamic>?)?['name'] as String? ?? '',
        versesCount: (json['verses_count'] as num).toInt(),
        revelationPlace: (json['revelation_place'] as String?) == 'madinah'
            ? RevelationPlace.medinan
            : RevelationPlace.meccan,
        revelationOrder: (json['revelation_order'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': number,
        'name_simple': nameSimple,
        'name_arabic': nameArabic,
        'translated_name': {'name': translatedName},
        'verses_count': versesCount,
        'revelation_place': revelationPlace == RevelationPlace.medinan ? 'madinah' : 'makkah',
        'revelation_order': revelationOrder,
      };
}
