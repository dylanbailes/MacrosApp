import 'serving_size.dart';

/// Where a food record came from. `database` covers both bundled seed data
/// and (in later phases) imported Open Food Facts products.
enum FoodSource { database, custom, recipe, barcode }

/// A food item with its nutrition expressed **per 100 g**.
///
/// Per-100 g matches the Open Food Facts data model (`*_100g` fields), so
/// bundled database imports and live API lookups map onto this entity without
/// conversion. Adjustable serving sizes are derived from [`ServingSize`].
class Food {
  const Food({
    required this.id,
    required this.name,
    this.brand,
    this.category,
    this.barcode,
    this.source = FoodSource.database,
    this.popularity = 0,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.fiberPer100g,
    this.servings = const [],
  });

  /// Stable unique id (seed ids are deterministic slugs; custom foods use ids
  /// generated at creation time).
  final String id;
  final String name;

  /// Optional brand name for branded foods.
  final String? brand;

  /// Optional category label, e.g. "Protein", "Grains & Carbs".
  final String? category;

  /// Optional GTIN/EAN/UPC barcode for barcode scanning.
  final String? barcode;

  final FoodSource source;

  /// Search-ranking weight; higher values surface first.
  final int popularity;

  // Nutrition per 100 g.
  final int caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double? fiberPer100g;

  /// Available serving options. May be empty for manually created foods.
  final List<ServingSize> servings;

  /// "Name · Brand" when a brand is present, otherwise just the name.
  String get displayName =>
      (brand == null || brand!.isEmpty) ? name : '$name · $brand';

  @override
  String toString() => 'Food($id, $displayName)';
}
