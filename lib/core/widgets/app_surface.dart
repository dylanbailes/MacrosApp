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
/// Level 1: surface.01 — 1px hairline border (standard cards)
/// Level 2: surface.02 — 1px brighter hairline (featured cards)
/// Level 3: surface.03 — top highlight + drop shadow (sheets, modals)
/// Level 4: scrim + blur (overlays)
///
/// When [accentColor] is provided, the surface gets a very subtle radial glow
/// and the border shifts toward the accent color on hover.
class AppSurface extends StatefulWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.level = 1,
    this.borderRadius = AppBorderRadius.md,
    this.padding,
    this.clip = true,
    this.accentColor,
    this.enableHover = false,
    this.onHover,
  });

  final Widget child;
  final int level;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool clip;
  
  /// Optional accent color for ambient glow behind charts/data areas.
  final Color? accentColor;
  
  /// Enable hover interaction effects (border glow, lift).
  final bool enableHover;
  
  /// Callback for hover state changes.
  final ValueChanged<bool>? onHover;

  @override
  State<AppSurface> createState() => _AppSurfaceState();
}

class _AppSurfaceState extends State<AppSurface> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget surface = Container(
      padding: widget.padding,
      decoration: _buildDecoration(),
      clipBehavior: widget.clip ? Clip.antiAlias : Clip.none,
      child: widget.child,
    );

    // Wrap with ambient glow if accent color is provided
    if (widget.accentColor != null) {
      surface = _AccentGlow(
        accentColor: widget.accentColor!,
        borderRadius: widget.borderRadius,
        child: surface,
      );
    }

    // Wrap with interactive hover effects if enabled
    if (widget.enableHover) {
      surface = MouseRegion(
        onEnter: (_) => setState(() {
          _isHovered = true;
          widget.onHover?.call(true);
        }),
        onExit: (_) => setState(() {
          _isHovered = false;
          widget.onHover?.call(false);
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: _isHovered ? Matrix4.translationValues(0, -2, 0) : Matrix4.identity(),
          child: surface,
        ),
      );
    }

    return surface;
  }

  BoxDecoration _buildDecoration() {
    final borderColor = _resolveBorderColor();
    return BoxDecoration(
      color: _surfaceColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: _buildShadow(),
    );
  }

  Color _resolveBorderColor() {
    if (_isHovered && widget.accentColor != null) {
      return widget.accentColor!.withValues(alpha: 0.3);
    }
    return switch (widget.level) {
      2 => AppColors.dividerStrong,
      >= 3 => AppColors.glassBorder,
      _ => AppColors.divider,
    };
  }

  List<BoxShadow>? _buildShadow() {
    if (widget.level >= 3) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];
    }
    if (_isHovered) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
    }
    return null;
  }

  Color get _surfaceColor {
    return switch (widget.level) {
      0 => Colors.transparent,
      1 => AppColors.surface,
      2 => AppColors.surfaceElevated,
      3 => AppColors.surfaceGlass,
      4 => AppColors.scrim,
      _ => AppColors.surface,
    };
  }
}

/// Very subtle radial gradient glow behind an accent-colored surface element.
/// Opacity is intentionally low (5-8%) to never look like gaming RGB.
class _AccentGlow extends StatelessWidget {
  const _AccentGlow({
    required this.accentColor,
    required this.borderRadius,
    required this.child,
  });

  final Color accentColor;
  final double borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ambient glow
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: RadialGradient(
                center: Alignment.centerRight,
                radius: 1.2,
                colors: [
                  accentColor.withValues(alpha: 0.07),
                  accentColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        // Inner highlight (1px top edge)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: 0.04),
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}