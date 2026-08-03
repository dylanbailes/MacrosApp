import '../enums/meal_type.dart';
import 'logged_food_entry.dart';

/// The complete set of logged entries for a single calendar day, with
/// convenience totals used by the Log screen's day summary and meal sections.
class DayLog {
  const DayLog({
    required this.date,
    required this.entries,
  });

  /// The calendar day these entries belong to (time component ignored).
  final DateTime date;

  final List<LoggedFoodEntry> entries;

  /// Entries belonging to a single meal section, sorted by log time.
  List<LoggedFoodEntry> forMeal(MealType meal) =>
      entries.where((e) => e.mealType == meal).toList();

  int get totalCalories => entries.fold(0, (sum, e) => sum + e.calories);
  double get totalProtein => entries.fold(0, (sum, e) => sum + e.protein);
  double get totalCarbs => entries.fold(0, (sum, e) => sum + e.carbs);
  double get totalFat => entries.fold(0, (sum, e) => sum + e.fat);

  bool get isEmpty => entries.isEmpty;
}
