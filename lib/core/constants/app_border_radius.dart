// Path: constants\app_border_radius.dart
/// Border radius constants for consistent styling throughout the application.
/// 
/// Design philosophy: Smooth, modern, large curves inspired by Nothing OS and modern iOS.
class AppBorderRadius {
  AppBorderRadius._();

  /// No border radius
  static const double none = 0.0;

  /// Extra small radius (8dp)
  static const double xs = 8.0;

  /// Small radius (12dp)
  static const double sm = 12.0;

  /// Medium radius (16dp) - Smaller cards and components
  static const double md = 16.0;

  /// Large radius (20dp) - Default for most cards
  static const double lg = 20.0;

  /// Extra large radius (24dp) - Prominent elements
  static const double xl = 24.0;

  /// Double extra large radius (32dp) - Large surfaces
  static const double xxl = 32.0;

  /// Pill shape (half of typical button height)
  static const double pill = 999.0;

  /// Full circle (for avatars and circular elements)
  static const double circle = 9999.0;

  /// Standard card border radius
  static const double card = lg;

  /// Button border radius (Pill-shaped for that modern look)
  static const double button = pill;

  /// Input field border radius
  static const double inputField = md;

  /// Dialog border radius
  static const double dialog = xl;

  /// Bottom sheet border radius (top corners only)
  static const double bottomSheet = xxl;

  /// Chip border radius
  static const double chip = pill;
}
