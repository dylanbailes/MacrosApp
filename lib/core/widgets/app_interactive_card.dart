// Path: widgets\app_interactive_card.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import 'app_surface.dart';

/// A shared interactive card wrapper providing consistent hover/scale/glow
/// micro-interactions across all dashboard stat cards.
///
/// Nothing OS style: subtle lift, red accent border glow, 1.01-1.02 scale,
/// ripple-free, intentionally engineered feel.
class AppInteractiveCard extends StatefulWidget {
  const AppInteractiveCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppBorderRadius.md,
    this.level = 1,
    this.accentColor,
    this.onTap,
    this.clip = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final int level; // AppSurface elevation level
  final Color? accentColor; // For ambient glow + hover border
  final VoidCallback? onTap;
  final bool clip;

  @override
  State<AppInteractiveCard> createState() => _AppInteractiveCardState();
}

class _AppInteractiveCardState extends State<AppInteractiveCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _liftAnimation;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.015).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _liftAnimation = Tween<double>(begin: 0.0, end: -2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _borderColorAnimation = ColorTween(
      begin: _resolveBaseBorderColor(),
      end: widget.accentColor != null
          ? widget.accentColor!.withValues(alpha: 0.4)
          : AppColors.primary.withValues(alpha: 0.4),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _resolveBaseBorderColor() {
    return switch (widget.level) {
      2 => AppColors.dividerStrong,
      >= 3 => AppColors.glassBorder,
      _ => AppColors.divider,
    };
  }

  void _onEnter(_) {
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _onExit(_) {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.onTap != null;

    Widget surface = AppSurface(
      level: widget.level,
      borderRadius: widget.borderRadius,
      padding: widget.padding,
      clip: widget.clip,
      accentColor: widget.accentColor,
      enableHover: false, // We handle hover ourselves
      child: widget.child,
    );

    // Apply hover transformations
    surface = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _liftAnimation.value),
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
      ),
      child: surface,
    );

    // Add animated border glow on hover
    surface = AnimatedBuilder(
      animation: _borderColorAnimation,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _borderColorAnimation.value ?? _resolveBaseBorderColor(),
            width: 1,
          ),
        ),
        clipBehavior: widget.clip ? Clip.antiAlias : Clip.none,
        child: child,
      ),
      child: surface,
    );

    if (!isInteractive) return surface;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: surface,
      ),
    );
  }
}