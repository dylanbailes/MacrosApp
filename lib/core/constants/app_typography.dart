import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Application typography configuration following the Nothing OS inspired design system.
///
/// Uses Inter font family for clean, modern readability across all platforms.
/// All text styles are predefined for consistency throughout the application.
final class AppTypography {
  AppTypography._();

  /// Primary font family used throughout the application.
  static const String fontFamily = 'Inter';

  /// Complete text theme with all text styles configured.
  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displayMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displaySmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.3,
      ),
      headlineLarge: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.3,
      ),
      headlineMedium: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.3,
      ),
      headlineSmall: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.4,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.4,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.4,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.5,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.5,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.5,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.5,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelSmall: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
        height: 1.5,
        letterSpacing: 0.1,
      ),
    );
  }

  /// Predefined text style for numeric displays (calories, macros, etc.).
  /// Uses tabular figures for consistent alignment in columns.
  static const TextStyle tabularNumbers = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Predefined text style for section headers.
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.4,
    letterSpacing: 0.5,
  );
}
