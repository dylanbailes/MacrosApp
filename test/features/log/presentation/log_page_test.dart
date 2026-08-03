import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/core/theme/app_theme.dart';
import 'package:macro_tracker/features/log/data/database/app_database.dart';
import 'package:macro_tracker/features/log/domain/domain.dart';
import 'package:macro_tracker/features/log/presentation/pages/log_page.dart';
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

  Future<ProviderContainer> pumpLogPage(WidgetTester tester) async {
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
          home: const LogPage(),
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

  /// Logs [e] via the repository and refreshes the day-log provider so the
  /// page re-renders (mirroring the sheet's invalidation in the real app).
  /// Refreshes the entry's own calendar day unless [date] is given.
  Future<void> logAndRefresh(
    ProviderContainer container,
    LoggedFoodEntry e, {
    DateTime? date,
  }) async {
    final repo = container.read(foodRepositoryProvider);
    await repo.logFood(e);
    container.refresh(dailyLogProvider(date ?? dayOf(e.loggedAt)));
  }

  /// A fully-populated [LoggedFoodEntry] for a given food + meal.
  LoggedFoodEntry entry({
    required String id,
    required String foodId,
    required String name,
    required MealType meal,
    required int calories,
    double protein = 0,
    double carbs = 0,
    double fat = 0,
    double servings = 1,
    double grams = 100,
    String servingLabel = '1 × 100g',
    DateTime? loggedAt,
  }) {
    return LoggedFoodEntry(
      id: id,
      foodId: foodId,
      foodName: name,
      mealType: meal,
      servingLabel: servingLabel,
      servings: servings,
      grams: grams,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      loggedAt: loggedAt ?? DateTime.now(),
    );
  }

  testWidgets('shows empty state when nothing is logged', (tester) async {
    await pumpLogPage(tester);
    await pumpUntilFound(tester, find.text('Nothing logged yet'));
    expect(find.text('Food Log'), findsOneWidget);
    expect(find.text('BREAKFAST'), findsOneWidget);
    expect(find.text('LUNCH'), findsOneWidget);
    expect(find.text('DINNER'), findsOneWidget);
    expect(find.text('SNACKS'), findsOneWidget);
  });

  testWidgets('renders logged entries grouped by meal', (tester) async {
    final container = await pumpLogPage(tester);

    await logAndRefresh(container, entry(
      id: 'e1',
      foodId: 'seed_chicken_breast',
      name: 'Chicken Breast (cooked)',
      meal: MealType.lunch,
      calories: 165,
      protein: 31,
      grams: 100,
    ));
    await logAndRefresh(container, entry(
      id: 'e2',
      foodId: 'seed_oats',
      name: 'Oats (rolled)',
      meal: MealType.breakfast,
      calories: 156,
      protein: 5,
      grams: 40,
      servings: 0.4,
    ));

    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));
    await pumpUntilFound(tester, find.text('Oats (rolled)'));

    // Each entry lives under its meal header.
    expect(find.text('BREAKFAST'), findsOneWidget);
    expect(find.text('LUNCH'), findsOneWidget);
    expect(find.text('Oats (rolled)'), findsOneWidget);
    expect(find.text('Chicken Breast (cooked)'), findsOneWidget);

    // The summary reflects real totals (156 + 165 = 321 kcal).
    expect(find.textContaining('321'), findsWidgets);
  });

  testWidgets('tapping an entry opens the sheet prefilled and saves edits',
      (tester) async {
    final container = await pumpLogPage(tester);

    await logAndRefresh(container, entry(
      id: 'e1',
      foodId: 'seed_chicken_breast',
      name: 'Chicken Breast (cooked)',
      meal: MealType.lunch,
      calories: 330,
      protein: 62,
      grams: 200,
      servings: 2,
      servingLabel: '2 × 100g',
    ));

    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));
    await tester.tap(find.text('Chicken Breast (cooked)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400)); // sheet entrance

    // Sheet opens in edit mode with the entry's meal preselected and the
    // logged quantity (2 servings) prefilled.
    expect(find.text('Save changes'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Move the entry to Dinner and save.
    await tester.tap(find.text('Dinner'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('log-food-submit')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400)); // sheet close

    // The entry is now under Dinner, quantity preserved.
    final repo = container.read(foodRepositoryProvider);
    final entries = await repo.getLogForDate(DateTime.now());
    expect(entries, hasLength(1));
    expect(entries.first.mealType, MealType.dinner);
    expect(entries.first.servings, 2);
    expect(entries.first.grams, 200);

    // Let the confirmation toast's auto-dismiss timer fire.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('deleting an entry removes it and shows an undo toast',
      (tester) async {
    final container = await pumpLogPage(tester);

    await logAndRefresh(container, entry(
      id: 'e1',
      foodId: 'seed_chicken_breast',
      name: 'Chicken Breast (cooked)',
      meal: MealType.lunch,
      calories: 165,
      protein: 31,
      grams: 100,
    ));

    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));

    // Delete via the trailing delete button, then confirm in the dialog.
    await tester.tap(find.byKey(const Key('delete-log-entry')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200)); // dialog entrance
    await tester.tap(find.text('Delete'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Entry gone from the list and from storage.
    expect(find.text('Chicken Breast (cooked)'), findsNothing);
    final repo = container.read(foodRepositoryProvider);
    final entries = await repo.getLogForDate(DateTime.now());
    expect(entries, isEmpty);

    // Undoable toast is visible.
    await pumpUntilFound(tester, find.text('Deleted Chicken Breast (cooked)'));
    expect(find.text('Undo'), findsOneWidget);

    // Tap undo → entry comes back.
    await tester.tap(find.text('Undo'));
    await tester.pump();
    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));
    final afterUndo = await repo.getLogForDate(DateTime.now());
    expect(afterUndo, hasLength(1));
    expect(afterUndo.first.foodName, 'Chicken Breast (cooked)');

    // Let the toast's auto-dismiss timer fire.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('date stepper navigates between days and shows the right entries',
      (tester) async {
    final container = await pumpLogPage(tester);
    await pumpUntilFound(tester, find.text('Nothing logged yet'));

    // Starts on today: center label is Today, no jump-to-today chip.
    expect(find.text('Today'), findsOneWidget);
    expect(find.byKey(const Key('date-today')), findsNothing);

    // Move back a day: label flips to Yesterday and a Today chip appears.
    await tester.tap(find.byKey(const Key('date-previous')));
    await tester.pump();
    await pumpUntilFound(tester, find.text('Yesterday'));
    expect(find.byKey(const Key('date-today')), findsOneWidget);

    // Log an entry dated yesterday: it should appear only on yesterday.
    final yesterday = dayOf(DateTime.now().subtract(const Duration(days: 1)));
    await logAndRefresh(
      container,
      entry(
        id: 'e1',
        foodId: 'seed_chicken_breast',
        name: 'Chicken Breast (cooked)',
        meal: MealType.lunch,
        calories: 165,
        protein: 31,
        grams: 100,
        loggedAt: yesterday,
      ),
      date: yesterday,
    );
    await tester.pump();
    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));

    // Jump back to today: yesterday's entry is no longer visible.
    await tester.tap(find.byKey(const Key('date-today')));
    await tester.pump();
    await pumpUntilFound(tester, find.text('Today'));
    expect(find.text('Chicken Breast (cooked)'), findsNothing);
    expect(find.byKey(const Key('date-today')), findsNothing);

    // The forward arrow moves to tomorrow (and the Today chip reappears).
    await tester.tap(find.byKey(const Key('date-next')));
    await tester.pump();
    await pumpUntilFound(tester, find.text('Tomorrow'));
    expect(find.byKey(const Key('date-today')), findsOneWidget);
  });
}
