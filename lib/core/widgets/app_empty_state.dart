// Path: widgets/app_empty_state.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// A shared empty-state block: icon + title + optional hint + optional CTA.
///
/// Reference: Visual Design Specification §11 — Empty states
/// No mascots or illustrations — a restrained accent icon, one line of
/// guidance, and an action when there is a natural next step.
///
/// Use inside an [AppCard] (or bare) wherever a screen has no content yet:
/// empty log days, no search results, no recent meals.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.hint,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    this.padding,
    this.titleStyle,
    this.showIcon = true,
  });

  final IconData icon;

  /// One-line primary guidance (e.g. "Nothing logged yet").
  final String title;

  /// Optional secondary hint line.
  final String? hint;

  /// Optional CTA button label (renders an [AppButton] secondary).
  final String? actionLabel;

  /// Optional CTA handler; shown only with [actionLabel].
  final VoidCallback? onAction;

  /// Tighter vertical rhythm for use inside already-padded cards.
  final bool compact;

  /// Explicit padding override (e.g. EdgeInsets.zero when embedded inside an
  /// already-padded card on a padded screen). Defaults to the standard
  /// empty-state inset (xl horizontal, xl/quadXl vertical).
  final EdgeInsetsGeometry? padding;

  /// Overrides the default [AppTextStyles.headlineMedium] title style —
  /// lets dense per-item placeholders use a quieter caption-style title.
  final TextStyle? titleStyle;

  /// Whether to render the leading [icon] (false for quiet inline
  /// placeholders like per-meal "nothing logged yet" strips).
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 24.0 : AppSpacing.avatarXl - 12.0;
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: compact ? AppSpacing.xl : AppSpacing.quadXl,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              icon,
              size: iconSize,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
          ],
          Text(
            title,
            style: titleStyle ?? AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          if (hint != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              hint!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null) ...[
            SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
            AppButton(
              label: actionLabel!,
              variant: AppButtonVariant.secondary,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
