/// Recent weight entries list for the Weight segment.
///
/// Reference: Blueprint §3.7 — Weight Tracking recent entries.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/analytics_state.dart';

/// A list of recent weight entries with date, value, and delta.
class AnalyticsRecentEntries extends StatelessWidget {
  const AnalyticsRecentEntries({
    super.key,
    required this.entries,
  });

  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT ENTRIES',
            style: AppTextStyles.tinyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(entries.length, (i) {
            final entry = entries[i];
            final delta = i < entries.length - 1
                ? entry.weight - entries[i + 1].weight
                : 0.0;
            return Padding(
              padding: EdgeInsets.only(
                bottom: i < entries.length - 1 ? AppSpacing.sm : 0,
              ),
              child: Row(
                children: [
                  Text(
                    entry.date,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    entry.weight.toStringAsFixed(1),
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'lbs',
                    style: AppTextStyles.caption,
                  ),
                  const Spacer(),
                  if (i < entries.length - 1) ...[
                    Icon(
                      delta >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 14,
                      color: delta >= 0
                          ? AppColors.error
                          : AppColors.success,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)}',
                      style: AppTextStyles.tiny.copyWith(
                        color: delta >= 0
                            ? AppColors.error
                            : AppColors.success,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}