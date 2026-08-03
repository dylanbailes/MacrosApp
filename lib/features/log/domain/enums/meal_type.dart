/// The meal categories a logged food entry can belong to.
///
/// Blueprint §3.2 defines exactly four meal sections on the Food Log screen:
/// Breakfast, Lunch, Dinner, and Snacks.
enum MealType {
  breakfast('Breakfast'),
  lunch('Lunch'),
  dinner('Dinner'),
  snacks('Snacks');

  const MealType(this.label);

  /// Human-readable display label.
  final String label;

  /// Parses a stored string (drift stores the enum `name`) back to a value.
  static MealType fromStorage(String value) {
    return MealType.values.firstWhere(
      (meal) => meal.name == value,
      orElse: () => MealType.snacks,
    );
  }
}
