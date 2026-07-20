// Path: widgets\app_stat_display.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A compact stat display with a label and value.
///
/// Used in stats rows, summary grids, and quick glance areas.
/// Renders as a small card-like block with value in title style
/// and label in macro-label style beneath it.
class AppStatDisplay extends StatelessWidget {
  const AppStatDisplay({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.subValue,
    this.icon,
    this.elevated = false,
  });

  /// The label text (e.g., "MEALS")
  final String label;

  /// The primary value text (e.g., "12")
  final String value;

  /// Optional color for the value (defaults to onPrimary)
  final Color? valueColor;

  /// Optional secondary value shown alongside the primary
  final String? subValue;

  /// Optional icon shown before the value
  final IconData? icon;

  /// Whether to use elevated background (surfaceElevated vs surface)
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final bgColor = elevated ? AppColors.surfaceElevated : AppColors.surface;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        children: [
          // Value row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: valueColor ?? AppColors.onPrimary,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                value,
                style: AppTextStyles.titleLarge.copyWith(
                  color: valueColor ?? AppColors.onPrimary,
                ),
              ),
              if (subValue != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0, left: 2.0),
                  child: Text(
                    subValue!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Label
          Text(
            label.toUpperCase(),
            style: AppTextStyles.macroLabel,
          ),
        ],
      ),
    );
  }
}