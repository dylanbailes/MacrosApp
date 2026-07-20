// Path: widgets\app_skeleton.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';

/// A skeleton loading placeholder that shows a shimmer effect.
///
/// Reference: Blueprint §2.12 — Skeleton Loader
/// 
/// Matches the exact shape/size of the real content it stands in for.
/// Shimmer sweep is 1.5s linear loop.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppBorderRadius.md,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Use a finite track width so the shimmer offset never becomes NaN
        // (widget.width may be double.infinity, and infinity * -1 = NaN).
        final trackWidth = widget.width;
        final shimmerWidth = (trackWidth != null && trackWidth.isFinite)
            ? trackWidth
            : 200.0;
        final dx = _animation.value * shimmerWidth;

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: widget.shape == BoxShape.rectangle
                ? BorderRadius.circular(widget.borderRadius)
                : null,
            shape: widget.shape,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Shimmer sweep
              Positioned(
                left: dx,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Pre-built skeleton shapes for common components.
class AppSkeletonShapes {
  AppSkeletonShapes._();

  /// Skeleton for a metric tile (92px height)
  static Widget metricTile({double? width}) => AppSkeleton(
        width: width,
        height: 92,
        borderRadius: AppBorderRadius.md,
      );

  /// Skeleton for a log row (64px height)
  static Widget logRow({double? width}) => AppSkeleton(
        width: width,
        height: 64,
        borderRadius: AppBorderRadius.sm,
      );

  /// Skeleton for a card
  static Widget card({double? width, double? height}) => AppSkeleton(
        width: width,
        height: height ?? 120,
        borderRadius: AppBorderRadius.md,
      );

  /// Skeleton for a circular element
  static Widget circle({double size = 64}) => AppSkeleton(
        width: size,
        height: size,
        shape: BoxShape.circle,
      );

  /// Skeleton for a chart area
  static Widget chart({double? width, double? height}) => AppSkeleton(
        width: width,
        height: height ?? 200,
        borderRadius: AppBorderRadius.md,
      );
}