// Path: features/dashboard/presentation/widgets/weekly_calories_chart.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/dashboard_state.dart';

/// Hero 7-day calorie chart with smooth curved line, red accent,
/// subtle grid, touch tooltip, animated drawing, ambient glow,
/// target-zone shading, and richer interactive feedback.
///
/// Nothing OS style: premium visualization, restrained red, Geist labels.
class WeeklyCaloriesChart extends ConsumerStatefulWidget {
  const WeeklyCaloriesChart({
    required this.days, required this.target, super.key,
  });

  final List<WeeklyDay> days;
  final int target;

  @override
  ConsumerState<WeeklyCaloriesChart> createState() =>
      _WeeklyCaloriesChartState();
}

class _WeeklyCaloriesChartState extends ConsumerState<WeeklyCaloriesChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawController;
  late Animation<double> _drawAnimation;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
  void dispose() {
    _drawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(widget.days.length, (i) {
      return FlSpot(i.toDouble(), widget.days[i].calories.toDouble());
    });

    final maxCalories = widget.days
        .map((d) => d.calories)
        .reduce((a, b) => a > b ? a : b);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppBorderRadius.md,
      level: 2,
      accentColor: AppColors.primary,
      clip: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            children: [
              Text('7-DAY CALORIES', style: AppTextStyles.tinyMedium),
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
          // Chart
          AnimatedBuilder(
            animation: _drawAnimation,
            builder: (context, child) {
              final animatedSpots = spots
                  .map((s) => FlSpot(s.x, s.y * _drawAnimation.value))
                  .toList();
              return SizedBox(
                height: 160,
                child: LineChart(
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
                        axisNameWidget: const SizedBox.shrink(),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: (widget.target / 2).ceilToDouble(),
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: AppTextStyles.tiny,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const SizedBox.shrink(),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= widget.days.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                widget.days[index].label,
                                style: AppTextStyles.tiny.copyWith(
                                  color: widget.days[index].isToday
                                      ? AppColors.onPrimary
                                      : AppColors.textTertiary,
                                  fontWeight: widget.days[index].isToday
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
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final index = spot.x.toInt();
                            final label = index >= 0 &&
                                    index < widget.days.length
                                ? widget.days[index].label
                                : '';
                            final cal = spot.y.toInt();
                            final diff = cal - widget.target;
                            final diffStr = diff >= 0
                                ? '+$diff over'
                                : '$diff under';
                            return LineTooltipItem(
                              '$label\n${cal} kcal\n$diffStr target',
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
                    minY: 0,
                    maxY: (maxCalories * 1.15).toDouble(),
                    lineBarsData: [
                      // Target zone shading (subtle band around target)
                      LineChartBarData(
                        spots: [
                          FlSpot(0, (widget.target * 1.1).toDouble()),
                          FlSpot((widget.days.length - 1).toDouble(),
                              (widget.target * 1.1).toDouble()),
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
                          FlSpot((widget.days.length - 1).toDouble(),
                              widget.target.toDouble()),
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
                        color: AppColors.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: _drawAnimation.value > 0.9,
                          getDotPainter: (spot, percent, barData, index) {
                            final isToday = index >= 0 &&
                                index < widget.days.length &&
                                widget.days[index].isToday;
                            return FlDotCirclePainter(
                              radius: isToday ? 5 : 2.5,
                              color: isToday
                                  ? AppColors.primary
                                  : AppColors.onPrimary,
                              strokeWidth: isToday ? 2.5 : 0,
                              strokeColor: AppColors.primary,
                            );
                          },
                        ),
                        // Stronger gradient beneath line
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withValues(alpha: 0.12),
                          cutOffY: 0,
                          applyCutOffY: true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
