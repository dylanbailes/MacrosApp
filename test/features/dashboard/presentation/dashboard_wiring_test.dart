import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/core/theme/app_theme.dart';
import 'package:macro_tracker/core/widgets/app_metric_tile.dart';
import 'package:macro_tracker/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:macro_tracker/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:macro_tracker/features/log/data/database/app_database.dart';
import 'package:macro_tracker/features/log/domain/domain.dart';
import 'package:macro_tracker/features/log/presentation/providers/food_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  // One shared in-memory database for the whole file (drift's native sqlite
  // connection is process-global on Windows — see food_search_flow_test).
  setUpAll(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDownAll(() async {
    await db.close();
  });

  setUp(() async {
    await db.delete(db.loggedEntries).go();
  });

  Future<ProviderContainer> pumpDashboard(WidgetTester tester) async {
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
          home: const DashboardPage(),
        ),
      ),
    );
    return container;
  }

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

  /// The value text inside the [AppMetricTile] with the given uppercase label
  /// (e.g. 'PROTEIN'), so macro assertions can't collide with other numerals
  /// elsewhere on the dashboard.
  Finder macroTileValue(String label, String value) {
    return find.descendant(
      of: find.ancestor(
        of: find.text(label),
        matching: find.byType(AppMetricTile),
      ),
      matching: find.text(value),
    );
  }

  /// The value text inside the weekly-overview stat with the given uppercase
  /// label (the stat's value and label live in one Column).
  Finder weeklyStatValue(String label, String value) {
    return find.descendant(
      of: find.ancestor(
        of: find.text(label),
        matching: find.byType(Column),
      ),
      matching: find.text(value),
    );
  }

  LoggedFoodEntry entry({
    required String id,
    required String name,
    required MealType meal,
    required int calories,
    double protein = 0,
    double carbs = 0,
    double fat = 0,
    DateTime? loggedAt,
  }) {
    return LoggedFoodEntry(
      id: id,
      foodId: 'seed_$id',
      foodName: name,
      mealType: meal,
      servingLabel: '1 × 100g',
      servings: 1,
      grams: 100,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      loggedAt: loggedAt ?? DateTime.now(),
    );
  }

  testWidgets('shows zeroed totals when nothing is logged', (tester) async {
    await pumpDashboard(tester);
    // Dashboard resolves to an empty day log: ring shows 0, meals empty.
    await pumpUntilFound(tester, find.text('RECENT MEALS'));
    expect(find.text('MACROS'), findsOneWidget);
    expect(find.text('of 2200 kcal'), findsOneWidget);
  });

  testWidgets('reflects logged calories, macros, and recent meals',
      (tester) async {
    final container = await pumpDashboard(tester);
    final repo = container.read(foodRepositoryProvider);

    await repo.logFood(entry(
      id: 'chicken',
      name: 'Chicken Breast (cooked)',
      meal: MealType.lunch,
      calories: 330,
      protein: 62,
      carbs: 0,
      fat: 7,
    ));
    await repo.logFood(entry(
      id: 'oats',
      name: 'Oats (rolled)',
      meal: MealType.breakfast,
      calories: 156,
      protein: 5,
      carbs: 27,
      fat: 3,
    ));

    // Refresh the day-log provider so the dashboard picks up the new data.
    container.refresh(dailyLogProvider(dayOf(DateTime.now())));

    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));
    await pumpUntilFound(tester, find.text('Oats (rolled)'));

    // Calorie ring shows the real total (330 + 156 = 486).
    await pumpUntilFound(tester, find.text('486'));

    // Macro tiles show real totals.
    expect(macroTileValue('PROTEIN', '67'), findsOneWidget); // 62 + 5
    expect(macroTileValue('CARBS', '27'), findsOneWidget);
    expect(macroTileValue('FAT', '10'), findsOneWidget); // 7 + 3

    // Both entries appear in Recent Meals.
    expect(find.text('Chicken Breast (cooked)'), findsOneWidget);
    expect(find.text('Oats (rolled)'), findsOneWidget);
  });

  testWidgets('follows the shared date navigator to a past day',
      (tester) async {
    final container = await pumpDashboard(tester);
    final repo = container.read(foodRepositoryProvider);
    final yesterday = dayOf(DateTime.now().subtract(const Duration(days: 1)));

    // Log an entry dated yesterday, then move the shared viewed date back a
    // day — the dashboard should now describe yesterday.
    await repo.logFood(entry(
      id: 'y-chicken',
      name: 'Chicken Breast (cooked)',
      meal: MealType.lunch,
      calories: 330,
      protein: 62,
      carbs: 0,
      fat: 7,
      loggedAt: yesterday,
    ));
    container.refresh(dailyLogProvider(yesterday));
    container.read(selectedDateProvider.notifier).shift(-1);
    await tester.pump();

    await pumpUntilFound(tester, find.text('Chicken Breast (cooked)'));
    await pumpUntilFound(tester, find.text('330'));
    expect(macroTileValue('PROTEIN', '62'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
  });

  testWidgets('weekly overview reflects real 7-day log totals', (tester) async {
    final container = await pumpDashboard(tester);
    final repo = container.read(foodRepositoryProvider);
    final today = dayOf(DateTime.now());

    // Three known days; the rest of the week stays empty.
    await repo.logFood(entry(
      id: 'w-today',
      name: 'Today meal',
      meal: MealType.dinner,
      calories: 2200,
      loggedAt: today,
    ));
    await repo.logFood(entry(
      id: 'w-d2',
      name: 'Two days ago',
      meal: MealType.lunch,
      calories: 2400,
      loggedAt: dayOf(today.subtract(const Duration(days: 2))),
    ));
    await repo.logFood(entry(
      id: 'w-d4',
      name: 'Four days ago',
      meal: MealType.breakfast,
      calories: 1000,
      loggedAt: dayOf(today.subtract(const Duration(days: 4))),
    ));

    // Refresh the touched days so the dashboard rebuilds with real data.
    for (final day in [
      today,
      dayOf(today.subtract(const Duration(days: 2))),
      dayOf(today.subtract(const Duration(days: 4))),
    ]) {
      container.refresh(dailyLogProvider(day));
    }

    // Avg calories = (2200 + 2400 + 1000) / 7 = 800. Goal days = 2/7 (2200
    // and 2400 meet the 2200 target). Streak = 1 (today hits, yesterday is
    // empty). Protein is 0 everywhere.
    await pumpUntilFound(tester, weeklyStatValue('AVG CALORIES', '800'));
    expect(weeklyStatValue('AVG PROTEIN', '0g'), findsOneWidget);
    expect(weeklyStatValue('GOAL DAYS', '2/7'), findsOneWidget);

    // The Streak card is fed the same real week: current streak matches the
    // weekly stat and exactly 2 of the 7 day-dots are lit.
    final summary = container.read(dashboardProvider).value!;
    expect(summary.currentStreak, 1);
    expect(summary.weeklyGoalDays, [false, false, false, false, true, false, true]);
  });
}
