/// Weight trend chart with raw entry markers, smoothed trend line, and flux band.
///
/// Reference: Blueprint §6.3 — Weight Trend Chart.
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_interactive_card.dart';
import '../providers/analytics_state.dart';

/// A weight trend chart showing raw entries as dots and a smoothed trend line.
class AnalyticsWeightChart extends StatelessWidget {
  const AnalyticsWeightChart({
    super.key,
    required this.entries,
  });

  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No weight data available')),
      );
    }

    final spots = List.generate(entries.length, (i) {
      return FlSpot(i.toDouble(), entries[i].weight);
    });

    // Compute a simple moving average for the trend line
    final trendSpots = List.generate(entries.length, (i) {
      final start = (i - 3).clamp(0, entries.length);
      final end = (i + 4).clamp(0, entries.length);
      final slice = entries.sublist(start, end);
      final avg = slice.map((e) => e.weight).reduce((a, b) => a + b) / slice.length;
      return FlSpot(i.toDouble(), avg);
    });

    final minWeight = entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    final maxWeight = entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
    final weightRange = maxWeight - minWeight;
    final padding = weightRange * 0.15;

    return AppInteractiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('WEIGHT TREND', style: AppTextStyles.tinyMedium),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.divider.withValues(alpha: 0.15),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}',
                          style: AppTextStyles.tiny,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: (entries.length / 7).ceilToDouble().toDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= entries.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          entries[index].date,
                          style: AppTextStyles.tiny,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppColors.surfaceElevated,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        final date = index >= 0 && index < entries.length
                            ? entries[index].date
                            : '';
                        return LineTooltipItem(
                          '$date\n${spot.y.toStringAsFixed(1)} lbs',
                          const TextStyle(
                            fontFamily: 'Geist',
                            color: AppColors.onPrimary,
                            fontSize: 11,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                minY: (minWeight - padding).floorToDouble(),
                maxY: (maxWeight + padding).ceilToDouble(),
                lineBarsData: [
                  // Flux/confidence band
                  LineChartBarData(
                    spots: [
                      ...trendSpots.map((s) => FlSpot(s.x, s.y + 0.5)),
                      ...trendSpots.reversed.map((s) => FlSpot(s.x, s.y - 0.5)),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.weight.withValues(alpha: 0.08),
                    barWidth: 0,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.weight.withValues(alpha: 0.08),
                    ),
                  ),
                  // Smoothed trend line
                  LineChartBarData(
                    spots: trendSpots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.weight,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Raw entry markers
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: Colors.transparent,
                    barWidth: 0,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final isEstimated = index >= 0 &&
                            index < entries.length &&
                            entries[index].isEstimated;
                        return FlDotCirclePainter(
                          radius: 3,
                          color: isEstimated
                              ? AppColors.textTertiary
                              : AppColors.textSecondary,
                          strokeWidth: 0,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppBorderRadius.md,
      level: 2,
      accentColor: AppColors.weight,
      clip: false,
    );
  }
}