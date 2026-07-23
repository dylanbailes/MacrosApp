// Path: widgets\recent_meals_list.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/dashboard_state.dart';

/// Recent meals: up to 3 compact log rows.
///
/// Reference: Blueprint §2.6 — Log Row (Compact variant). Each row is a
/// dense Row-variant card with a category glyph, name + time, and a calorie
/// count with a 3-dot macro proportion indicator. "View all" → Food Log.
class RecentMealsList extends StatelessWidget {
  const RecentMealsList({
    super.key,
    required this.meals,
    this.onViewAll,
    this.onTapMeal,
  });

  final List<RecentMeal> meals;
  final VoidCallback? onViewAll;
  final void Function(RecentMeal meal)? onTapMeal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < meals.length; i++) ...[
          _CompactMealRow(
            meal: meals[i],
            onTap: () => onTapMeal?.call(meals[i]),
          ),
          if (i < meals.length - 1) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _CompactMealRow extends StatelessWidget {
  const _CompactMealRow({
    required this.meal,
    this.onTap,
  });

  final RecentMeal meal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.row,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      child: Row(
        children: [
          // Category glyph (40×40 rounded square)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppBorderRadius.xs),
            ),
            child: const Icon(
              Icons.restaurant_outlined,
              size: AppSpacing.iconMd,
              color: AppColors.iconDefault,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Name + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: AppTextStyles.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  meal.timeLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          // Calorie count + macro dot indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meal.calories}',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  _MacroDot(color: AppColors.protein),
                  _MacroDot(color: AppColors.carbs),
                  _MacroDot(color: AppColors.fat),
                ],
              ),
            ],
          ),
        ],
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
      margin: const EdgeInsets.only(left: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}