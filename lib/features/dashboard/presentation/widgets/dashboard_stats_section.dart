// Path: widgets\dashboard_stats_section.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../providers/dashboard_state.dart';
import 'streak_card.dart';
import 'goal_completion_card.dart';
import 'avg_calories_card.dart';
import 'water_card.dart';
import 'protein_avg_card.dart';
import 'weekly_calories_chart.dart';
import 'weekly_macros_chart.dart';
import 'weight_trend_card.dart';

/// Main statistics section composer for the Dashboard.
///
/// Desktop-first masonry layout with varied card sizes:
/// - Hero cards: Full width, 200px height (calories chart, macros chart)
/// - Medium cards: 3-per-row, square-ish (streak, goals, avg calories)
/// - Compact cards: 3-per-row, portrait (water, protein, weight)
///
/// Responsive breakpoints:
/// - Desktop (≥1024px): Full 3-column masonry
/// - Tablet (600-1024px): 2-column grid
/// - Mobile (<600px): Single column
///
/// Nothing OS inspired: asymmetric, information-dense, clean geometry.
class DashboardStatsSection extends StatelessWidget {
  const DashboardStatsSection({
    super.key,
    required this.summary,
  });

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final desktop = screenWidth >= 1024;
    final tablet = screenWidth >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(label: 'Statistics'),
        SizedBox(height: desktop ? AppSpacing.xl : AppSpacing.lg),

        // Medium cards: Streak, Goals, Avg Calories
        _buildMediumRow(context, desktop),

        SizedBox(height: desktop ? AppSpacing.xl : AppSpacing.lg),

        // Hero row: 7-Day Calories Chart
        WeeklyCaloriesChart(
          days: summary.weekly,
          target: summary.weeklyTarget,
        ),

        SizedBox(height: desktop ? AppSpacing.xl : AppSpacing.lg),

        // Hero row: Weekly Macros Chart
        WeeklyMacrosChart(macroDays: summary.weeklyMacros),

        SizedBox(height: desktop ? AppSpacing.xl : AppSpacing.lg),

        // Compact cards: Water, Protein, Weight
        _buildCompactRow(context, desktop, tablet),
      ],
    );
  }

  Widget _buildMediumRow(BuildContext context, bool desktop) {
    if (desktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: StreakCard(
            currentStreak: _parseStat(0, 12),
            longestStreak: summary.longestStreak,
          )),
          const SizedBox(width: AppSpacing.lg),
          Expanded(child: GoalCompletionCard(
            percentage: summary.goalCompletionPct,
            daysCompleted: summary.weeklyGoalDays.where((b) => b).length,
            daysTotal: summary.weeklyGoalDays.length,
            weeklyGoalDays: summary.weeklyGoalDays,
          )),
          const SizedBox(width: AppSpacing.lg),
          Expanded(child: AvgCaloriesCard(
            avgCalories: _parseStat(2, 1980),
            avgCaloriesLastWeek: summary.avgCaloriesLastWeek,
            sparklineData: summary.sparklineData,
          )),
        ],
      );
    }

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: [
        SizedBox(
          width: _cardWidth(context),
          child: StreakCard(
            currentStreak: _parseStat(0, 12),
            longestStreak: summary.longestStreak,
          ),
        ),
        SizedBox(
          width: _cardWidth(context),
          child: GoalCompletionCard(
            percentage: summary.goalCompletionPct,
            daysCompleted: summary.weeklyGoalDays.where((b) => b).length,
            daysTotal: summary.weeklyGoalDays.length,
            weeklyGoalDays: summary.weeklyGoalDays,
          ),
        ),
        if (_isTwoColumn(context))
          SizedBox(
            width: double.infinity,
            child: AvgCaloriesCard(
              avgCalories: _parseStat(2, 1980),
              avgCaloriesLastWeek: summary.avgCaloriesLastWeek,
              sparklineData: summary.sparklineData,
            ),
          )
        else
          SizedBox(
            width: _cardWidth(context),
            child: AvgCaloriesCard(
              avgCalories: _parseStat(2, 1980),
              avgCaloriesLastWeek: summary.avgCaloriesLastWeek,
              sparklineData: summary.sparklineData,
            ),
          ),
      ],
    );
  }

  Widget _buildCompactRow(BuildContext context, bool desktop, bool tablet) {
    if (desktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: WaterCard(
            consumed: summary.waterConsumed,
            goal: summary.waterTarget,
            drinkCount: summary.waterDrinkCount,
            projected: summary.waterProjected,
          )),
          const SizedBox(width: AppSpacing.lg),
          Expanded(child: ProteinAvgCard(
            protein: summary.macros.isNotEmpty ? summary.macros[0] : const MacroProgress(label: 'Protein', consumed: 0, target: 165, unit: 'g', color: 0xFF3D8BFD),
            proteinSparkline: summary.proteinSparkline,
            proteinDailyConsistency: summary.proteinDailyConsistency,
          )),
          const SizedBox(width: AppSpacing.lg),
          Expanded(child: WeightTrendCard(
            currentWeight: summary.currentWeight,
            weightChange: summary.weightChange,
            monthlyWeightChange: summary.monthlyWeightChange,
            weightTrend: summary.weightTrend,
            weightMovingAverage: summary.weightMovingAverage,
            bmi: summary.bmi,
          )),
        ],
      );
    }

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: [
        SizedBox(
          width: _cardWidth(context),
          child: WaterCard(
            consumed: summary.waterConsumed,
            goal: summary.waterTarget,
            drinkCount: summary.waterDrinkCount,
            projected: summary.waterProjected,
          ),
        ),
        SizedBox(
          width: _cardWidth(context),
          child: ProteinAvgCard(
            protein: summary.macros.isNotEmpty ? summary.macros[0] : const MacroProgress(label: 'Protein', consumed: 0, target: 165, unit: 'g', color: 0xFF3D8BFD),
            proteinSparkline: summary.proteinSparkline,
            proteinDailyConsistency: summary.proteinDailyConsistency,
          ),
        ),
        SizedBox(
          width: _cardWidth(context),
          child: WeightTrendCard(
            currentWeight: summary.currentWeight,
            weightChange: summary.weightChange,
            monthlyWeightChange: summary.monthlyWeightChange,
            weightTrend: summary.weightTrend,
            weightMovingAverage: summary.weightMovingAverage,
            bmi: summary.bmi,
          ),
        ),
      ],
    );
  }

  int _parseStat(int index, int defaultValue) {
    if (index < summary.stats.length) {
      return int.tryParse(summary.stats[index].value) ?? defaultValue;
    }
    return defaultValue;
  }

  double _cardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 2 * AppSpacing.xl;
    if (width >= 600) {
      return (width - AppSpacing.lg) / 2;
    }
    return width;
  }

  bool _isTwoColumn(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }
}