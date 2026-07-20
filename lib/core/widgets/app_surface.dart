// Path: widgets\app_surface.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';

/// An elevated surface container for use in the app's elevation system.
///
/// Reference: Visual Design Specification §4 — Elevation System
/// 
/// On true black, elevation is communicated through luminance steps + hairline
/// edges rather than drop shadows (which are invisible on #000000).
/// 
/// Level 0: void.bg (true black) — no border
/// Level 1: surface.01 — 1px hairline border
/// Level 2: surface.02 — 1px brighter hairline
/// Level 3: surface.03 — top highlight + drop shadow (sheets, modals)
/// Level 4: scrim + blur (overlays)
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.level = 1,
    this.borderRadius = AppBorderRadius.md,
    this.padding,
    this.clip = true,
  });

  final Widget child;
  final int level;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: level > 0 && level < 4
            ? Border.all(
                color: level == 2 ? AppColors.dividerStrong : AppColors.divider,
                width: 1,
              )
            : null,
        boxShadow: level >= 3
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: child,
    );
  }

  Color get _surfaceColor {
    return switch (level) {
      0 => Colors.transparent,
      1 => AppColors.surface,
      2 => AppColors.surfaceElevated,
      3 => AppColors.surfaceGlass,
      4 => AppColors.scrim,
      _ => AppColors.surface,
    };
  }
}