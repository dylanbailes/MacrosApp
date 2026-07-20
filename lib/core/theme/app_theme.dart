// Path: theme\app_theme.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'app_text_styles.dart';

/// Application theme configuration.
/// 
/// Reference: Visual Design Specification §4 — Elevation System
/// 
/// True black defeats conventional drop shadows — on #000000, a shadow
/// simply doesn't render. Elevation is instead communicated through
/// luminance steps + hairline edges, with shadow reserved only for
/// content that truly floats above the page (Levels 3-4).
class AppTheme {
  AppTheme._();

  /// Dark theme data — the only theme for this application
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      // Brand accent (signal red)
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryVariant,
      onPrimaryContainer: AppColors.textOnPrimary,
      
      // Secondary surfaces
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnPrimary,
      secondaryContainer: AppColors.surfaceElevated,
      onSecondaryContainer: AppColors.onPrimary,
      
      // Tertiary (used for protein blue)
      tertiary: AppColors.protein,
      onTertiary: AppColors.textOnPrimary,
      
      // Status colors
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      
      // Surface hierarchy (luminance-based elevation)
      surface: AppColors.surface,
      onSurface: AppColors.onPrimary,
      surfaceTint: Colors.transparent,
      
      // Borders
      outline: AppColors.divider,
      outlineVariant: AppColors.dividerStrong,
      
      // Shadows (on true black, these are mostly invisible — kept for completeness)
      shadow: Colors.black,
      scrim: AppColors.scrim,
      
      inverseSurface: AppColors.onPrimary,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,

      // Typography
      textTheme: AppTextStyles.textTheme,
      primaryTextTheme: AppTextStyles.textTheme,

      // AppBar Theme (Clean, transparent, no elevation)
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineLarge,
        iconTheme: const IconThemeData(
          color: AppColors.onPrimary,
          size: AppSpacing.iconLg,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.onPrimary,
          size: AppSpacing.iconLg,
        ),
      ),

      // Card Theme (Surface 01, md radius, hairline border, no shadow at rest)
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          side: const BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // Elevated Button Theme (Primary — solid accent.signal, pill)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            height: 1.33,
            color: AppColors.textOnPrimary,
          ),
          splashFactory: NoSplash.splashFactory,
        ),
      ),

      // Text Button Theme (Ghost)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            height: 1.33,
            color: AppColors.textSecondary,
          ),
          splashFactory: NoSplash.splashFactory,
        ),
      ),

      // Outlined Button Theme (Secondary — surface.02 + hairline)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.onPrimary,
          side: const BorderSide(color: AppColors.dividerStrong, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            height: 1.33,
            color: AppColors.onPrimary,
          ),
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
        labelStyle: AppTextStyles.bodyLarge,
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
        shape: CircleBorder(),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceGlass,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.dialog),
          side: const BorderSide(color: AppColors.dividerStrong),
        ),
        titleTextStyle: AppTextStyles.headlineMedium,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceGlass,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppBorderRadius.bottomSheet)),
        ),
        modalBackgroundColor: AppColors.surfaceGlass,
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
        selectedTileColor: AppColors.surfaceElevated,
        iconColor: AppColors.iconDefault,
        textColor: AppColors.onPrimary,
        titleTextStyle: AppTextStyles.headlineMedium,
        subtitleTextStyle: AppTextStyles.bodySmall,
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

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.onPrimary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.dividerStrong;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.surfaceElevated,
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

      // Page Transitions Theme (spec §1.3)
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

      // Disable Material splash/highlight for premium feel
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      hoverColor: AppColors.surfaceElevated,
    );
  }

  /// Get the appropriate theme based on platform
  static ThemeData get theme => darkTheme;
}