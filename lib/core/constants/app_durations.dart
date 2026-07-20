import 'package:flutter/material.dart';

/// Animation duration constants for consistent motion throughout the application.
/// 
/// Design philosophy: Fast, responsive animations that feel premium without being distracting.
class AppDurations {
  AppDurations._();

  /// No animation
  static const Duration none = Duration.zero;

  /// Extra fast animation (100ms) - For subtle state changes
  static const Duration xFast = Duration(milliseconds: 100);

  /// Fast animation (200ms) - Default for most interactions
  static const Duration fast = Duration(milliseconds: 200);

  /// Medium animation (300ms) - For transitions and larger changes
  static const Duration medium = Duration(milliseconds: 300);

  /// Slow animation (400ms) - For dramatic transitions
  static const Duration slow = Duration(milliseconds: 400);

  /// Extra slow animation (500ms) - For onboarding or special effects
  static const Duration xSlow = Duration(milliseconds: 500);

  /// Standard curve for most animations
  static const Curve standardCurve = Curves.easeInOut;

  /// Curve for entrance animations
  static const Curve entranceCurve = Curves.easeOutCubic;

  /// Curve for exit animations
  static const Curve exitCurve = Curves.easeInCubic;

  /// Spring-like curve for bouncy effects
  static const Curve springCurve = Curves.elasticOut;

  /// Decay curve for smooth deceleration
  static const Curve decayCurve = Curves.decelerate;
}
