import '../enums/meal_type.dart';

/// A single logged food entry in a day's log.
///
/// The entry **snapshots** the food name, serving label, and macro totals at
/// log time. This guarantees history never changes when the underlying food
/// record is later edited (ADR-4).
class LoggedFoodEntry {
  const LoggedFoodEntry({
    required this.id,
    this.foodId,
    required this.foodName,
    required this.mealType,
    required this.servingLabel,
    required this.servings,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.loggedAt,
  });

  /// Unique id for this entry.
  final String id;

  /// Reference to the food record, if any. Null for quick-add manual entries.
  final String? foodId;

  /// Snapshot of the food name at log time.
  final String foodName;

  /// Which meal section this entry belongs to.
  final MealType mealType;

  /// Snapshot of the serving label, e.g. "1 breast (150g)".
  final String servingLabel;

  /// How many servings were logged (can be fractional, e.g. 0.5).
  final double servings;

  /// Total grams logged (`servings × serving.grams`).
  final double grams;

  /// Snapshot macro totals for this entry.
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  /// When the entry was logged.
  final DateTime loggedAt;

  LoggedFoodEntry copyWith({
    String? id,
    String? foodId,
    String? foodName,
    MealType? mealType,
    String? servingLabel,
    double? servings,
    double? grams,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    DateTime? loggedAt,
  }) {
    return LoggedFoodEntry(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      mealType: mealType ?? this.mealType,
      servingLabel: servingLabel ?? this.servingLabel,
      servings: servings ?? this.servings,
      grams: grams ?? this.grams,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  String toString() => 'LoggedFoodEntry($foodName, ${calories}kcal, $mealType)';
}
