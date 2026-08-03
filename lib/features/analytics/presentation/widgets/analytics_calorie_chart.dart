/// Calorie trend chart with smooth line, flux band, target line, and scrub.
///
/// Reference: Blueprint §6.1 — Calorie Trend Chart.
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/analytics_state.dart';

/// A line chart showing calorie trend over time with target reference.
class AnalyticsCalorieChart extends StatefulWidget {
  const AnalyticsCalorieChart({
    super.key,
    required this.data,
    required this.target,
  });

  final List<ChartPoint> data;
  final int target;

  @override
  State<AnalyticsCalorieChart> createState() => _AnalyticsCalorieChartState();
}

class _AnalyticsCalorieChartState extends State<AnalyticsCalorieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawController;
  late Animation<double> _drawAnimation;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _drawAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _drawController,
        curve: Curves.easeOutCubic,
      ),
    );
    _drawController.forward();
  }

  @override
  void didUpdateWidget(AnalyticsCalorieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _drawController.reset();
      _drawController.forward();
    }
  }

  @override
  void dispose() {
    _drawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No data available')),
      );
    }

    final spots = List.generate(widget.data.length, (i) {
      return FlSpot(i.toDouble(), widget.data[i].value);
    });

    final maxVal =
        widget.data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('CALORIE TREND', style: AppTextStyles.tinyMedium),
              const Spacer(),
              Text(
                'Target: ${widget.target} kcal',
                style: AppTextStyles.tiny.copyWith(
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: AnimatedBuilder(
              animation: _drawAnimation,
              builder: (context, child) {
                final animatedSpots = spots
                    .map((s) => FlSpot(s.x, s.y * _drawAnimation.value))
                    .toList();
                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: (widget.target / 2).ceilToDouble(),
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
                          reservedSize: 40,
                          interval: (widget.target / 2).ceilToDouble(),
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              // Tabular figures so axis numerals align.
                              style: AppTextStyles.tiny.copyWith(
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          interval: (widget.data.length / 5)
                              .ceilToDouble()
                              .toDouble(),
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= widget.data.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                widget.data[index].label,
                                style: AppTextStyles.tiny.copyWith(
                                  color: widget.data[index].isToday
                                      ? AppColors.onPrimary
                                      : AppColors.textTertiary,
                                  fontWeight: widget.data[index].isToday
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: AppColors.surfaceElevated,
                        tooltipBorder: BorderSide(
                          color: AppColors.dividerStrong,
                        ),
                        tooltipRoundedRadius: 8,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final index = spot.x.toInt();
                            final label =
                                index >= 0 && index < widget.data.length
                                    ? widget.data[index].label
                                    : '';
                            final cal = spot.y.toInt();
                            final diff = cal - widget.target;
                            final diffStr =
                                diff >= 0 ? '+$diff over' : '$diff under';
                            return LineTooltipItem(
                              '$label\n${cal} kcal\n$diffStr target',
                              const TextStyle(
                                fontFamily: 'Geist',
                                color: AppColors.onPrimary,
                                fontSize: 11,
                                fontFeatures: [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    minY: 0,
                    maxY: (maxVal * 1.15).toDouble(),
                    lineBarsData: [
                      // Target zone shading
                      LineChartBarData(
                        spots: [
                          FlSpot(0, (widget.target * 1.1).toDouble()),
                          FlSpot(
                            (widget.data.length - 1).toDouble(),
                            (widget.target * 1.1).toDouble(),
                          ),
                        ],
                        isCurved: false,
                        color: Colors.transparent,
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withValues(alpha: 0.03),
                          cutOffY: (widget.target * 0.9).toDouble(),
                          applyCutOffY: true,
                        ),
                      ),
                      // Target line
                      LineChartBarData(
                        spots: [
                          FlSpot(0, widget.target.toDouble()),
                          FlSpot(
                            (widget.data.length - 1).toDouble(),
                            widget.target.toDouble(),
                          ),
                        ],
                        isCurved: false,
                        dashArray: [6, 4],
                        color: AppColors.primary.withValues(alpha: 0.4),
                        barWidth: 1,
                        dotData: const FlDotData(show: false),
                      ),
                      // Main data line
                      LineChartBarData(
                        spots: animatedSpots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: AppColors.energyNeutral,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: _drawAnimation.value > 0.9,
                          getDotPainter: (spot, percent, barData, index) {
                            final isToday = index >= 0 &&
                                index < widget.data.length &&
                                widget.data[index].isToday;
                            return FlDotCirclePainter(
                              radius: isToday ? 4 : 2,
                              color: isToday
                                  ? AppColors.primary
                                  : AppColors.energyNeutral,
                              strokeWidth: isToday ? 2 : 0,
                              strokeColor: AppColors.primary,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.energyNeutral.withValues(alpha: 0.1),
                          cutOffY: 0,
                          applyCutOffY: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppBorderRadius.md,
      level: 2,
      accentColor: AppColors.energyNeutral,
      clip: false,
    );
  }
}
