import 'package:flutter/material.dart';

import '../constants/app_durations.dart';

/// A wrapper widget that animates its child when it first appears.
/// 
/// Perfect for list items, providing a smooth slide-up and fade-in effect
/// that cascades down the list when used with varying delays.
class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({
    super.key,
    required this.child,
    this.index = 0,
    this.delayMs = 50,
  });

  final Widget child;
  
  /// The index of the item in the list, used to calculate staggered delay.
  final int index;
  
  /// The base delay per item index.
  final int delayMs;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2), // Start slightly below
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppDurations.springCurve,
      ),
    );

    _startAnimation();
  }

  void _startAnimation() {
    // Add a staggered delay based on the item's index
    Future.delayed(Duration(milliseconds: widget.index * widget.delayMs), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
