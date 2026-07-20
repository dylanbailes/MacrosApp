/// Border radius constants for consistent styling throughout the application.
/// 
/// Design philosophy: Smooth, modern curves inspired by Nothing OS aesthetic.
class AppBorderRadius {
  AppBorderRadius._();

  /// No border radius
  static const double none = 0.0;

  /// Extra small radius (4dp)
  static const double xs = 4.0;

  /// Small radius (8dp)
  static const double sm = 8.0;

  /// Medium radius (12dp) - Default for most cards
  static const double md = 12.0;

  /// Large radius (16dp) - For prominent cards
  static const double lg = 16.0;

  /// Extra large radius (20dp)
  static const double xl = 20.0;

  /// Double extra large radius (24dp)
  static const double xxl = 24.0;

  /// Pill shape (half of typical button height)
  static const double pill = 24.0;

  /// Full circle (for avatars and circular elements)
  static const double circle = 9999.0;

  /// Standard card border radius
  static const double card = md;

  /// Button border radius
  static const double button = sm;

  /// Input field border radius
  static const double inputField = sm;

  /// Dialog border radius
  static const double dialog = lg;

  /// Bottom sheet border radius (top corners only)
  static const double bottomSheet = lg;

  /// Chip border radius
  static const double chip = pill;
}
