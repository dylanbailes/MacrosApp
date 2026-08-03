/// Calendar-grid logging heatmap showing daily adherence.
///
/// Reference: Blueprint §6.6 — Logging Heatmap.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/analytics_state.dart';

/// A heatmap calendar grid showing daily logging adherence.
class AnalyticsHeatmap extends StatelessWidget {
  const AnalyticsHeatmap({
    super.key,
    required this.days,
  });

  final List<HeatmapDay> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('LOGGING ACTIVITY', style: AppTextStyles.tinyMedium),
              const Spacer(),
              Row(
                children: [
                  _LegendDot(adherence: 0.0),
                  const SizedBox(width: AppSpacing.xs),
                  _LegendDot(adherence: 0.33),
                  const SizedBox(width: AppSpacing.xs),
                  _LegendDot(adherence: 0.66),
                  const SizedBox(width: AppSpacing.xs),
                  _LegendDot(adherence: 1.0),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCalendarGrid(),
          const SizedBox(height: AppSpacing.sm),
          // Day-of-week labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => SizedBox(
                      width: 16,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.tiny.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppBorderRadius.md,
      level: 2,
      clip: false,
    );
  }

  Widget _buildCalendarGrid() {
    // Group days into weeks (rows of 7)
    final weeks = <List<HeatmapDay?>>[];
    List<HeatmapDay?> currentWeek = [];

    // Pad the start to align with day of week
    if (days.isNotEmpty) {
      final firstDayOfWeek = days.first.date.weekday - 1; // Monday = 0
      for (var i = 0; i < firstDayOfWeek; i++) {
        currentWeek.add(null);
      }
    }

    for (final day in days) {
      currentWeek.add(day);
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
    }

    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    return Column(
      children: weeks.map((week) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: week.map((day) {
              return Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: day != null ? _adherenceColor(day.adherence) : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Color _adherenceColor(double adherence) {
    if (adherence <= 0) return AppColors.surface;
    if (adherence <= 0.33) return AppColors.success.withValues(alpha: 0.25);
    if (adherence <= 0.66) return AppColors.success.withValues(alpha: 0.5);
    return AppColors.success.withValues(alpha: 0.85);
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.adherence});

  final double adherence;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: adherence <= 0
          ? 'No logs'
          : adherence <= 0.33
              ? 'Low'
              : adherence <= 0.66
                  ? 'Medium'
                  : 'High',
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: _adherenceColorStatic(adherence),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

Color _adherenceColorStatic(double adherence) {
  if (adherence <= 0) return AppColors.surface;
  if (adherence <= 0.33) return AppColors.success.withValues(alpha: 0.25);
  if (adherence <= 0.66) return AppColors.success.withValues(alpha: 0.5);
  return AppColors.success.withValues(alpha: 0.85);
}