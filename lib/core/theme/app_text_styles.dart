// Path: theme\app_text_styles.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Typography system for the Macro Tracker application.
/// 
/// Reference: Visual Design Specification §3 — Typography
/// 
/// Typeface roles:
/// - Display (Ndot): Reserved for hero stats only (calories, streak, weigh-in)
/// - UI/Body (Inter): Everything else
///
/// Type scale:
/// - Display XL: Ndot 56/60  — Dashboard hero calorie number
/// - Display L:  Ndot 34/38  — Streak days, check-in countdown, weigh-in stat
/// - Title:      Inter SB 22/28 — Screen titles
/// - Headline:   Inter SB 17/22 — Card titles, list item primary text
/// - Body:       Inter Rg 15/20 — Primary content, descriptions
/// - Label:      Inter Md 13/16 +4% tracking, ALL CAPS — Micro-labels
/// - Caption:    Inter Rg 11/14 — Timestamps, meta, chart axis labels
class AppTextStyles {
  AppTextStyles._();

  /// Base text theme
  static TextTheme get textTheme {
    return TextTheme(
      // Display XL — Ndot 56/60 (Hero calorie number)
      displayLarge: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 56.0,
        fontWeight: FontWeight.w700,
        height: 1.07,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      ),

      // Display L — Ndot 34/38 (Streak days, weigh-in)
      displayMedium: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 34.0,
        fontWeight: FontWeight.w700,
        height: 1.12,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      ),

      // Display S — Reserved for future Ndot usage
      displaySmall: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      ),

      // Title — Inter SemiBold 22/28 (Screen titles)
      headlineLarge: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        height: 1.27,
        color: AppColors.onPrimary,
      ),

      // Headline — Inter SemiBold 17/22 (Card titles, list items)
      headlineMedium: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        height: 1.29,
        color: AppColors.onPrimary,
      ),

      // Sub-headline
      headlineSmall: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: AppColors.onPrimary,
      ),

      // Title Large — for screen headers
      titleLarge: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.onPrimary,
      ),

      // Title Medium
      titleMedium: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        height: 1.29,
        color: AppColors.onPrimary,
      ),

      // Title Small
      titleSmall: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: AppColors.onPrimary,
      ),

      // Body — Inter Regular 15/20 (Primary content)
      bodyLarge: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: 1.33,
        color: AppColors.onSurface,
      ),

      // Body Medium
      bodyMedium: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: 1.33,
        color: AppColors.textSecondary,
      ),

      // Body Small
      bodySmall: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 1.38,
        color: AppColors.textTertiary,
      ),

      // Label — Inter Medium 13/16 +4% tracking, ALL CAPS (Micro-labels)
      labelLarge: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        height: 1.23,
        letterSpacing: 0.52, // +4% of 13px
        color: AppColors.textSecondary,
      ),

      // Label Medium
      labelMedium: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
        height: 1.27,
        letterSpacing: 0.44, // +4% of 11px
        color: AppColors.textSecondary,
      ),

      // Label Small
      labelSmall: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11.0,
        fontWeight: FontWeight.w400,
        height: 1.27,
        color: AppColors.textTertiary,
      ),
    );
  }

  // Convenience getters

  static TextStyle get displayLarge => textTheme.displayLarge!;
  static TextStyle get displayMedium => textTheme.displayMedium!;
  static TextStyle get displaySmall => textTheme.displaySmall!;

  static TextStyle get headlineLarge => textTheme.headlineLarge!;
  static TextStyle get headlineMedium => textTheme.headlineMedium!;
  static TextStyle get headlineSmall => textTheme.headlineSmall!;

  static TextStyle get titleLarge => textTheme.titleLarge!;
  static TextStyle get titleMedium => textTheme.titleMedium!;
  static TextStyle get titleSmall => textTheme.titleSmall!;

  static TextStyle get bodyLarge => textTheme.bodyLarge!;
  static TextStyle get bodyMedium => textTheme.bodyMedium!;
  static TextStyle get bodySmall => textTheme.bodySmall!;

  static TextStyle get labelLarge => textTheme.labelLarge!;
  static TextStyle get labelMedium => textTheme.labelMedium!;
  static TextStyle get labelSmall => textTheme.labelSmall!;

  // --- Custom Styles ---

  /// Caption — Inter Regular 11/14 (Timestamps, meta, chart axis labels)
  static TextStyle get caption => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11.0,
        fontWeight: FontWeight.w400,
        height: 1.27,
        color: AppColors.textTertiary,
      );

  /// Macro value style (large number for the 3-tile row)
  static TextStyle get macroValue => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Macro label style (caps label)
  static TextStyle get macroLabel => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        height: 1.23,
        letterSpacing: 0.52,
        color: AppColors.textSecondary,
      );

  /// Numeric display style for macros and statistics
  static TextStyle get numericDisplay => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 40.0,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: AppColors.onPrimary,
        height: 1.0,
        fontFeatures: [FontFeature.tabularFigures()],
      );
}