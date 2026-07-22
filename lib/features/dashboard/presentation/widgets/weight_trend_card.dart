// Path: features/dashboard/presentation/widgets/weight_trend_card.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_interactive_card.dart';

/// Weight trend card with mini line chart, latest weight, weekly change,
/// monthly trend, moving average, and BMI.
///
/// Nothing OS style: numbers in dot matrix, labels in Geist.
class WeightTrendCard extends StatelessWidget {
  const WeightTrendCard({
    super.key,
    required this.currentWeight,
    required this.weightChange,
    required this.monthlyWeightChange,
    required this.weightTrend,
    required this.weightMovingAverage,
    this.bmi,
  });

  final double currentWeight;
  final double weightChange;
  final double monthlyWeightChange;
  final List<double> weightTrend;
  final List<double> weightMovingAverage;
  final double? bmi;

  bool get _isDown => weightChange < 0;
  bool get _isFlat => weightChange.abs() < 0.2;

  @override
  Widget build(BuildContext context) {
    return AppInteractiveCard(
      padding: EdgeInsets.zero,
      borderRadius: AppBorderRadius.md,
      level: 1,
      accentColor: AppColors.success,
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
              Text('WEIGHT', style: AppTextStyles.tinyMedium),
              const SizedBox(height: AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(currentWeight.toStringAsFixed(1), style: AppTextStyles.cardMetric),
                  const SizedBox(width: 2),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'lb',
                      style: const TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 11,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isFlat ? Icons.remove : _isDown ? Icons.trending_down : Icons.trending_up,
                          size: 14,
                          color: _isFlat ? AppColors.textTertiary : _isDown ? AppColors.success : AppColors.primary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${weightChange >= 0 ? '+' : ''}${weightChange.toStringAsFixed(1)}',
                          style: AppTextStyles.tiny.copyWith(
                            color: _isFlat ? AppColors.textTertiary : _isDown ? AppColors.success : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'wk: ${weightChange >= 0 ? '+' : ''}${weightChange.toStringAsFixed(1)}',
                    style: AppTextStyles.tiny.copyWith(
                      color: _isFlat ? AppColors.textTertiary : _isDown ? AppColors.success : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'mo: ${monthlyWeightChange >= 0 ? '+' : ''}${monthlyWeightChange.toStringAsFixed(1)}',
                    style: AppTextStyles.tiny.copyWith(
                      color: monthlyWeightChange < 0 ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (bmi != null) ...[
                const SizedBox(height: 2),
                Text('BMI ${bmi!.toStringAsFixed(1)}', style: AppTextStyles.tiny),
              ],
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 36,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(weightTrend.length, (i) => FlSpot(i.toDouble(), weightTrend[i])),
                        isCurved: true,
                        curveSmoothness: 0.4,
                        color: AppColors.textTertiary.withValues(alpha: 0.5),
                        barWidth: 1,
                        dotData: const FlDotData(show: false),
                      ),
                      if (weightMovingAverage.length == weightTrend.length)
                        LineChartBarData(
                          spots: List.generate(weightMovingAverage.length, (i) => FlSpot(i.toDouble(), weightMovingAverage[i])),
                          isCurved: true,
                          curveSmoothness: 0.4,
                          color: AppColors.success,
                          barWidth: 1.5,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: true, color: AppColors.success.withValues(alpha: 0.1)),
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