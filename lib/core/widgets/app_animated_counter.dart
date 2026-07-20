// Path: widgets\app_animated_counter.dart
import 'package:flutter/material.dart';

/// An animated counter that counts up (odometer-style) when the value changes.
///
/// Reference: Blueprint §2.3/§2.4/§2.16 — shared count-up utility
/// 
/// Only animates on actual data changes, not on rebuilds with the same value.
/// Degrades to instant display when system reduced motion is enabled.
class AppAnimatedCounter extends StatefulWidget {
  const AppAnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
  });

  final int value;
  final TextStyle style;
  final Duration duration;
  final Curve curve;

  @override
  State<AppAnimatedCounter> createState() => _AppAnimatedCounterState();
}

class _AppAnimatedCounterState extends State<AppAnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _displayValue = 0;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
    _previousValue = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    // Start at final value (no animation on first build)
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(AppAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _displayValue;
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
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (reducedMotion || _controller.isCompleted) {
          _displayValue = widget.value;
        } else {
          _displayValue = (_previousValue +
                  ((widget.value - _previousValue) * _animation.value))
              .round();
        }

        return Text(
          _displayValue.toString(),
          style: widget.style,
        );
      },
    );
  }
}