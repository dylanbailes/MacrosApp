// Path: widgets\app_card.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

/// A reusable card widget with consistent styling throughout the application.
/// 
/// Features a subtle border, hover elevation, and smooth scale-down animation on tap.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.showBorder = true,
    this.elevated = false,
    this.backgroundColor,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? borderRadius;
  final bool showBorder;
  final bool elevated;
  final Color? backgroundColor;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.xFast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Default radius is 20 for cards
    final radius = widget.borderRadius ?? 20.0;
    
    final baseColor = widget.backgroundColor ?? 
                      (widget.elevated ? AppColors.surfaceElevated : AppColors.card);

    final resolvedColor = _isHovered && widget.onTap != null 
        ? AppColors.cardHover 
        : baseColor;

    final card = AnimatedContainer(
      duration: AppDurations.fast,
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.circular(radius),
        border: widget.showBorder
            ? Border.all(
                color: theme.dividerColor,
                width: 1,
              )
            : null,
        boxShadow: widget.elevated || (_isHovered && widget.onTap != null)
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap == null) return card;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: card,
        ),
      ),
    );
  }
}

