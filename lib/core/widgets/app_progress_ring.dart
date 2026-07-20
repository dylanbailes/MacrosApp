// Path: widgets\app_progress_ring.dart
import 'dart:math';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// A circular progress ring for displaying goal completion.
///
/// Reference: Blueprint §2.15 — Progress Ring (generic, non-hero)
/// 
/// Two variants:
/// - Hero (180px): Dashboard calorie ring with Ndot numeral
/// - Generic (64px): Analytics/Profile secondary metrics
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    super.key,
    this.progress = 0.0,
    this.size = 64,
    this.strokeWidth = 6,
    this.color = AppColors.energyNeutral,
    this.trackColor,
    this.child,
  });

  /// Progress from 0.0 to 1.0
  final double progress;

  /// Diameter of the ring
  final double size;

  /// Width of the ring stroke
  final double strokeWidth;

  /// Color of the filled portion
  final Color color;

  /// Color of the track (defaults to divider)
  final Color? trackColor;

  /// Optional child widget centered inside the ring
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          progress: progress.clamp(0.0, 1.0),
          strokeWidth: strokeWidth,
          color: color,
          trackColor: trackColor ?? AppColors.divider,
        ),
        child: Padding(
          padding: EdgeInsets.all(strokeWidth + 4),
          child: child,
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Fill
    if (progress > 0) {
      final fillPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}