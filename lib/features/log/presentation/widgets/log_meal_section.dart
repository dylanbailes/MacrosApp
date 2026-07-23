// Path: widgets/log_meal_section.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'log_food_row.dart';

/// A single food entry data model for the meal section.
class FoodEntry {
  final String name;
  final String servingInfo;
  final int calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
  final IconData? icon;

  const FoodEntry({
    required this.name,
    required this.servingInfo,
    required this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.icon,
  });
}

/// A meal section in the food log (Breakfast, Lunch, Dinner, Snacks).
///
/// Matches the blueprint §3.2 specification: a section header with label
/// and subtotal calories, followed by a stack of food rows.
class LogMealSection extends StatelessWidget {
  const LogMealSection({
    super.key,
    required this.label,
    required this.totalCalories,
    required this.foodEntries,
    this.defaultIcon = Icons.restaurant,
  });

  final String label;
  final int totalCalories;
  final List<FoodEntry> foodEntries;
  final IconData defaultIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.52,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '· $totalCalories kcal',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Food rows
        ...foodEntries.map((entry) => Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.sm,
              ),
              child: LogFoodRow(
                name: entry.name,
                servingInfo: entry.servingInfo,
                calories: entry.calories,
                proteinGrams: entry.proteinGrams,
                carbsGrams: entry.carbsGrams,
                fatGrams: entry.fatGrams,
                icon: entry.icon ?? defaultIcon,
              ),
            )),
      ],
    );
  }
}