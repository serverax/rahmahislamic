import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../../domain/entities/dua.dart';

class DuasBundle {
  const DuasBundle({required this.categories, required this.items});
  final List<DuaCategory> categories;
  final List<Dua> items;

  List<Dua> forCategory(String categoryId) =>
      items.where((d) => d.categoryId == categoryId).toList();
}

class DuasLoader {
  Future<DuasBundle> load() async {
    final raw = await rootBundle.loadString('assets/data/duas.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final cats = (json['categories'] as List<dynamic>)
        .map((c) => DuaCategory.fromJson(c as Map<String, dynamic>))
        .toList();
    final items = (json['items'] as List<dynamic>)
        .map((d) => Dua.fromJson(d as Map<String, dynamic>))
        .toList();
    return DuasBundle(categories: cats, items: items);
  }
}
