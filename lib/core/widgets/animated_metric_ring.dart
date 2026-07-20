// Path: widgets\animated_metric_ring.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';

/// A premium animated circular metric ring, inspired by Apple Health/MacroFactor.
/// 
/// Used for displaying progress towards a goal (e.g., calories, protein).
class AnimatedMetricRing extends StatefulWidget {
  const AnimatedMetricRing({
    super.key,
    required this.value,
    this.maxValue = 1.0,
    this.size = 120.0,
    this.strokeWidth = 12.0,
    this.color = AppColors.primary,
    this.backgroundColor = AppColors.divider,
    this.centerWidget,
  });

  /// The current value to display (relative to maxValue)
  final double value;
  
  /// The maximum value (represents a full circle)
  final double maxValue;
  
  /// The diameter of the ring
  final double size;
  
  /// The thickness of the ring
  final double strokeWidth;
  
  /// The color of the progress ring
  final Color color;
  
  /// The color of the background track
  final Color backgroundColor;
  
  /// Optional widget to display in the center (e.g., a text label or icon)
  final Widget? centerWidget;

  @override
  State<AnimatedMetricRing> createState() => _AnimatedMetricRingState();
}

class _AnimatedMetricRingState extends State<AnimatedMetricRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Slightly longer for the premium feel
    );

    final targetProgress = (widget.value / widget.maxValue).clamp(0.0, 1.0);
    _animation = Tween<double>(begin: 0.0, end: targetProgress).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppDurations.springCurve,
      ),
    );

    _oldProgress = targetProgress;
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedMetricRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final targetProgress = (widget.value / widget.maxValue).clamp(0.0, 1.0);
    if (targetProgress != _oldProgress) {
      _animation = Tween<double>(begin: _oldProgress, end: targetProgress).animate(
        CurvedAnimation(
          parent: _controller,
          curve: AppDurations.springCurve,
        ),
      );
      _oldProgress = targetProgress;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Ring
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _RingPainter(
              progress: 1.0,
              color: widget.backgroundColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),
          
          // Foreground Animated Ring
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RingPainter(
                  progress: _animation.value,
                  color: widget.color,
                  strokeWidth: widget.strokeWidth,
                  hasShadow: true,
                ),
              );
            },
          ),
          
          if (widget.centerWidget != null) widget.centerWidget!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool hasShadow;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.hasShadow = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    // Optional glow effect for the primary ring
    if (hasShadow && progress > 0) {
      final shadowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        shadowPaint,
      );
    }

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Start at 12 o'clock
        progress * 2 * math.pi,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.color != color ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}
