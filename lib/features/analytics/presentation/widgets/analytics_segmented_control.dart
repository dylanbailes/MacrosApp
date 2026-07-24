/// Segmented control for toggling between Nutrition and Weight views.
///
/// Reference: Blueprint §3.6 — Analytics screen segmented control.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/analytics_state.dart';

/// A pill-style segmented control for Analytics segment selection.
class AnalyticsSegmentedControl extends StatelessWidget {
  const AnalyticsSegmentedControl({
    super.key,
    required this.segment,
    required this.onChanged,
  });

  final AnalyticsSegment segment;
  final ValueChanged<AnalyticsSegment> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.pill),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _SegmentButton(
            label: 'Nutrition',
            isSelected: segment == AnalyticsSegment.nutrition,
            onTap: () => onChanged(AnalyticsSegment.nutrition),
          ),
          const SizedBox(width: AppSpacing.xs),
          _SegmentButton(
            label: 'Weight',
            isSelected: segment == AnalyticsSegment.weight,
            onTap: () => onChanged(AnalyticsSegment.weight),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}