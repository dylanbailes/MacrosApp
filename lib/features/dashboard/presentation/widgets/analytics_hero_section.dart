// Path: features/dashboard/presentation/widgets/analytics_hero_section.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_animated_counter.dart';
import '../../../../core/widgets/app_progress_ring.dart';
import '../providers/dashboard_state.dart';
import 'weekly_overview_chart.dart';

/// Responsive hero section combining calorie progress and weekly analytics.
///
/// Desktop: two-column (35% left, 65% right).
/// Mobile/narrow: stacked top-to-bottom.
class AnalyticsHeroSection extends StatelessWidget {
  const AnalyticsHeroSection({
    super.key,
    required this.summary,
    this.onTap,
  });

  final DashboardSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;
    
    if (isWide) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 35,
              child: _CalorieColumn(
                caloriesConsumed: summary.caloriesConsumed,
                caloriesTarget: summary.caloriesTarget,
                trendPct: summary.calorieTrendPct,
                onTap: onTap,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 65,
              child: _WeeklyColumn(
                days: summary.weekly,
                target: summary.weeklyTarget,
                stats: summary.weeklyStats,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CalorieColumn(
          caloriesConsumed: summary.caloriesConsumed,
          caloriesTarget: summary.caloriesTarget,
          trendPct: summary.calorieTrendPct,
          onTap: onTap,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        _WeeklyColumn(
          days: summary.weekly,
          target: summary.weeklyTarget,
          stats: summary.weeklyStats,
        ),
      ],
    );
  }
}

class _CalorieColumn extends StatelessWidget {
  const _CalorieColumn({
    required this.caloriesConsumed,
    required this.caloriesTarget,
    required this.trendPct,
    this.onTap,
  });

  final int caloriesConsumed;
  final int caloriesTarget;
  final double trendPct;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = (caloriesTarget <= 0) ? 0.0 : (caloriesConsumed / caloriesTarget).clamp(0.0, 1.0);
    final isOver = caloriesConsumed > caloriesTarget;
    final remaining = (caloriesTarget - caloriesConsumed).clamp(0, caloriesTarget);

    return AppCard(
      variant: AppCardVariant.hero,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: AppProgressRing(
              progress: progress,
              size: 160,
              strokeWidth: 10,
              color: isOver ? AppColors.error : AppColors.energyNeutral,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAnimatedCounter(
                      value: caloriesConsumed,
                      style: AppTextStyles.displayLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'of $caloriesTarget kcal',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            isOver 
                ? 'Over by ${(caloriesConsumed - caloriesTarget).abs()} kcal'
                : '$remaining kcal remaining',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Goal: $caloriesTarget kcal/day',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${trendPct >= 0 ? '+' : ''}${trendPct.toStringAsFixed(0)}% vs yesterday',
            style: AppTextStyles.caption.copyWith(
              color: trendPct >= 0 ? AppColors.primary : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyColumn extends StatelessWidget {
  const _WeeklyColumn({
    required this.days,
    required this.target,
    required this.stats,
  });

  final List<WeeklyDay> days;
  final int target;
  final List<WeeklyStat> stats;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.standard,
      backgroundColor: AppColors.surfaceElevated,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEEKLY OVERVIEW',
            style: AppTextStyles.sectionHeader,
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart takes most of the space
                Expanded(
                  flex: 3,
                  child: WeeklyOverviewChart(days: days, target: target),
                ),
                const SizedBox(width: AppSpacing.md),
                // Vertical stats on right
                _WeeklyStatsVertical(stats: stats),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyStatsVertical extends StatelessWidget {
  const _WeeklyStatsVertical({required this.stats});

  final List<WeeklyStat> stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final stat in stats) ...[
          _WeeklyStatVertical(
            label: stat.label,
            value: stat.value,
            accent: stat.accent,
          ),
          if (stat != stats.last) const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}

class _WeeklyStatVertical extends StatelessWidget {
  const _WeeklyStatVertical({
    required this.label,
    required this.value,
    this.accent,
  });

  final String label;
  final String value;
  final int? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent != null 
        ? Color(accent!) 
        : AppColors.onPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Nothing',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Nothing',
            fontSize: 9,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}