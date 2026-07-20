// Path: constants\app_border_radius.dart
/// Border radius constants for consistent styling throughout the application.
///
/// Design philosophy: Smooth, modern, large curves inspired by Nothing OS.
/// Reference: Visual Design Specification §5 — Border Radius
class AppBorderRadius {
  AppBorderRadius._();

  /// No border radius
  static const double none = 0.0;

  /// Extra small radius (6dp) — Chips, tags, small pills
  static const double xs = 6.0;

  /// Small radius (12dp) — Inputs, secondary buttons
  static const double sm = 12.0;

  /// Medium radius (20dp) — Standard cards, tiles
  static const double md = 20.0;

  /// Large radius (28dp) — Hero cards, bottom sheet top corners
  static const double lg = 28.0;

  /// Full/pill shape
  static const double pill = 999.0;

  /// Full circle (for avatars and circular elements)
  static const double circle = 9999.0;

  /// Standard card border radius
  static const double card = md;

  /// Button border radius (Pill-shaped)
  static const double button = pill;

  /// Input field border radius
  static const double inputField = sm;

  /// Dialog border radius
  static const double dialog = lg;

  /// Bottom sheet border radius (top corners only)
  static const double bottomSheet = lg;

  /// Chip border radius
  static const double chip = xs;
}