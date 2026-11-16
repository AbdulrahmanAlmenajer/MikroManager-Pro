import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mikro_manager_pro/main.dart';

void main() {
  testWidgets('App smoke test initializes properly', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MikroManagerApp()));
    await tester.pump();

    expect(find.byType(MikroManagerApp), findsOneWidget);
    expect(find.text('الرئيسية'), findsOneWidget);
  });
}
