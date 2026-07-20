// Path: constants\app_durations.dart
import 'package:flutter/material.dart';

/// Animation duration constants for consistent motion throughout the application.
/// 
/// Design philosophy: Fast, responsive animations that feel fluid and physical (spring-like).
class AppDurations {
  AppDurations._();

  /// No animation
  static const Duration none = Duration.zero;

  /// Extra fast animation (150ms) - For subtle state changes (hover, press)
  static const Duration xFast = Duration(milliseconds: 150);

  /// Fast animation (250ms) - Default for most interactions
  static const Duration fast = Duration(milliseconds: 250);

  /// Medium animation (400ms) - For transitions, lists, and larger changes
  static const Duration medium = Duration(milliseconds: 400);

  /// Slow animation (600ms) - For dramatic transitions or complex choreographies
  static const Duration slow = Duration(milliseconds: 600);

  /// Extra slow animation (800ms) - For onboarding or special effects
  static const Duration xSlow = Duration(milliseconds: 800);

  // --- Curves ---
  // We use custom Spring curves to emulate Apple/Nothing OS fluid motion.

  /// Standard curve for simple fades and colors
  static const Curve standardCurve = Curves.easeOutCubic;

  /// Fluid, physical spring curve for scales, slides, and size changes
  static const Curve springCurve = SpringCurve();

  /// Snappy spring for quick interactions
  static const Curve snappySpring = SpringCurve(damping: 0.8, stiffness: 200);

  /// Curve for entrance animations
  static const Curve entranceCurve = Curves.easeOutQuart;

  /// Curve for exit animations
  static const Curve exitCurve = Curves.easeInQuart;

  /// Decay curve for smooth deceleration
  static const Curve decayCurve = Curves.decelerate;
}

/// A simple spring curve approximation for use in standard Flutter animations
class SpringCurve extends Curve {
  final double damping;
  final double stiffness;

  const SpringCurve({this.damping = 0.7, this.stiffness = 150});

  @override
  double transformInternal(double t) {
    return Curves.elasticOut.transform(t);
  }
}
