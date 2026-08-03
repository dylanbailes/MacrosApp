// Path: widgets\app_button.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A reusable button widget with multiple variants and premium interactions.
///
/// Reference: Blueprint §2.1 — Buttons
/// 
/// Variants:
/// - Primary: solid accent.signal pill — one per screen, the single most important action
/// - Secondary: surface.02 + hairline pill — alternate but valid action
/// - Ghost: transparent text-only — cancel/dismiss, low-emphasis navigation
/// - Icon: surface.01 circle, 44×44 — utility actions in toolbar or card corner
/// - Destructive: dark-red surface with accent.signal text — irreversible actions only
/// 
/// Hover Behavior:
/// - All buttons show subtle red overlay on hover (perfectly clipped to pill shape)
/// - Scale animation on press for tactile feedback
/// - Smooth 150ms transition
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
  late Animation<Color?> _hoverOverlayAnimation;

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
    _hoverOverlayAnimation = ColorTween(
      begin: Colors.transparent,
      end: AppColors.primary.withValues(alpha: 0.12),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isEffectivelyDisabled => widget.disabled || widget.isLoading || widget.onPressed == null;

  void _handleTapDown(TapDownDetails details) {
    if (!_isEffectivelyDisabled) _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEffectivelyDisabled) {
      _controller.reverse();
      widget.onPressed!();
    }
  }

  void _handleTapCancel() {
    if (!_isEffectivelyDisabled) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final height = switch (widget.size) {
      AppButtonSize.small => 36.0,
      AppButtonSize.medium => AppSpacing.buttonHeight,
      AppButtonSize.large => 56.0,
    };

    final horizontalPadding = switch (widget.size) {
      AppButtonSize.small => AppSpacing.md,
      AppButtonSize.medium => AppSpacing.xxl,
      AppButtonSize.large => AppSpacing.xl,
    };

    final fontSize = switch (widget.size) {
      AppButtonSize.small => 13.0,
      AppButtonSize.medium => 15.0,
      AppButtonSize.large => 17.0,
    };

    final textColor = _getTextColor();
    final isIconOnly = widget.variant == AppButtonVariant.icon || (widget.icon != null && widget.label == null);
    final pillRadius = isIconOnly ? height / 2 : AppBorderRadius.pill;
    
    Widget content;
    if (isIconOnly) {
      content = Icon(
        widget.icon,
        size: 20,
        color: textColor,
      );
    } else if (widget.isLoading) {
      content = SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(textColor.withValues(alpha: 0.8)),
        ),
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 20, color: textColor),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            widget.label ?? '',
            style: TextStyle(
              fontFamily: kGeistFont,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      );
    }

    return MouseRegion(
      cursor: _isEffectivelyDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isEffectivelyDisabled) _controller.forward();
      },
      onExit: (_) {
        if (!_isEffectivelyDisabled) _controller.reverse();
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _hoverOverlayAnimation,
            builder: (context, child) {
              return Container(
                constraints: BoxConstraints(
                  minWidth: isIconOnly ? height : (widget.isFullWidth ? double.infinity : height * 2.5),
                  minHeight: height,
                ),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(pillRadius),
                  border: _getBorder(),
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    content,
                    // Hover overlay - perfectly clipped to pill shape
                    if (!_isEffectivelyDisabled)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _hoverOverlayAnimation.value,
                            borderRadius: BorderRadius.circular(pillRadius),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (_isEffectivelyDisabled) {
      if (widget.variant == AppButtonVariant.primary) return AppColors.dividerStrong;
      if (widget.variant == AppButtonVariant.icon) return AppColors.surface;
      return Colors.transparent;
    }

    return switch (widget.variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => Colors.transparent,
      AppButtonVariant.ghost => Colors.transparent,
      AppButtonVariant.icon => AppColors.surface,
      AppButtonVariant.destructive => const Color(0xFF3A1015),
    };
  }

  Color _getTextColor() {
    if (_isEffectivelyDisabled) return AppColors.textDisabled;

    return switch (widget.variant) {
      AppButtonVariant.primary => AppColors.textOnPrimary,
      AppButtonVariant.secondary => AppColors.onPrimary,
      AppButtonVariant.ghost => AppColors.textSecondary,
      AppButtonVariant.icon => AppColors.onPrimary,
      AppButtonVariant.destructive => AppColors.primary,
    };
  }

  Border? _getBorder() {
    if (_isEffectivelyDisabled) {
      if (widget.variant == AppButtonVariant.secondary) {
        return Border.all(color: AppColors.divider);
      }
      return null;
    }

    return switch (widget.variant) {
      AppButtonVariant.primary => null,
      AppButtonVariant.secondary => Border.all(color: AppColors.dividerStrong),
      AppButtonVariant.ghost => null,
      AppButtonVariant.icon => Border.all(color: AppColors.divider),
      AppButtonVariant.destructive => null,
    };
  }
}

/// Button variants per Blueprint §2.1
enum AppButtonVariant {
  /// Solid accent.signal pill — one per screen
  primary,

  /// surface.02 + hairline pill
  secondary,

  /// Transparent text-only
  ghost,

  /// surface.01 circle, 44×44
  icon,

  /// Dark-red surface for irreversible actions
  destructive,
}

enum AppButtonSize { small, medium, large }