// Path: theme\app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'app_text_styles.dart';

/// Application theme configuration.
/// 
/// This class defines the complete visual identity of the Macro Tracker app.
/// Design philosophy: Nothing OS / Linear inspired, minimal, dark mode only, premium feel.
class AppTheme {
  AppTheme._();

  /// Dark theme data - the only theme for this application
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryVariant,
        onPrimaryContainer: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnPrimary,
        secondaryContainer: AppColors.surface,
        onSecondaryContainer: AppColors.onPrimary,
        tertiary: AppColors.info,
        onTertiary: AppColors.textOnPrimary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceTint: Colors.transparent,
        outline: AppColors.divider,
        outlineVariant: AppColors.dividerStrong,
        shadow: Colors.black,
        scrim: AppColors.scrim,
        inverseSurface: AppColors.onPrimary,
        onInverseSurface: AppColors.background,
        inversePrimary: AppColors.primary,
      ),

      // Typography
      textTheme: AppTextStyles.textTheme,

      // AppBar Theme (Clean, transparent, no elevation)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: AppColors.onPrimary,
          height: 1.4,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(
          color: AppColors.onPrimary,
          size: AppSpacing.iconLg,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.onPrimary,
          size: AppSpacing.iconLg,
        ),
      ),

      // Card Theme (Minimal, large radius, no drop shadow)
      cardTheme: CardThemeData(
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.card),
          side: const BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme (Pill shaped, high contrast)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.button),
          ),
          textStyle: AppTextStyles.labelLarge,
          splashFactory: NoSplash.splashFactory, // Removed material ripple
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.button),
          ),
          textStyle: AppTextStyles.labelLarge,
          splashFactory: NoSplash.splashFactory,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onPrimary,
          side: const BorderSide(color: AppColors.dividerStrong),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.button),
          ),
          textStyle: AppTextStyles.labelLarge,
          splashFactory: NoSplash.splashFactory,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.surface,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.inputField),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.inputField),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.inputField),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.inputField),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.inputField),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
        labelStyle: AppTextStyles.bodyMedium,
        errorStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.iconDefault,
        suffixIconColor: AppColors.iconDefault,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.pill)),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.dialog),
          side: const BorderSide(color: AppColors.dividerStrong),
        ),
        titleTextStyle: AppTextStyles.headlineSmall,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppBorderRadius.bottomSheet)),
        ),
        modalBackgroundColor: AppColors.surfaceElevated,
        modalBarrierColor: AppColors.scrim,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.iconDefault,
        size: AppSpacing.iconLg,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: AppColors.primary,
        size: AppSpacing.iconLg,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.surface,
        iconColor: AppColors.iconDefault,
        textColor: AppColors.onPrimary,
        titleTextStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: AppColors.onPrimary,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.divider,
        circularTrackColor: AppColors.divider,
      ),

      // Switch Theme (iOS style)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.onPrimary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.success;
          }
          return AppColors.dividerStrong;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Navigation Bar Theme (for native Nav bar, though we might use custom)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.surface,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelMedium.copyWith(color: AppColors.onPrimary);
          }
          return AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.onPrimary, size: AppSpacing.iconLg);
          }
          return const IconThemeData(color: AppColors.iconDefault, size: AppSpacing.iconLg);
        }),
      ),

      // Page Transitions Theme (Cupertino for all for fluid swiping)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Material Tap Highlight Color (Removed for premium feel)
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      hoverColor: AppColors.surface,
    );
  }

  /// Get the appropriate theme based on platform
  static ThemeData get theme => darkTheme;
}
