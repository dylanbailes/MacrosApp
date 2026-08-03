// Path: widgets/log_meal_section.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/formatting/app_formatters.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../domain/domain.dart';

/// A meal section in the food log (Breakfast, Lunch, Dinner, Snacks).
///
/// Matches the blueprint §3.2 specification: a section header with label
/// and subtotal calories, followed by a stack of [AppListRow] food rows.
/// Empty meals show a subtle "nothing logged yet" placeholder instead of a
/// bare header.
class LogMealSection extends StatelessWidget {
  const LogMealSection({
    required this.label,
    required this.entries,
    this.onTapEntry,
    this.onDeleteEntry,
    this.defaultIcon = Icons.restaurant,
    super.key,
  });

  final String label;
  final List<LoggedFoodEntry> entries;
  final void Function(LoggedFoodEntry entry)? onTapEntry;
  final void Function(LoggedFoodEntry entry)? onDeleteEntry;
  final IconData defaultIcon;

  int get totalCalories => entries.fold(0, (sum, e) => sum + e.calories);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with subtotal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AppSectionHeader(
            label: label,
            // Keep the dense log header's quiet label look.
            labelStyle: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.52,
            ),
            trailing: Text(
              '· $totalCalories kcal',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        if (entries.isEmpty)
          // Quiet per-meal empty placeholder (no icon, caption-style title)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                border: Border.all(color: AppColors.divider, width: 1),
              ),
              child: AppEmptyState(
                showIcon: false,
                title: 'Nothing logged yet',
                titleStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          )
        else
          // Food rows
          ...entries.map((entry) => Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: AppSpacing.sm,
                ),
                child: AppListRow(
                  title: entry.foodName,
                  subtitle:
                      '${entry.servingLabel} · ${AppFormatters.timeOfDay(entry.loggedAt)}',
                  icon: defaultIcon,
                  trailing: AppListRowTrailing(
                    value: '${entry.calories}',
                    dots: [
                      AppColors.protein,
                      AppColors.carbs,
                      AppColors.fat,
                    ],
                  ),
                  onTap: onTapEntry == null ? null : () => onTapEntry!(entry),
                  onDelete: onDeleteEntry == null
                      ? null
                      : () => onDeleteEntry!(entry),
                ),
              )),
      ],
    );
  }
}
