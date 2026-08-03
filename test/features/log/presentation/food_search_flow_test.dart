import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/core/theme/app_theme.dart';
import 'package:macro_tracker/features/log/data/database/app_database.dart';
import 'package:macro_tracker/features/log/presentation/pages/food_search_page.dart';
import 'package:macro_tracker/features/log/presentation/providers/food_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  // One shared in-memory database for the whole file: drift's native sqlite
  // connection is process-global on Windows, so closing a per-test database
  // and immediately opening a new one can hang the next test's queries.
  setUpAll(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDownAll(() async {
    await db.close();
  });

  // Each test starts with an empty log (the seed dataset is idempotent and
  // survives across tests).
  setUp(() async {
    await db.delete(db.loggedEntries).go();
  });

  /// Pumps [FoodSearchPage] with an in-memory database override and a tall
  /// viewport so the full sheet content is visible.
  Future<ProviderContainer> pumpSearchApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const FoodSearchPage(),
        ),
      ),
    );
    return container;
  }

  /// Pumps until [finder] matches (drift queries resolve asynchronously and
  /// the skeleton shimmer animates forever, so pumpAndSettle is unusable).
  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 50));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Timed out waiting for $finder');
  }

  /// Pumps until [finder] no longer matches (e.g. the browse state was
  /// replaced by search results).
  Future<void> pumpUntilGone(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 50));
      if (finder.evaluate().isEmpty) return;
    }
    fail('Timed out waiting for $finder to disappear');
  }

  /// Types a query and lets the debounce + async search settle.
  Future<void> search(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextFormField), query);
    await tester.pump(const Duration(milliseconds: 300)); // debounce
  }

  testWidgets('shows popular foods before typing', (tester) async {
    await pumpSearchApp(tester);
    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));
    expect(find.text('POPULAR'), findsOneWidget);
  });

  testWidgets('debounced search shows results as you type', (tester) async {
    await pumpSearchApp(tester);
    await pumpUntilFound(tester, find.text('POPULAR'));

    await tester.enterText(find.byType(TextFormField), 'chicken');

    // Before the debounce elapses the query isn't applied yet.
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('POPULAR'), findsOneWidget);

    // After the debounce, results replace the browse list. Note: the result
    // text is also present in the browse list, so wait for POPULAR to be
    // gone — that is what proves the query actually applied — and then wait
    // for the freshly-loaded result row.
    await pumpUntilGone(tester, find.text('POPULAR'));
    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));
    expect(find.text('Chicken Breast (cooked)'), findsOneWidget);
  });

  testWidgets('shows empty state for a query with no matches', (tester) async {
    await pumpSearchApp(tester);
    await pumpUntilFound(tester, find.text('POPULAR'));

    await search(tester, 'zzzzzz-nope');
    await pumpUntilFound(tester, find.textContaining('No results'));
  });

  testWidgets('logs a food to a meal from the sheet', (tester) async {
    final container = await pumpSearchApp(tester);
    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));

    await search(tester, 'chicken');
    // Wait until the query applied, then tap the search result row.
    await pumpUntilGone(tester, find.text('POPULAR'));
    await tester.tap(find.text('Chicken Breast (cooked)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400)); // sheet entrance
    expect(find.text('SERVING'), findsOneWidget);
    expect(find.text('MEAL'), findsOneWidget);

    // Increase the quantity by one step (1.0 → 1.5).
    await tester.tap(find.byKey(const Key('serving-increase')));
    await tester.pump();

    // Log it.
    await tester.tap(find.byKey(const Key('log-food-submit')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400)); // sheet close

    // Entry persisted with the adjusted quantity.
    final entries =
        await container.read(foodRepositoryProvider).getLogForDate(DateTime.now());
    expect(entries, hasLength(1));
    expect(entries.first.foodName, 'Chicken Breast (cooked)');
    expect(entries.first.servings, 1.5);
    expect(entries.first.calories, greaterThan(0));

    // Let the confirmation toast's auto-dismiss timer fire.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('logs to the viewed (past) date when date navigation moved',
      (tester) async {
    final container = await pumpSearchApp(tester);
    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));

    // Pretend the Log page's date navigator moved us back a day.
    container.read(selectedDateProvider.notifier).shift(-1);

    // Log from the browse list — the sheet should stamp yesterday's date.
    await tester.tap(find.text('Chicken Breast (cooked)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400)); // sheet entrance
    await tester.tap(find.byKey(const Key('log-food-submit')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400)); // sheet close

    final yesterday = dayOf(DateTime.now().subtract(const Duration(days: 1)));
    final yesterdayEntries =
        await container.read(foodRepositoryProvider).getLogForDate(yesterday);
    expect(yesterdayEntries, hasLength(1));
    expect(yesterdayEntries.first.foodName, 'Chicken Breast (cooked)');

    // Nothing landed on today.
    final todayEntries =
        await container.read(foodRepositoryProvider).getLogForDate(DateTime.now());
    expect(todayEntries, isEmpty);

    // Let the confirmation toast's auto-dismiss timer fire.
    await tester.pump(const Duration(seconds: 3));
  });
}
