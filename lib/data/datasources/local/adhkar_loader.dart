import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../../domain/entities/dhikr.dart';

class AdhkarBundle {
  const AdhkarBundle({required this.categories, required this.items});
  final List<DhikrCategory> categories;
  final List<Dhikr> items;

  List<Dhikr> forCategory(String categoryId) =>
      items.where((d) => d.categoryId == categoryId).toList();
}

class AdhkarLoader {
  Future<AdhkarBundle> loadAdhkar() async {
    final raw = await rootBundle.loadString('assets/data/adhkar.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final cats = (json['categories'] as List<dynamic>)
        .map((c) => DhikrCategory.fromJson(c as Map<String, dynamic>))
        .toList();
    final items = (json['items'] as List<dynamic>)
        .map((d) => Dhikr.fromJson(d as Map<String, dynamic>))
        .toList();
    return AdhkarBundle(categories: cats, items: items);
  }

  Future<List<DivineName>> loadDivineNames() async {
    final raw = await rootBundle.loadString('assets/data/names_of_allah.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['names'] as List<dynamic>)
        .map((n) => DivineName.fromJson(n as Map<String, dynamic>))
        .toList();
  }
}
