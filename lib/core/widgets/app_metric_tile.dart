// Path: widgets\app_metric_tile.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A metric tile showing a label, value, target, and progress bar.
///
/// Reference: Blueprint §2.3 — Macro Tile
/// 
/// Used in the 3-tile row pattern on Dashboard and Analytics.
/// Fixed height 92px so the row never staggers.
class AppMetricTile extends StatelessWidget {
  const AppMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.target,
    required this.color,
    this.progress = 0.0,
    this.isOverTarget = false,
  });

  /// The label text (e.g., "PROTEIN")
  final String label;

  /// The current value text (e.g., "142")
  final String value;

  /// The target text (e.g., "180g")
  final String target;

  /// The semantic color for this metric
  final Color color;

  /// Progress from 0.0 to 1.0
  final double progress;

  /// Whether the value exceeds the target
  final bool isOverTarget;

  @override
  Widget build(BuildContext context) {
    final displayColor = isOverTarget ? AppColors.error : color;

    return Container(
      height: 92,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: AppTextStyles.macroLabel,
          ),
          const Spacer(),
          // Value + Target
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.macroValue.copyWith(color: displayColor),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  '/ $target',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(
                  displayColor.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}