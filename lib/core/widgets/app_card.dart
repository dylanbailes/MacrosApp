// Path: widgets\app_card.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

/// A reusable card widget with consistent styling throughout the application.
///
/// Reference: Blueprint §2.2 — Card
/// 
/// Variants:
/// - Standard: vertical content stack
/// - Row: horizontal content (e.g., food-log list item)
/// - Hero: uses radius.lg (28px), reserved for the single most important card per screen
/// - Interactive: adds tap/press treatment
/// - Static: informational only, no press feedback
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.variant = AppCardVariant.standard,
    this.showBorder = true,
    this.backgroundColor,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final bool showBorder;
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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

  bool get _isInteractive => widget.onTap != null && widget.variant != AppCardVariant.static;

  void _onTapDown(TapDownDetails details) {
    if (_isInteractive) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (_isInteractive) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    if (_isInteractive) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final radius = switch (widget.variant) {
      AppCardVariant.hero => AppBorderRadius.lg,
      AppCardVariant.row => AppBorderRadius.sm,
      _ => AppBorderRadius.md,
    };

    final baseColor = widget.backgroundColor ?? AppColors.surface;
    final resolvedColor = _isHovered && _isInteractive
        ? AppColors.surfaceElevated
        : baseColor;

    final card = AnimatedContainer(
      duration: AppDurations.fast,
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.circular(radius),
        border: widget.showBorder
            ? Border.all(
                color: AppColors.divider,
                width: 1,
              )
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

    if (!_isInteractive) return card;

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

/// Card variants per Blueprint §2.2
enum AppCardVariant {
  /// Vertical content stack (default)
  standard,

  /// Horizontal content, e.g., food-log list item
  row,

  /// Uses radius.lg (28px), for the single most important card per screen
  hero,

  /// Adds tap/press treatment
  interactive,

  /// Informational only, no press feedback
  static,
}