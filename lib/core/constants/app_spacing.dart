// Path: constants\app_spacing.dart
import 'package:flutter/material.dart';

/// Spacing constants for consistent layout throughout the application.
/// 
/// Based on an 8-point grid system for visual harmony and consistency.
class AppSpacing {
  AppSpacing._();

  /// No spacing
  static const double none = 0.0;

  /// Extra small spacing (4dp)
  static const double xs = 4.0;

  /// Small spacing (8dp)
  static const double sm = 8.0;

  /// Medium spacing (12dp)
  static const double md = 12.0;

  /// Regular spacing (16dp)
  static const double lg = 16.0;

  /// Large spacing (20dp)
  static const double xl = 20.0;

  /// Extra large spacing (24dp)
  static const double xxl = 24.0;

  /// Double extra large spacing (32dp)
  static const double xxxl = 32.0;

  /// Quadruple extra large spacing (48dp)
  static const double quadXl = 48.0;

  /// Quintuple extra large spacing (64dp)
  static const double quintXl = 64.0;

  /// Standard padding for screens
  static const double screenPadding = lg;

  /// Standard card padding
  static const double cardPadding = lg;

  /// Button height
  static const double buttonHeight = 48.0;

  /// Minimum touch target size (Material Design guideline)
  static const double minTouchTarget = 48.0;

  /// Icon sizes
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  /// Avatar sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 80.0;
}
