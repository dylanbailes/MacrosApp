// App boot smoke test.
//
// Verifies the app builds the navigation shell and that the dashboard renders
// (its calorie ring + recent-meals now come from the real food log, so the
// test overrides the database with an in-memory executor).

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/app/router/app_router.dart';
import 'package:macro_tracker/core/theme/app_theme.dart';
import 'package:macro_tracker/features/log/data/database/app_database.dart';
import 'package:macro_tracker/features/log/presentation/providers/food_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUpAll(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDownAll(() async {
    await db.close();
  });

  testWidgets('app boots to the dashboard shell', (tester) async {
    // Tall viewport so the full dashboard sliver list is built.
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(
          title: 'Macro Tracker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: AppRouter.router,
        ),
      ),
    );
    await tester.pump();

    // Bottom navigation shell renders with all four destinations.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Log'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // The dashboard resolves from the in-memory log (empty day → 0 kcal ring
    // but the sections render). Pump until the async provider settles.
    final end = DateTime.now().add(const Duration(seconds: 4));
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.text('RECENT MEALS').evaluate().isNotEmpty) break;
    }
    expect(find.text('RECENT MEALS'), findsOneWidget);
    expect(find.text('MACROS'), findsOneWidget);
  });
}
