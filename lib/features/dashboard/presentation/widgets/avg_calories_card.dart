// Path: features/dashboard/presentation/widgets/avg_calories_card.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_interactive_card.dart';

/// Average calories card with trend arrow, +/-, "vs last week" label,
/// and tiny sparkline.
///
/// Nothing OS style: numbers in dot matrix, labels in Geist.
class AvgCaloriesCard extends StatelessWidget {
  const AvgCaloriesCard({
    super.key,
    required this.avgCalories,
    required this.avgCaloriesLastWeek,
    required this.sparklineData,
  });

  final int avgCalories;
  final double avgCaloriesLastWeek;
  final List<double> sparklineData;

  double get _changePct => avgCaloriesLastWeek > 0
      ? ((avgCalories - avgCaloriesLastWeek) / avgCaloriesLastWeek) * 100
      : 0.0;

  bool get _isUp => _changePct > 0;
  bool get _isFlat => _changePct.abs() < 1;

  @override
  Widget build(BuildContext context) {
    return AppInteractiveCard(
      padding: EdgeInsets.zero,
      borderRadius: AppBorderRadius.md,
      level: 1,
      accentColor: AppColors.primary,
      clip: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('AVG CALORIES', style: AppTextStyles.tinyMedium),
              const SizedBox(height: AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$avgCalories', style: AppTextStyles.cardMetric),
                  const SizedBox(width: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isFlat ? Icons.remove : _isUp ? Icons.trending_up : Icons.trending_down,
                          size: 14,
                          color: _isFlat ? AppColors.textTertiary : _isUp ? AppColors.primary : AppColors.success,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${_changePct >= 0 ? '+' : ''}${_changePct.toStringAsFixed(0)}%',
                          style: AppTextStyles.tiny.copyWith(
                            color: _isFlat ? AppColors.textTertiary : _isUp ? AppColors.primary : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text('vs ${avgCaloriesLastWeek.toInt()} last week', style: AppTextStyles.tiny),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 28,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(sparklineData.length, (i) => FlSpot(i.toDouble(), sparklineData[i])),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: AppColors.primary,
                        barWidth: 1.5,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.1)),
                      ),
                    ],
                    lineTouchData: const LineTouchData(enabled: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}