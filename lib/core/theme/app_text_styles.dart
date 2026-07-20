import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Typography system for the Macro Tracker application.
/// 
/// Uses Inter font family for a clean, modern appearance inspired by Nothing OS.
/// All text styles are optimized for dark mode readability.
class AppTextStyles {
  AppTextStyles._();

  /// Base text theme using Google Fonts Inter
  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: const TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: AppColors.onPrimary,
        height: 1.2,
      ),
      displayMedium: const TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppColors.onPrimary,
        height: 1.25,
      ),
      displaySmall: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppColors.onPrimary,
        height: 1.3,
      ),
      headlineLarge: const TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: AppColors.onPrimary,
        height: 1.35,
      ),
      headlineMedium: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: 1.4,
      ),
      headlineSmall: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: 1.45,
      ),
      titleLarge: const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: 1.5,
      ),
      titleMedium: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: 1.5,
      ),
      titleSmall: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: 1.5,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: AppColors.onPrimary,
        height: 1.5,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface.withOpacity(0.6),
        height: 1.5,
      ),
      bodySmall: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface.withOpacity(0.4),
        height: 1.5,
      ),
      labelLarge: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.onPrimary,
        height: 1.4,
      ),
      labelMedium: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.onSurface.withOpacity(0.6),
        height: 1.4,
      ),
      labelSmall: const TextStyle(
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: AppColors.onSurface.withOpacity(0.4),
        height: 1.4,
      ),
    );
  }

  // Convenience getters for common text styles

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

  /// Numeric display style for macros and statistics
  static TextStyle get numericDisplay => const TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: AppColors.onPrimary,
        height: 1.1,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Style for macro values (protein, carbs, fat)
  static TextStyle get macroValue => const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        height: 1.2,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Style for macro labels
  static TextStyle get macroLabel => const TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface.withOpacity(0.6),
        height: 1.4,
        letterSpacing: 0.3,
      );
}
