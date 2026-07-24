/// Range tabs for selecting the analytics time window.
///
/// Reference: Blueprint §2.8 — Chip / Segmented Control / Range Tabs.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/analytics_state.dart';

/// Horizontal scrollable range tabs for chart time windows.
class AnalyticsRangeTabs extends StatelessWidget {
  const AnalyticsRangeTabs({
    super.key,
    required this.range,
    required this.onChanged,
  });

  final AnalyticsRange range;
  final ValueChanged<AnalyticsRange> onChanged;

  @override
  Widget build(BuildContext context) {
    final ranges = const [
      (AnalyticsRange.week1, '1W'),
      (AnalyticsRange.month1, '1M'),
      (AnalyticsRange.month3, '3M'),
      (AnalyticsRange.month6, '6M'),
      (AnalyticsRange.year1, '1Y'),
      (AnalyticsRange.all, 'ALL'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: ranges.map((r) {
          final isSelected = range == r.$1;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onChanged(r.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.divider,
                  ),
                ),
                child: Text(
                  r.$2,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textTertiary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}