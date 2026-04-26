import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rahma_app/main.dart';

void main() {
  testWidgets('App boots and shows splash branding', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: RahmaApp()));
    await tester.pump();

    expect(find.text('Rahma'), findsOneWidget);
    expect(find.text('رحمة'), findsOneWidget);
  });
}
