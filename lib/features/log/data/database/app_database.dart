import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// The local food database (ADR-1 / ADR-4).
///
/// Nutrition is stored per 100 g on [`Foods`]; gram-based serving options live
/// in [`ServingSizes`]; everything a user logs is snapshotted into
/// [`LoggedEntries`] so history is immutable.
@DataClassName('FoodRow')
class Foods extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get source => text()(); // FoodSource.name
  IntColumn get popularity => integer().withDefault(const Constant(0))();
  IntColumn get caloriesPer100g => integer()();
  RealColumn get proteinPer100g => real()();
  RealColumn get carbsPer100g => real()();
  RealColumn get fatPer100g => real()();
  RealColumn get fiberPer100g => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ServingSizeRow')
class ServingSizes extends Table {
  TextColumn get id => text()();
  TextColumn get foodId =>
      text().references(Foods, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
  RealColumn get grams => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MetaRow')
class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('LoggedEntryRow')
class LoggedEntries extends Table {
  TextColumn get id => text()();
  TextColumn get foodId =>
      text().nullable().references(Foods, #id, onDelete: KeyAction.setNull)();
  TextColumn get foodName => text()();
  TextColumn get mealType => text()(); // MealType.name
  TextColumn get servingLabel => text()();
  RealColumn get servings => real()();
  RealColumn get grams => real()();
  IntColumn get calories => integer()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  DateTimeColumn get loggedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// App-wide local database (the single source of truth for food data).
@DriftDatabase(tables: [Foods, ServingSizes, LoggedEntries, AppMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test constructor backed by any executor (e.g. `NativeDatabase.memory()`).
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'macro_tracker');
  }
}
