// Path: features/dashboard/presentation/widgets/recent_meals_list.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../providers/dashboard_state.dart';

/// Recent meals: up to 3 compact log rows.
///
/// Reference: Blueprint §2.6 — Log Row (Compact variant). Each row is a dense
/// Row-variant card with a category glyph, name + time, and a calorie count
/// with a 3-dot macro proportion indicator — via the shared [AppListRow].
/// When nothing is logged, shows an [AppEmptyState] instead of a blank gap.
class RecentMealsList extends StatelessWidget {
  const RecentMealsList({
    required this.meals,
    super.key,
    this.onViewAll,
    this.onTapMeal,
    this.onSearchFoods,
  });

  final List<RecentMeal> meals;
  final VoidCallback? onViewAll;
  final void Function(RecentMeal meal)? onTapMeal;

  /// CTA from the empty state → food search.
  final VoidCallback? onSearchFoods;

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      // Match the surface treatment of the populated rows: a standard card
      // with the empty state inset inside it. Padding is zeroed so the
      // page's own screen margin isn't doubled.
      return AppCard(
        child: AppEmptyState(
          icon: Icons.restaurant_outlined,
          title: 'No meals logged yet',
          hint: 'Search for a food to add your first entry.',
          actionLabel: onSearchFoods != null ? 'Search foods' : null,
          onAction: onSearchFoods,
          compact: true,
          padding: EdgeInsets.zero,
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < meals.length; i++) ...[
          AppListRow(
            title: meals[i].name,
            subtitle: meals[i].timeLabel,
            trailing: AppListRowTrailing(
              value: '${meals[i].calories}',
              dots: const [
                AppColors.protein,
                AppColors.carbs,
                AppColors.fat,
              ],
            ),
            onTap: () => onTapMeal?.call(meals[i]),
          ),
          if (i < meals.length - 1) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
