// Path: constants\app_colors.dart
import 'package:flutter/material.dart';

/// Core color palette for the Macro Tracker application.
///
/// Design philosophy: Nothing OS / Linear inspired, minimal, true dark mode.
/// Optimized for OLED displays with true blacks and high contrast accents.
/// 
/// Reference: Visual Design Specification §2 — Color Palette
///
/// Semantic color system:
/// - ❤️ Calories: Red (#FF3B30)
/// - 💙 Protein: Electric Blue (#3D8BFD)
/// - 💧 Water: Cyan (#22D3EE)
/// - 💚 Weight: Emerald (#34D399)
/// - 🟡 Goals/Streak: Warm Amber (#F59E0B)
class AppColors {
  AppColors._();

  // --- Base (true black system, OLED-first) ---

  /// App background, true black
  static const Color background = Color(0xFF000000);
  
  /// Standard cards, tiles
  static const Color surface = Color(0xFF0D0D0F);
  
  /// Nested elements, pressed/active rows
  static const Color surfaceElevated = Color(0xFF16161A);
  
  /// Modals, sheets, toasts
  static const Color surfaceGlass = Color(0xFF202024);
  
  /// 1px borders/dividers everywhere
  static const Color divider = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  
  /// Stronger divider for emphasis
  static const Color dividerStrong = Color(0x1FFFFFFF); // rgba(255,255,255,0.12)

  // --- Text Colors ---
  
  /// Headlines, hero numerals (warm off-white, not clinical pure white)
  static const Color onPrimary = Color(0xFFF5F5F2);
  
  /// Body copy, sub-labels
  static const Color textSecondary = Color(0xFF9A9A9E);
  
  /// Meta, timestamps
  static const Color textTertiary = Color(0xFF5C5C60);
  
  /// Inactive state
  static const Color textDisabled = Color(0xFF38383A);
  
  /// Text on primary surfaces (for Primary button)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // --- Brand Accent ---

  /// Primary CTA, Log button, streaks, live/recording dot, critical alerts
  static const Color primary = Color(0xFFFF1E3C);

  // --- Macro Semantics ---

  /// Protein numerals, rings, chart lines
  static const Color protein = Color(0xFF3D8BFD);
  
  /// Carbs numerals, rings, chart lines
  static const Color carbs = Color(0xFFFFB020);
  
  /// Fat numerals, rings, chart lines (coral)
  static const Color fat = Color(0xFFFF6B5E);
  
  /// Calorie ring/number — kept neutral
  static const Color energyNeutral = Color(0xFFF5F5F2);

  // --- Data & Status ---

  /// Trend improving, streak maintained, goal hit
  static const Color success = Color(0xFF34D399);
  
  /// Over target, missed check-in (reuses signal red)
  static const Color error = Color(0xFFFF1E3C);
  
  /// Flat trend, "holding" state
  static const Color warning = Color(0xFF9A9A9E);

  // --- Semantic Metric Colors ---

  /// Water metric accent — muted cyan
  static const Color water = Color(0xFF22D3EE);
  
  /// Weight metric accent — muted emerald
  static const Color weight = Color(0xFF34D399);
  
  /// Goals/Streak accent — warm amber
  static const Color goal = Color(0xFFF59E0B);

  // --- Legacy compatibility aliases ---
  static const Color primaryVariant = Color(0xFFFF3B54);
  static const Color secondary = Color(0xFF2A2A2A);
  static const Color info = Color(0xFF3D8BFD);
  static const Color card = Color(0xFF0D0D0F);
  static const Color cardHover = Color(0xFF16161A);
  static const Color glassBorder = Color(0x29FFFFFF); // rgba(255,255,255,.16)
  static const Color onSurface = Color(0xFFF5F5F2);
  static const Color iconDefault = Color(0xFF9A9A9E);
  static const Color iconOnPrimary = Color(0xFF111111);
  static const Color overlay = Color(0xB3000000); // rgba(0,0,0,.7)
  static const Color scrim = Color(0xB3000000);
}