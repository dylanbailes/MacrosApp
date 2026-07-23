// Path: widgets/log_food_row.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single food entry row in the log.
///
/// Matches the blueprint §2.6 Log Row spec:
/// - Left: small 40×40 rounded-square food-category glyph
/// - Middle: food name + serving size/time stacked
/// - Right: calorie number + small P/C/F macro dot row
class LogFoodRow extends StatelessWidget {
  const LogFoodRow({
    super.key,
    required this.name,
    required this.servingInfo,
    required this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.icon = Icons.restaurant,
    this.onTap,
  });

  final String name;
  final String servingInfo;
  final int calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(
          children: [
            // Food category glyph
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.iconDefault,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Name + serving info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.headlineMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    servingInfo,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Calories + macro dots
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$calories',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (proteinGrams != null ||
                    carbsGrams != null ||
                    fatGrams != null)
                  const SizedBox(height: 4),
                if (proteinGrams != null ||
                    carbsGrams != null ||
                    fatGrams != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (proteinGrams != null)
                        _MacroDot(color: AppColors.protein),
                      if (carbsGrams != null)
                        _MacroDot(color: AppColors.carbs),
                      if (fatGrams != null)
                        _MacroDot(color: AppColors.fat),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroDot extends StatelessWidget {
  const _MacroDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}