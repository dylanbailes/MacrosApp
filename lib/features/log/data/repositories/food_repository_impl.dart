import 'package:drift/drift.dart';

import '../../domain/domain.dart';
import '../database/app_database.dart';
import '../datasources/seed_food_loader.dart';

/// Drift-backed implementation of [FoodRepository].
///
/// Seeds the bundled dataset on first access (idempotent), then answers all
/// queries from the local database. Later phases layer Open Food Facts lookups
/// and smart ranking on top of this class (ADR-2 / Phase F–G).
class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl(
    this._db, {
    SeedFoodLoader seedLoader = const SeedFoodLoader(),
  }) : _seedLoader = seedLoader;

  final AppDatabase _db;
  final SeedFoodLoader _seedLoader;

  /// Guards the one-time seed so concurrent first queries don't double-import.
  Future<void>? _seeding;

  @override
  Future<List<Food>> searchFoods(String query, {int limit = 30}) async {
    await _ensureSeeded();
    final q = query.trim().toLowerCase();

    List<FoodRow> rows;
    if (q.isEmpty) {
      // Browse mode: most popular foods first.
      rows = await (_db.select(_db.foods)
            ..orderBy([
              (t) => OrderingTerm.desc(t.popularity),
              (t) => OrderingTerm.asc(t.name),
            ])
            ..limit(limit))
          .get();
    } else {
      // `LIKE` is used as a superset pre-filter — it can only *miss* nothing,
      // but `%` / `_` in the user's query act as SQL wildcards and could match
      // extra rows. The Dart filter below enforces exact literal substring
      // matching, so a query like "100%" or "_" never matches everything.
      rows = await (_db.select(_db.foods)
            ..where((t) =>
                t.name.lower().like('%$q%') | t.brand.lower().like('%$q%'))
            ..orderBy([
              (t) => OrderingTerm.desc(t.popularity),
              (t) => OrderingTerm.asc(t.name),
            ])
            ..limit(limit * 5))
          .get();
      rows = [
        for (final row in rows)
          if (row.name.toLowerCase().contains(q) ||
              (row.brand?.toLowerCase().contains(q) ?? false))
            row,
      ].take(limit).toList();
    }
    return _toFoods(rows);
  }

  @override
  Future<Food?> getFoodById(String id) async {
    await _ensureSeeded();
    final row = await (_db.select(_db.foods)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    final foods = await _toFoods([row]);
    return foods.isEmpty ? null : foods.first;
  }

  @override
  Future<Food?> getFoodByBarcode(String barcode) async {
    await _ensureSeeded();
    final normalized = barcode.trim();
    if (normalized.isEmpty) return null;
    final row = await (_db.select(_db.foods)
          ..where((t) => t.barcode.equals(normalized)))
        .getSingleOrNull();
    if (row == null) return null;
    final foods = await _toFoods([row]);
    return foods.isEmpty ? null : foods.first;
  }

  @override
  Future<List<LoggedFoodEntry>> getLogForDate(DateTime date) async {
    await _ensureSeeded();
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final rows = await (_db.select(_db.loggedEntries)
          ..where((t) =>
              t.loggedAt.isBiggerOrEqualValue(start) &
              t.loggedAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
        .get();
    return [for (final row in rows) _toEntry(row)];
  }

  @override
  Future<void> logFood(LoggedFoodEntry entry) async {
    await _ensureSeeded();
    await _db.into(_db.loggedEntries).insert(_toEntryRow(entry));
  }

  @override
  Future<void> updateLogEntry(LoggedFoodEntry entry) async {
    await _ensureSeeded();
    await _db.update(_db.loggedEntries).replace(_toEntryRow(entry));
  }

  @override
  Future<void> removeLogEntry(String entryId) async {
    await _ensureSeeded();
    await (_db.delete(_db.loggedEntries)..where((t) => t.id.equals(entryId)))
        .go();
  }

  // ── Seeding ─────────────────────────────────────────────────────────────

  static const String _seedVersionKey = 'seed_version';

  Future<void> _ensureSeeded() async {
    final pending = _seeding ??= _seedIfNeeded();
    try {
      await pending;
    } catch (_) {
      // Don't cache a failed seed: a transient error (e.g. asset load)
      // should be retried on the next call instead of failing forever.
      if (identical(_seeding, pending)) _seeding = null;
      rethrow;
    }
  }

  Future<void> _seedIfNeeded() async {
    // Import (or refresh) whenever the recorded seed version differs from the
    // bundled one, so growing the seed dataset in later phases applies to
    // existing installs too.
    final stored = await (_db.select(_db.appMeta)
          ..where((t) => t.key.equals(_seedVersionKey)))
        .getSingleOrNull();
    if (stored != null && stored.value == '${SeedFoodLoader.seedVersion}') {
      return;
    }

    final foods = await _seedLoader.loadSeedFoods();
    await _db.transaction(() async {
      await _db.batch((batch) {
        for (final food in foods) {
          batch.insert(
            _db.foods,
            FoodsCompanion.insert(
              id: food.id,
              name: food.name,
              brand: Value(food.brand),
              category: Value(food.category),
              barcode: Value(food.barcode),
              source: food.source.name,
              popularity: Value(food.popularity),
              caloriesPer100g: food.caloriesPer100g,
              proteinPer100g: food.proteinPer100g,
              carbsPer100g: food.carbsPer100g,
              fatPer100g: food.fatPer100g,
              fiberPer100g: Value(food.fiberPer100g),
            ),
            mode: InsertMode.insertOrIgnore,
          );
          for (final serving in food.servings) {
            batch.insert(
              _db.servingSizes,
              ServingSizesCompanion.insert(
                id: '${food.id}__${_slug(serving.label)}',
                foodId: food.id,
                label: serving.label,
                grams: serving.grams,
              ),
              mode: InsertMode.insertOrIgnore,
            );
          }
        }
      });

      // Record the version we've imported.
      await _db.into(_db.appMeta).insertOnConflictUpdate(
        MetaRow(
          key: _seedVersionKey,
          value: '${SeedFoodLoader.seedVersion}',
        ),
      );
    });
  }

  // ── Mapping ─────────────────────────────────────────────────────────────

  Future<List<Food>> _toFoods(List<FoodRow> rows) async {
    if (rows.isEmpty) return const [];
    final ids = [for (final row in rows) row.id];
    final servingRows = await (_db.select(_db.servingSizes)
          ..where((t) => t.foodId.isIn(ids)))
        .get();

    final byFood = <String, List<ServingSize>>{};
    for (final row in servingRows) {
      byFood.putIfAbsent(row.foodId, () => []).add(
            ServingSize(label: row.label, grams: row.grams),
          );
    }

    return [
      for (final row in rows)
        Food(
          id: row.id,
          name: row.name,
          brand: row.brand,
          category: row.category,
          barcode: row.barcode,
          source: _foodSource(row.source),
          popularity: row.popularity,
          caloriesPer100g: row.caloriesPer100g,
          proteinPer100g: row.proteinPer100g,
          carbsPer100g: row.carbsPer100g,
          fatPer100g: row.fatPer100g,
          fiberPer100g: row.fiberPer100g,
          servings: byFood[row.id] ?? const [],
        ),
    ];
  }

  LoggedEntryRow _toEntryRow(LoggedFoodEntry entry) {
    return LoggedEntryRow(
      id: entry.id,
      foodId: entry.foodId,
      foodName: entry.foodName,
      mealType: entry.mealType.name,
      servingLabel: entry.servingLabel,
      servings: entry.servings,
      grams: entry.grams,
      calories: entry.calories,
      protein: entry.protein,
      carbs: entry.carbs,
      fat: entry.fat,
      loggedAt: entry.loggedAt,
    );
  }

  LoggedFoodEntry _toEntry(LoggedEntryRow row) {
    return LoggedFoodEntry(
      id: row.id,
      foodId: row.foodId,
      foodName: row.foodName,
      mealType: MealType.fromStorage(row.mealType),
      servingLabel: row.servingLabel,
      servings: row.servings,
      grams: row.grams,
      calories: row.calories,
      protein: row.protein,
      carbs: row.carbs,
      fat: row.fat,
      loggedAt: row.loggedAt,
    );
  }

  FoodSource _foodSource(String value) {
    return FoodSource.values.firstWhere(
      (source) => source.name == value,
      orElse: () => FoodSource.database,
    );
  }

  static String _slug(String label) {
    return label
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+$'), '');
  }
}
