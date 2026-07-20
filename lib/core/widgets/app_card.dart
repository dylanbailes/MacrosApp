import 'package:flutter/material.dart';

/// A reusable card widget with consistent styling throughout the application.
/// 
/// Design philosophy: Minimal, subtle borders, dark mode optimized.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.showBorder = true,
    this.elevated = false,
  });

  /// The child widget contained within the card
  final Widget? child;

  /// Internal padding for the card content
  final EdgeInsetsGeometry? padding;

  /// External margin for the card
  final EdgeInsetsGeometry? margin;

  /// Optional tap callback - makes the card interactive
  final VoidCallback? onTap;

  /// Custom border radius (uses default if null)
  final double? borderRadius;

  /// Whether to show the subtle border
  final bool showBorder;

  /// Whether the card should appear elevated
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;

    final widget = Card(
      margin: margin ?? EdgeInsets.zero,
      color: elevated ? cardTheme.color?.withOpacity(0.8) : cardTheme.color,
      surfaceTintColor: Colors.transparent,
      elevation: elevated ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? cardTheme.shape?.borderRadius.topLeft ?? 12),
        side: showBorder
            ? BorderSide(
                color: theme.dividerColor,
                width: 1,
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    return onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            child: widget,
          )
        : widget;
  }
}
