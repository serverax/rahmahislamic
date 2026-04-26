class DailyQuote {
  const DailyQuote({
    required this.arabic,
    required this.english,
    required this.referenceEn,
    required this.referenceAr,
  });

  final String arabic;
  final String english;
  final String referenceEn;
  final String referenceAr;
}

class DailyQuotes {
  DailyQuotes._();

  static const List<DailyQuote> all = [
    DailyQuote(
      arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      english: 'Indeed, with hardship comes ease.',
      referenceEn: 'Quran 94:6',
      referenceAr: 'الشرح ٦',
    ),
    DailyQuote(
      arabic: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
      english: 'Allah does not burden a soul beyond that it can bear.',
      referenceEn: 'Quran 2:286',
      referenceAr: 'البقرة ٢٨٦',
    ),
    DailyQuote(
      arabic: 'وَاصْبِرُوا ۚ إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
      english: 'Be patient. Indeed, Allah is with the patient.',
      referenceEn: 'Quran 8:46',
      referenceAr: 'الأنفال ٤٦',
    ),
    DailyQuote(
      arabic: 'وَهُوَ مَعَكُمْ أَيْنَ مَا كُنْتُمْ',
      english: 'And He is with you wherever you are.',
      referenceEn: 'Quran 57:4',
      referenceAr: 'الحديد ٤',
    ),
    DailyQuote(
      arabic: 'وَمَنْ يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
      english: 'Whoever relies upon Allah, He is sufficient for him.',
      referenceEn: 'Quran 65:3',
      referenceAr: 'الطلاق ٣',
    ),
    DailyQuote(
      arabic: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      english: 'Verily, in the remembrance of Allah do hearts find rest.',
      referenceEn: 'Quran 13:28',
      referenceAr: 'الرعد ٢٨',
    ),
    DailyQuote(
      arabic: 'وَبَشِّرِ الصَّابِرِينَ',
      english: 'And give good tidings to the patient.',
      referenceEn: 'Quran 2:155',
      referenceAr: 'البقرة ١٥٥',
    ),
    DailyQuote(
      arabic: 'إِنَّ اللَّهَ يُحِبُّ الْمُحْسِنِينَ',
      english: 'Indeed, Allah loves those who do good.',
      referenceEn: 'Quran 2:195',
      referenceAr: 'البقرة ١٩٥',
    ),
    DailyQuote(
      arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
      english: 'So remember Me; I will remember you.',
      referenceEn: 'Quran 2:152',
      referenceAr: 'البقرة ١٥٢',
    ),
  ];

  static DailyQuote forDate(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(start).inDays;
    return all[dayOfYear.abs() % all.length];
  }
}
