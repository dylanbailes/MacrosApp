import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/domain.dart';

/// Loads the bundled seed food dataset (`assets/data/seed_foods.json`).
///
/// This is the offline core of the food database (ADR-2). The dataset grows
/// over time; later phases replace it with a bundled Open Food Facts export
/// built into a pre-indexed SQLite bundle.
class SeedFoodLoader {
  const SeedFoodLoader();

  static const String assetPath = 'assets/data/seed_foods.json';

  /// Bump when the seed dataset changes so existing installs re-import the
  /// new foods (the repository stores this version in `AppMeta`).
  static const int seedVersion = 1;

  /// Parses the bundled JSON into domain [Food] entities.
  Future<List<Food>> loadSeedFoods() async {
    final raw = await rootBundle.loadString(assetPath);
    return parseSeedFoods(raw);
  }

  /// Pure parser, separated from asset loading so it is unit-testable.
  static List<Food> parseSeedFoods(String rawJson) {
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final foods = decoded['foods'] as List<dynamic>;
    return [
      for (final item in foods) _fromJson(item as Map<String, dynamic>),
    ];
  }

  static Food _fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      category: json['category'] as String?,
      barcode: json['barcode'] as String?,
      source: FoodSource.database,
      popularity: (json['popularity'] as num?)?.toInt() ?? 0,
      caloriesPer100g: (json['caloriesPer100g'] as num).toInt(),
      proteinPer100g: (json['proteinPer100g'] as num).toDouble(),
      carbsPer100g: (json['carbsPer100g'] as num).toDouble(),
      fatPer100g: (json['fatPer100g'] as num).toDouble(),
      fiberPer100g: (json['fiberPer100g'] as num?)?.toDouble(),
      servings: [
        for (final serving in (json['servings'] as List<dynamic>? ?? const []))
          ServingSize(
            label: (serving as Map<String, dynamic>)['label'] as String,
            grams: (serving['grams'] as num).toDouble(),
          ),
      ],
    );
  }
}
