import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';

/// A reusable glassmorphic container inspired by modern premium interfaces.
/// 
/// Uses a BackdropFilter to blur the content behind it, with a subtle translucent 
/// background and optional border for depth.
class AppGlassContainer extends StatelessWidget {
  const AppGlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.blur = 24.0,
    this.opacity = 0.5,
    this.showBorder = true,
  });

  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double opacity;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(AppBorderRadius.card);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass.withValues(alpha: opacity),
              borderRadius: effectiveRadius,
              border: showBorder
                  ? Border.all(
                      color: AppColors.glassBorder,
                      width: 1.0,
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
