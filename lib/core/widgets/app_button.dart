// Path: widgets\app_button.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

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
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 20, color: textColor),
            if (widget.label != null) const SizedBox(width: AppSpacing.sm),
          ],
          if (widget.label != null)
            Text(
              widget.label!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 0.3,
              ),
            ),
        ],
      );
    }

    final container = AnimatedContainer(
      duration: AppDurations.fast,
      constraints: BoxConstraints(
        minWidth: isIconOnly ? height : (widget.isFullWidth ? double.infinity : height * 2.5),
        minHeight: height,
      ),
      padding: isIconOnly ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: isIconOnly
            ? BorderRadius.circular(height / 2)
            : BorderRadius.circular(AppBorderRadius.pill),
        border: _getBorder(),
      ),
      child: Center(child: content),
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

  Color _getBackgroundColor() {
    if (_isEffectivelyDisabled) {
      if (widget.variant == AppButtonVariant.primary) return AppColors.dividerStrong;
      if (widget.variant == AppButtonVariant.icon) return AppColors.surface;
      return Colors.transparent;
    }

    return switch (widget.variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => _isHovered ? AppColors.surfaceGlass : AppColors.surfaceElevated,
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