// Path: widgets\app_button.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

/// A reusable button widget with multiple variants and premium interactions.
/// 
/// Features: scale down on press, clean loading state, pill shape design.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.onPressed, super.key,
    this.label,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.disabled = false,
  });

  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final bool disabled;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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

  bool get _isEffectivelyDisabled => widget.disabled || widget.isLoading || widget.onPressed == null;

  void _onTapDown(TapDownDetails details) {
    if (!_isEffectivelyDisabled) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!_isEffectivelyDisabled) {
      _controller.reverse();
      widget.onPressed!();
    }
  }

  void _onTapCancel() {
    if (!_isEffectivelyDisabled) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final height = switch (widget.size) {
      AppButtonSize.small => 36.0,
      AppButtonSize.medium => AppSpacing.buttonHeight,
      AppButtonSize.large => 56.0,
    };

    final horizontalPadding = switch (widget.size) {
      AppButtonSize.small => AppSpacing.md,
      AppButtonSize.medium => AppSpacing.lg,
      AppButtonSize.large => AppSpacing.xl,
    };

    final fontSize = switch (widget.size) {
      AppButtonSize.small => 13.0,
      AppButtonSize.medium => 15.0,
      AppButtonSize.large => 17.0,
    };

    final textColor = _getTextColor(theme);
    
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(textColor.withValues(alpha: 0.8)),
            ),
          ),
          if (widget.label != null) ...[
            const SizedBox(width: AppSpacing.md),
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor.withValues(alpha: 0.8),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ] else ...[
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              size: 20,
              color: textColor,
            ),
            if (widget.label != null) const SizedBox(width: AppSpacing.sm),
          ],
          if (widget.label != null)
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 0.3,
              ),
            ),
        ],
      ],
    );

    final container = AnimatedContainer(
      duration: AppDurations.fast,
      constraints: BoxConstraints(
        minWidth: widget.isFullWidth ? double.infinity : (height * 2.5),
        minHeight: height,
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: _getBackgroundColor(theme),
        borderRadius: BorderRadius.circular(AppBorderRadius.button),
        border: (() {
          final borderSide = _getBorderColor(theme);
          return borderSide != null ? Border.fromBorderSide(borderSide) : null;
        })(),
      ),
      child: Center(child: content), // Center the Row
    );

    return MouseRegion(
      cursor: _isEffectivelyDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isEffectivelyDisabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!_isEffectivelyDisabled) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: container,
        ),
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (_isEffectivelyDisabled) {
      if (widget.variant == AppButtonVariant.outline || widget.variant == AppButtonVariant.ghost || widget.variant == AppButtonVariant.text) {
        return Colors.transparent;
      }
      return AppColors.divider;
    }

    return switch (widget.variant) {
      AppButtonVariant.primary => _isHovered ? AppColors.primaryVariant : AppColors.primary,
      AppButtonVariant.secondary => _isHovered ? AppColors.surfaceElevated : AppColors.surface,
      AppButtonVariant.outline => _isHovered ? AppColors.divider : Colors.transparent,
      AppButtonVariant.ghost => _isHovered ? AppColors.divider : Colors.transparent,
      AppButtonVariant.text => _isHovered ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
    };
  }

  Color _getTextColor(ThemeData theme) {
    if (_isEffectivelyDisabled) return AppColors.textTertiary;

    return switch (widget.variant) {
      AppButtonVariant.primary => AppColors.textOnPrimary,
      AppButtonVariant.secondary => AppColors.onPrimary,
      AppButtonVariant.outline => AppColors.onPrimary,
      AppButtonVariant.ghost => AppColors.onPrimary,
      AppButtonVariant.text => AppColors.primary,
    };
  }

  BorderSide? _getBorderColor(ThemeData theme) {
    if (_isEffectivelyDisabled && widget.variant == AppButtonVariant.outline) {
      return const BorderSide(color: AppColors.divider);
    }

    final borderSide = switch (widget.variant) {
      AppButtonVariant.primary => BorderSide.none,
      AppButtonVariant.secondary => BorderSide.none,
      AppButtonVariant.outline => const BorderSide(color: AppColors.dividerStrong, width: 1.5),
      AppButtonVariant.ghost => BorderSide.none,
      AppButtonVariant.text => BorderSide.none,
    };

    return borderSide == BorderSide.none ? null : borderSide;
  }
}

enum AppButtonVariant { primary, secondary, outline, ghost, text }
enum AppButtonSize { small, medium, large }
