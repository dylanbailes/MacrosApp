// Path: constants\app_colors.dart
import 'package:flutter/material.dart';

/// Core color palette for the Macro Tracker application.
/// 
/// Design philosophy: Nothing OS / Linear inspired, minimal, true dark mode.
/// Optimized for OLED displays with true blacks and high contrast accents.
class AppColors {
  AppColors._();

  /// Primary brand color - high contrast accent
  static const Color primary = Color(0xFFE2E2E2); // Off-white/Silver for premium feel
  
  /// Primary variant for hover/pressed states
  static const Color primaryVariant = Color(0xFFFFFFFF);
  
  /// Secondary accent color (subtle)
  static const Color secondary = Color(0xFF2A2A2A);
  
  /// Semantic colors
  static const Color error = Color(0xFFFF453A); // Apple-like red
  static const Color warning = Color(0xFFFF9F0A); // Apple-like orange
  static const Color success = Color(0xFF32D74B); // Apple-like green
  static const Color info = Color(0xFF0A84FF); // Apple-like blue

  // Surface Colors - True Dark Mode
  
  /// Main background color (True OLED Black)
  static const Color background = Color(0xFF000000);
  
  /// Secondary background for cards and elevated surfaces
  static const Color surface = Color(0xFF111111);
  
  /// Elevated surface for dialogs and modals
  static const Color surfaceElevated = Color(0xFF1C1C1E);
  
  /// Surface with subtle transparency for glass effects
  static const Color surfaceGlass = Color(0xB3111111); // 70% opacity
  
  /// Card background color
  static const Color card = Color(0xFF151515);
  
  /// Card with hover state
  static const Color cardHover = Color(0xFF1F1F1F);

  // Divider & Border Colors
  
  /// Subtle divider color
  static const Color divider = Color(0xFF222222);
  
  /// Stronger divider for emphasis
  static const Color dividerStrong = Color(0xFF333333);
  
  /// Border for glass elements
  static const Color glassBorder = Color(0x33FFFFFF);

  // Text Colors
  
  /// Primary text color - highest emphasis
  static const Color onPrimary = Color(0xFF111111); // Dark text on light primary
  
  /// Text color on primary background (alias for onPrimary)
  static const Color textOnPrimary = onPrimary;
  
  /// Primary text color on dark surfaces
  static const Color onSurface = Color(0xFFF5F5F5);
  
  /// Secondary text color - medium emphasis
  static const Color textSecondary = Color(0xFF8E8E93);
  
  /// Tertiary text color - low emphasis (placeholders, hints)
  static const Color textTertiary = Color(0xFF636366);

  // Icon Colors
  
  /// Default icon color
  static const Color iconDefault = Color(0xFF8E8E93);
  
  /// Icon color on primary surfaces
  static const Color iconOnPrimary = Color(0xFF111111);

  // Special Effects
  
  /// Overlay color for modals and dialogs
  static const Color overlay = Color(0x99000000);
  
  /// Scrim color for bottom sheets
  static const Color scrim = Color(0x80000000);

  /// Get gradient for primary elements (subtle silver gradient)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFE2E2E2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Get gradient for surface cards
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF181818), Color(0xFF111111)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
