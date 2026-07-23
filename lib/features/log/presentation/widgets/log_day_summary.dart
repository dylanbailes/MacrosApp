// Path: widgets\log_day_summary.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A compact daily summary bar showing calories consumed vs target
/// plus macro chips for protein, carbs, and fat.
///
/// Matches the blueprint §3.2 "Daily Calorie Summary" spec:
/// compact — total consumed vs. target, no ring, just a number + slim bar.
class LogDaySummary extends StatelessWidget {
  const LogDaySummary({
    super.key,
    required this.consumedCalories,
    required this.targetCalories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.proteinTarget,
    this.carbsTarget,
    this.fatTarget,
  });

  final int consumedCalories;
  final int targetCalories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
  final double? proteinTarget;
  final double? carbsTarget;
  final double? fatTarget;

  double get _progress => (consumedCalories / targetCalories).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Calories row
          Row(
            children: [
              Text(
                '$consumedCalories',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'of $targetCalories kcal',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const Spacer(),
              Text(
                '${(_progress * 100).toInt()}%',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 4,
              color: AppColors.divider,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress,
                child: Container(
                  color: AppColors.energyNeutral,
                ),
              ),
            ),
          ),

          // Macro chips
          if (proteinGrams != null ||
              carbsGrams != null ||
              fatGrams != null)
            const SizedBox(height: AppSpacing.md),
          if (proteinGrams != null ||
              carbsGrams != null ||
              fatGrams != null)
            Row(
              children: [
                if (proteinGrams != null)
                  _MacroChip(
                    label: 'P',
                    grams: proteinGrams!,
                    target: proteinTarget ?? 180,
                    color: AppColors.protein,
                  ),
                if (carbsGrams != null)
                  _MacroChip(
                    label: 'C',
                    grams: carbsGrams!,
                    target: carbsTarget ?? 250,
                    color: AppColors.carbs,
                  ),
                if (fatGrams != null)
                  _MacroChip(
                    label: 'F',
                    grams: fatGrams!,
                    target: fatTarget ?? 65,
                    color: AppColors.fat,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({
    required this.label,
    required this.grams,
    required this.target,
    required this.color,
  });

  final String label;
  final double grams;
  final double target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppBorderRadius.xs),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$label ${grams.toInt()}g',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}