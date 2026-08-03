/// Macro trend chart with 3 overlaid lines and legend filtering.
///
/// Reference: Blueprint §6.2 — Macro Trend Chart.
library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/analytics_state.dart';

/// A chart showing 3 overlaid macro trend lines with a legend row.
class AnalyticsMacroChart extends StatefulWidget {
  const AnalyticsMacroChart({
    super.key,
    required this.data,
  });

  final List<MacroPoint> data;

  @override
  State<AnalyticsMacroChart> createState() => _AnalyticsMacroChartState();
}

class _AnalyticsMacroChartState extends State<AnalyticsMacroChart> {
  bool _showProtein = true;
  bool _showCarbs = true;
  bool _showFat = true;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No data available')),
      );
    }

    maxVal() {
      double max = 0;
      for (final d in widget.data) {
        if (_showProtein && d.protein > max) max = d.protein;
        if (_showCarbs && d.carbs > max) max = d.carbs;
        if (_showFat && d.fat > max) max = d.fat;
      }
      return max;
    }

    final proteinSpots = List.generate(widget.data.length, (i) {
      return FlSpot(i.toDouble(), widget.data[i].protein);
    });
    final carbsSpots = List.generate(widget.data.length, (i) {
      return FlSpot(i.toDouble(), widget.data[i].carbs);
    });
    final fatSpots = List.generate(widget.data.length, (i) {
      return FlSpot(i.toDouble(), widget.data[i].fat);
    });

    final lineData = <LineChartBarData>[
      if (_showProtein)
        LineChartBarData(
          spots: proteinSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.protein,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      if (_showCarbs)
        LineChartBarData(
          spots: carbsSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.carbs,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      if (_showFat)
        LineChartBarData(
          spots: fatSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.fat,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('MACRO TREND', style: AppTextStyles.tinyMedium),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Legend row
          Row(
            children: [
              _LegendItem(
                label: 'Protein',
                color: AppColors.protein,
                isActive: _showProtein,
                onTap: () => setState(() => _showProtein = !_showProtein),
              ),
              const SizedBox(width: AppSpacing.md),
              _LegendItem(
                label: 'Carbs',
                color: AppColors.carbs,
                isActive: _showCarbs,
                onTap: () => setState(() => _showCarbs = !_showCarbs),
              ),
              const SizedBox(width: AppSpacing.md),
              _LegendItem(
                label: 'Fat',
                color: AppColors.fat,
                isActive: _showFat,
                onTap: () => setState(() => _showFat = !_showFat),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 180,
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
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}g',
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
                      interval:
                          (widget.data.length / 5).ceilToDouble().toDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= widget.data.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          widget.data[index].label,
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
                    tooltipBorder: BorderSide(
                      color: AppColors.dividerStrong,
                    ),
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        final label = index >= 0 && index < widget.data.length
                            ? widget.data[index].label
                            : '';
                        Color lineColor;
                        if (spot.barIndex == 0 && _showProtein) {
                          lineColor = AppColors.protein;
                        } else if ((spot.barIndex == 0 && !_showProtein) ||
                            (spot.barIndex == 1 && _showCarbs)) {
                          lineColor = AppColors.carbs;
                        } else {
                          lineColor = AppColors.fat;
                        }
                        return LineTooltipItem(
                          '$label\n${spot.y.toInt()}g',
                          TextStyle(
                            fontFamily: 'Geist',
                            color: lineColor,
                            fontSize: 11,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                minY: 0,
                maxY: maxVal() * 1.2,
                lineBarsData: lineData,
              ),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppBorderRadius.md,
      level: 2,
      clip: false,
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? color : color.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.tiny.copyWith(
              color: isActive ? color : color.withValues(alpha: 0.4),
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
