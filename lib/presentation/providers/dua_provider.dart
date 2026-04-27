import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/duas_loader.dart';

final duasLoaderProvider = Provider<DuasLoader>((ref) => DuasLoader());

final duasBundleProvider = FutureProvider<DuasBundle>((ref) async {
  return ref.watch(duasLoaderProvider).load();
});
