/// A single serving option for a food, expressed in grams.
///
/// All nutrition is stored per 100 g, so a serving is simply `{label, grams}`.
/// A logged amount is `servings × serving.grams`, which makes adjustable
/// serving sizes and quick-add quantities trivial to compute.
class ServingSize {
  const ServingSize({
    required this.label,
    required this.grams,
  });

  /// Human-readable label, e.g. "1 breast (150g)", "1 cup", "100g".
  final String label;

  /// Weight of this serving in grams.
  final double grams;

  @override
  bool operator ==(Object other) =>
      other is ServingSize && other.label == label && other.grams == grams;

  @override
  int get hashCode => Object.hash(label, grams);

  @override
  String toString() => 'ServingSize($label, ${grams}g)';
}
