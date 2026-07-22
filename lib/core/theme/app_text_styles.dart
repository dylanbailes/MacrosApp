// Path: theme\app_text_styles.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Nothing OS dot-matrix display font, used ONLY for hero numerals
/// and large metric numbers (≥20px). Never used for small UI text.
const String kNothingFont = 'Nothing';

/// Geist font — the primary UI font for all interface text.
/// Used for labels, section titles, chart axes, legends, button text,
/// navigation, subtitles, helper text, units, descriptions, dates,
/// weekdays, and hover tooltips.
const String kGeistFont = 'Geist';

/// Typography system for the Macro Tracker application.
///
/// Reference: Visual Design Specification §3 — Typography
///
/// Typeface roles:
/// - Nothing Dot Matrix: Hero numerals, large metric numbers ONLY (≥20px)
/// - Geist: Everything else — labels, body, captions, chart text
///
/// Type scale:
/// - Display XL: Nothing 56/60  — Dashboard hero calorie number
/// - Display L:  Nothing 34/38  — Streak days, weigh-in stat
/// - Display S:  Nothing 24/28  — Card metric numbers, large percentages
/// - Title:      Geist SB 22/28 — Screen titles
/// - Headline:   Geist SB 17/22 — Card titles, list item primary text
/// - Body:       Geist Rg 15/20 — Primary content, descriptions
/// - Label:      Geist Md 13/16 +4% tracking, ALL CAPS — Micro-labels
/// - Caption:    Geist Rg 11/14 — Timestamps, meta, chart axis labels
/// - Tiny:       Geist Rg 9/12  — Chart axes, legends, ultra-compact labels
class AppTextStyles {
  AppTextStyles._();

  /// Base text theme
  static TextTheme get textTheme {
    return TextTheme(
      // Display XL — Nothing 56/60 (Hero calorie number)
      displayLarge: const TextStyle(
        fontFamily: kNothingFont,
        fontSize: 56.0,
        fontWeight: FontWeight.w400,
        height: 1.07,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      ),

      // Display L — Nothing 34/38 (Streak days, weigh-in)
      displayMedium: const TextStyle(
        fontFamily: kNothingFont,
        fontSize: 34.0,
        fontWeight: FontWeight.w400,
        height: 1.12,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      ),

      // Display S — Nothing 24/28 (Card metric numbers, large %)
      displaySmall: const TextStyle(
        fontFamily: kNothingFont,
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        height: 1.17,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      ),

      // Title — Geist SemiBold 22/28 (Screen titles)
      headlineLarge: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        height: 1.27,
        color: AppColors.onPrimary,
      ),

      // Headline — Geist SemiBold 17/22 (Card titles, list items)
      headlineMedium: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        height: 1.29,
        color: AppColors.onPrimary,
      ),

      // Sub-headline — Geist SemiBold 15/20
      headlineSmall: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: AppColors.onPrimary,
      ),

      // Title Large — Geist SemiBold 20/26 (screen headers)
      titleLarge: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.onPrimary,
      ),

      // Title Medium — Geist SemiBold 17/22
      titleMedium: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        height: 1.29,
        color: AppColors.onPrimary,
      ),

      // Title Small — Geist SemiBold 15/20
      titleSmall: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: AppColors.onPrimary,
      ),

      // Body — Geist Regular 15/20 (Primary content)
      bodyLarge: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: 1.33,
        color: AppColors.onSurface,
      ),

      // Body Medium — Geist Regular 15/20 (Secondary)
      bodyMedium: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: 1.33,
        color: AppColors.textSecondary,
      ),

      // Body Small — Geist Regular 13/18
      bodySmall: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 1.38,
        color: AppColors.textTertiary,
      ),

      // Label — Geist Medium 13/16 +4% tracking, ALL CAPS (Micro-labels)
      labelLarge: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        height: 1.23,
        letterSpacing: 0.52,
        color: AppColors.textSecondary,
      ),

      // Label Medium — Geist Medium 11/14
      labelMedium: const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
        height: 1.27,
        letterSpacing: 0.44,
        color: AppColors.textSecondary,
      ),

      // Label Small — Geist Regular 11/14
      labelSmall: const TextStyle(
        fontFamily: kGeistFont,
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

  /// Caption — Geist Regular 11/14 (Timestamps, meta, chart axis labels)
  static TextStyle get caption => const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 11.0,
        fontWeight: FontWeight.w400,
        height: 1.27,
        color: AppColors.textTertiary,
      );

  /// Tiny — Geist Regular 9/12 (Chart axes, legends, ultra-compact labels)
  static TextStyle get tiny => const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 9.0,
        fontWeight: FontWeight.w400,
        height: 1.33,
        color: AppColors.textTertiary,
      );

  /// Tiny Medium — Geist Medium 9/12 (Compact labels needing emphasis)
  static TextStyle get tinyMedium => const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 9.0,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
        color: AppColors.textTertiary,
      );

  /// Macro value style (large number for the 3-tile row) — Nothing dot-matrix
  static TextStyle get macroValue => const TextStyle(
        fontFamily: kNothingFont,
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Macro label style (caps label) — Geist for legibility
  static TextStyle get macroLabel => const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        height: 1.23,
        letterSpacing: 0.52,
        color: AppColors.textSecondary,
      );

  /// Numeric display style for macros and statistics — Nothing dot-matrix
  static TextStyle get numericDisplay => const TextStyle(
        fontFamily: kNothingFont,
        fontSize: 40.0,
        fontWeight: FontWeight.w400,
        letterSpacing: -1.0,
        color: AppColors.onPrimary,
        height: 1.0,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Section header label — Geist caps
  static TextStyle get sectionHeader => const TextStyle(
        fontFamily: kGeistFont,
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        height: 1.23,
        letterSpacing: 1.5,
        color: AppColors.textSecondary,
      );

  /// Card metric number — Nothing 24/28 (for card-level metrics)
  static TextStyle get cardMetric => const TextStyle(
        fontFamily: kNothingFont,
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        height: 1.17,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Card metric small — Nothing 20/24 (for smaller card metrics)
  static TextStyle get cardMetricSmall => const TextStyle(
        fontFamily: kNothingFont,
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: AppColors.onPrimary,
        fontFeatures: [FontFeature.tabularFigures()],
      );
}