import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A reusable button widget with multiple variants.
/// 
/// Supports: primary, secondary, outline, ghost, and text variants.
class AppButton extends StatelessWidget {
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

  /// Callback when the button is pressed
  final VoidCallback? onPressed;

  /// Text label for the button
  final String? label;

  /// Optional icon to display before the label
  final IconData? icon;

  /// Button visual variant
  final AppButtonVariant variant;

  /// Button size preset
  final AppButtonSize size;

  /// Whether the button is in a loading state
  final bool isLoading;

  /// Whether the button should expand to full width
  final bool isFullWidth;

  /// Whether the button is disabled
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOnPressed = (disabled || isLoading) ? null : onPressed;

    final height = switch (size) {
      AppButtonSize.small => 36.0,
      AppButtonSize.medium => AppSpacing.buttonHeight,
      AppButtonSize.large => 56.0,
    };

    final horizontalPadding = switch (size) {
      AppButtonSize.small => AppSpacing.md,
      AppButtonSize.medium => AppSpacing.lg,
      AppButtonSize.large => AppSpacing.xl,
    };

    final fontSize = switch (size) {
      AppButtonSize.small => 13.0,
      AppButtonSize.medium => 14.0,
      AppButtonSize.large => 16.0,
    };

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTextColor(theme).withOpacity(0.8),
              ),
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              label!,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: _getTextColor(theme),
              ),
            ),
          ],
        ] else ...[
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: _getTextColor(theme),
            ),
            if (label != null) const SizedBox(width: AppSpacing.sm),
          ],
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: _getTextColor(theme),
              ),
            ),
        ],
      ],
    );

    content = Container(
      constraints: BoxConstraints(
        minWidth: isFullWidth ? double.infinity : (height * 2.5),
        minHeight: height,
      ),
      child: content,
    );

    return AnimatedContainer(
      duration: AppDurations.fast,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.button),
        // _getBorderColor returns a nullable BorderSide; wrap it in Border for BoxDecoration
        border: (() {
          final borderSide = _getBorderColor(theme);
          return borderSide != null ? Border.fromBorderSide(borderSide) : null;
        })(),
      ),
      child: Material(
        color: _getBackgroundColor(theme),
        borderRadius: BorderRadius.circular(AppBorderRadius.button),
        child: InkWell(
          onTap: effectiveOnPressed,
          borderRadius: BorderRadius.circular(AppBorderRadius.button),
          splashColor: _getSplashColor(theme),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: content,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (disabled) return AppColors.divider;

    return switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.secondary,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.ghost => Colors.transparent,
      AppButtonVariant.text => Colors.transparent,
    };
  }

  Color _getTextColor(ThemeData theme) {
    if (disabled) return AppColors.onSurface.withOpacity(0.4);

    return switch (variant) {
      AppButtonVariant.primary => AppColors.textOnPrimary,
      AppButtonVariant.secondary => AppColors.textOnPrimary,
      AppButtonVariant.outline => AppColors.onPrimary,
      AppButtonVariant.ghost => AppColors.onPrimary,
      AppButtonVariant.text => AppColors.primary,
    };
  }

  BorderSide? _getBorderColor(ThemeData theme) {
    if (disabled) return const BorderSide(color: AppColors.dividerStrong);

    final borderSide = switch (variant) {
      AppButtonVariant.primary => BorderSide.none,
      AppButtonVariant.secondary => BorderSide.none,
      AppButtonVariant.outline => const BorderSide(color: AppColors.dividerStrong),
      AppButtonVariant.ghost => BorderSide.none,
      AppButtonVariant.text => BorderSide.none,
    };

    // Convert BorderSide to BoxBorder for BoxDecoration.border
    return borderSide == BorderSide.none ? null : borderSide;
  }

  Color _getSplashColor(ThemeData theme) {
    return switch (variant) {
      AppButtonVariant.primary => AppColors.primaryVariant,
      AppButtonVariant.secondary => AppColors.success,
      AppButtonVariant.outline => AppColors.divider,
      AppButtonVariant.ghost => AppColors.divider,
      AppButtonVariant.text => AppColors.primary.withOpacity(0.1),
    };
  }
}

/// Button visual variants
enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  text,
}

/// Button size presets
enum AppButtonSize {
  small,
  medium,
  large,
}
