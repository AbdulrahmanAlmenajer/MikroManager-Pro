import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mikro_manager_pro/app.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/database/database_provider.dart';
import 'package:mikro_manager_pro/core/router/app_router.dart';
import 'package:mikro_manager_pro/features/routers/domain/routers_notifier.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('App initializes at /login when unauthenticated',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          routersStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MikroManagerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MikroManager Pro'), findsOneWidget);
    expect(find.text('تسجيل الدخول إلى راوتر الميكروتك'), findsOneWidget);
    expect(find.text('تسجيل الدخول والاتصال بالراوتر'), findsOneWidget);

    // Unmount and flush any pending stream cancel timers
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets(
      'Route guard prevents unauthenticated access to /dashboard and redirects to /login',
      (WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        routersStreamProvider.overrideWith((ref) => Stream.value([])),
      ],
    );

    final router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MikroManagerApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Attempt to navigate to protected routes
    router.go('/dashboard');
    await tester.pumpAndSettle();

    // Must be redirected back to /login
    expect(find.text('تسجيل الدخول إلى راوتر الميكروتك'), findsOneWidget);

    router.go('/hotspot');
    await tester.pumpAndSettle();
    expect(find.text('تسجيل الدخول إلى راوتر الميكروتك'), findsOneWidget);

    router.go('/vouchers');
    await tester.pumpAndSettle();
    expect(find.text('تسجيل الدخول إلى راوتر الميكروتك'), findsOneWidget);

    // Clean up
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    await tester.pump(const Duration(milliseconds: 100));
  });
}
