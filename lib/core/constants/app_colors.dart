import 'package:flutter/material.dart';

/// Core color palette for the Macro Tracker application.
/// 
/// Design philosophy: Nothing OS inspired, minimal, dark mode only.
/// All colors are optimized for high contrast and visual comfort in dark environments.
class AppColors {
  AppColors._();

  /// Primary brand color - a vibrant accent for key interactions
  static const Color primary = Color(0xFF6366F1);
  
  /// Primary variant for hover/pressed states
  static const Color primaryVariant = Color(0xFF4F46E5);
  
  /// Secondary accent color
  static const Color secondary = Color(0xFF10B981);
  
  /// Error/accent color for warnings
  static const Color error = Color(0xFFEF4444);
  
  /// Warning color
  static const Color warning = Color(0xFFF59E0B);
  
  /// Success color
  static const Color success = Color(0xFF22C55E);
  
  /// Info color
  static const Color info = Color(0xFF3B82F6);

  // Surface Colors - Dark Mode Only
  
  /// Main background color
  static const Color background = Color(0xFF0A0A0A);
  
  /// Secondary background for cards and elevated surfaces
  static const Color surface = Color(0xFF141414);
  
  /// Elevated surface for dialogs and modals
  static const Color surfaceElevated = Color(0xFF1A1A1A);
  
  /// Surface with subtle transparency
  static const Color surfaceTransparent = Color(0x80141414);
  
  /// Card background color
  static const Color card = Color(0xFF1E1E1E);
  
  /// Card with hover state
  static const Color cardHover = Color(0xFF252525);

  // Divider & Border Colors
  
  /// Subtle divider color
  static const Color divider = Color(0xFF2A2A2A);
  
  /// Stronger divider for emphasis
  static const Color dividerStrong = Color(0xFF3A3A3A);

  // Text Colors
  
  /// Primary text color - highest emphasis
  static const Color onPrimary = Color(0xFFFAFAFA);
  
  /// Text color on primary background (alias for onPrimary)
  static const Color textOnPrimary = onPrimary;
  
  /// Secondary text color - medium emphasis
  
  /// Tertiary text color - low emphasis (placeholders, hints)
  
  /// Text color on surfaces
  static const Color onSurface = Color(0xFFFAFAFA);

  // Icon Colors
  
  /// Default icon color
  static const Color iconDefault = Color(0xFFA0A0A0);
  
  /// Icon color on primary surfaces
  static const Color iconOnPrimary = Color(0xFFFFFFFF);

  // Special Effects
  
  /// Overlay color for modals and dialogs
  static const Color overlay = Color(0xCC000000);
  
  /// Scrim color for bottom sheets
  static const Color scrim = Color(0x66000000);

  /// Get gradient for primary elements
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Get gradient for surface cards
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, Color(0xFF0F0F0F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
