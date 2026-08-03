import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/features/log/data/database/app_database.dart';
import 'package:macro_tracker/features/log/data/datasources/seed_food_loader.dart';
import 'package:macro_tracker/features/log/data/repositories/food_repository_impl.dart';
import 'package:macro_tracker/features/log/domain/domain.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late FoodRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = FoodRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('seed data', () {
    test('seeds the bundled dataset on first search', () async {
      final results = await repository.searchFoods('chicken');
      expect(results, isNotEmpty);
      expect(results.first.name, contains('Chicken'));
    });

    test('search is case-insensitive', () async {
      final results = await repository.searchFoods('CHICKEN BREAST');
      expect(results, isNotEmpty);
      expect(results.first.name, contains('Chicken Breast'));
    });

    test('search matches partial words', () async {
      final results = await repository.searchFoods('breast');
      expect(results, isNotEmpty);
    });

    test('empty query returns foods ordered by popularity', () async {
      final results = await repository.searchFoods('');
      expect(results, isNotEmpty);
      // "Chicken Breast (cooked)" is the highest-popularity seed.
      expect(results.first.name, contains('Chicken Breast'));
    });

    test('unknown query returns empty list', () async {
      final results = await repository.searchFoods('zzzzzz-not-a-food');
      expect(results, isEmpty);
    });

    test('search treats LIKE wildcards literally', () async {
      // '_' matches nothing: no seed food name contains an underscore.
      expect(await repository.searchFoods('_'), isEmpty);

      // '%' returns only foods whose names literally contain a '%' — not the
      // whole database (which is what an unescaped LIKE would return).
      final percentResults = await repository.searchFoods('%');
      expect(percentResults, isNotEmpty);
      expect(percentResults.length, lessThan(10));
      for (final food in percentResults) {
        expect(food.name.contains('%'), isTrue);
      }

      // No food name contains the substring "100%" literally.
      expect(await repository.searchFoods('100%'), isEmpty);
    });

    test('seeding is idempotent across calls', () async {
      // First repository call triggers the one-time seed.
      await repository.searchFoods('egg');
      final before = (await (db.select(db.foods)).get()).length;
      expect(before, greaterThan(0));

      await repository.searchFoods('egg');
      await repository.searchFoods('rice');
      final after = (await (db.select(db.foods)).get()).length;

      // Re-seeding never duplicates rows.
      expect(after, before);
    });

    test('food exposes its serving sizes', () async {
      final food = await repository.getFoodById('seed_eggs');
      expect(food, isNotNull);
      expect(food!.servings, isNotEmpty);
      expect(food.servings.first.grams, greaterThan(0));
      expect(food.caloriesPer100g, greaterThan(0));
    });
  });

  group('barcode lookup', () {
    test('returns null when no food has the barcode', () async {
      final food = await repository.getFoodByBarcode('3017624010701');
      expect(food, isNull);
    });

    test('returns null for a blank barcode', () async {
      expect(await repository.getFoodByBarcode('   '), isNull);
    });
  });

  group('logging', () {
    test('log, read, update and delete an entry', () async {
      final now = DateTime(2026, 8, 3, 8, 30);
      final entry = LoggedFoodEntry(
        id: 'e1',
        foodId: 'seed_eggs',
        foodName: 'Eggs (whole)',
        mealType: MealType.breakfast,
        servingLabel: '2 eggs (100g)',
        servings: 1,
        grams: 100,
        calories: 155,
        protein: 13,
        carbs: 1.1,
        fat: 11,
        loggedAt: now,
      );

      await repository.logFood(entry);

      final dayLog = await repository.getLogForDate(now);
      expect(dayLog, hasLength(1));
      expect(dayLog.first.foodName, 'Eggs (whole)');
      expect(dayLog.first.mealType, MealType.breakfast);

      // Update: move the entry to the Lunch meal.
      await repository.updateLogEntry(entry.copyWith(mealType: MealType.lunch));
      final updated = await repository.getLogForDate(now);
      expect(updated.first.mealType, MealType.lunch);

      // Delete.
      await repository.removeLogEntry(entry.id);
      expect(await repository.getLogForDate(now), isEmpty);
    });

    test('log entries are scoped to their calendar day', () async {
      await repository.logFood(
        LoggedFoodEntry(
          id: 'e2',
          foodName: 'Banana',
          mealType: MealType.snacks,
          servingLabel: '1 medium (118g)',
          servings: 1,
          grams: 118,
          calories: 105,
          protein: 1.1,
          carbs: 27,
          fat: 0.3,
          loggedAt: DateTime(2026, 8, 3, 12, 0),
        ),
      );

      expect(
        await repository.getLogForDate(DateTime(2026, 8, 4)),
        isEmpty,
      );
      expect(
        await repository.getLogForDate(DateTime(2026, 8, 3, 23, 59)),
        hasLength(1),
      );
    });
  });

  group('seed parser', () {
    test('parses seed JSON and applies sensible defaults', () {
      const raw = '''
      {
        "foods": [
          {
            "id": "t1",
            "name": "Test Food",
            "category": "Protein",
            "caloriesPer100g": 100,
            "proteinPer100g": 10,
            "carbsPer100g": 5,
            "fatPer100g": 2,
            "servings": [
              {"label": "100g", "grams": 100},
              {"label": "200g", "grams": 200}
            ]
          }
        ]
      }
      ''';

      final foods = SeedFoodLoader.parseSeedFoods(raw);
      expect(foods, hasLength(1));
      expect(foods.first.name, 'Test Food');
      expect(foods.first.source, FoodSource.database);
      expect(foods.first.servings, hasLength(2));
      expect(foods.first.popularity, 0);
    });
  });
}
