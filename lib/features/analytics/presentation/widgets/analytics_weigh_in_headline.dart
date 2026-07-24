/// Weigh-in headline with Ndot numeral and trend glyph.
///
/// Reference: Blueprint §3.7 — Weight Tracking weigh-in headline.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A prominent weigh-in headline showing current weight with trend direction.
class AnalyticsWeighInHeadline extends StatelessWidget {
  const AnalyticsWeighInHeadline({
    super.key,
    required this.currentWeight,
    required this.trendValue,
    required this.weightChange,
    this.onTap,
  });

  /// Current smoothed trend weight.
  final double currentWeight;

  /// Weekly trend direction (negative = losing, positive = gaining).
  final double trendValue;

  /// Weight change vs last week.
  final double weightChange;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLosing = trendValue < 0;
    final isGaining = trendValue > 0;

    IconData trendIcon;
    Color trendColor;

    if (isLosing) {
      trendIcon = Icons.trending_down_rounded;
      trendColor = AppColors.success;
    } else if (isGaining) {
      trendIcon = Icons.trending_up_rounded;
      trendColor = AppColors.error;
    } else {
      trendIcon = Icons.trending_flat_rounded;
      trendColor = AppColors.warning;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Ndot weight numeral
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CURRENT WEIGHT',
                  style: AppTextStyles.tinyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentWeight.toStringAsFixed(1),
                      style: AppTextStyles.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        'lbs',
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Trend column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(trendIcon, color: trendColor, size: 28),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${weightChange >= 0 ? '+' : ''}${weightChange.toStringAsFixed(1)} lbs',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: trendColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'vs last week',
                  style: AppTextStyles.tiny.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}