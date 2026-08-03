// Path: features/dashboard/presentation/widgets/weekly_macros_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/dashboard_state.dart';

/// Weekly macros stacked bar chart showing Protein/Carbs/Fat per day.
///
/// Nothing OS style: clean geometric bars, restrained color palette,
/// monochrome labels.
class WeeklyMacrosChart extends StatefulWidget {
  const WeeklyMacrosChart({
    required this.macroDays, super.key,
  });

  final List<WeeklyMacroDay> macroDays;

  @override
  State<WeeklyMacrosChart> createState() => _WeeklyMacrosChartState();
}

class _WeeklyMacrosChartState extends State<WeeklyMacrosChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.macroDays.isEmpty) return const SizedBox.shrink();

    // Find max total across all days for scaling
    final maxTotal = widget.macroDays
        .map((d) => d.protein + d.carbs + d.fat)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

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
          // Label
          Text('MACROS THIS WEEK', style: AppTextStyles.tinyMedium),
          const SizedBox(height: AppSpacing.md),
          // Legend row
          Row(
            children: [
              _LegendDot(color: AppColors.protein, label: 'Protein'),
              const SizedBox(width: AppSpacing.md),
              _LegendDot(color: AppColors.carbs, label: 'Carbs'),
              const SizedBox(width: AppSpacing.md),
              _LegendDot(color: AppColors.fat, label: 'Fat'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Stacked bar chart
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                height: 100,
                child: BarChart(
                  BarChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const SizedBox.shrink(),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 16,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= widget.macroDays.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                widget.macroDays[index].label,
                                style: AppTextStyles.tiny.copyWith(
                                  color: widget.macroDays[index].isToday
                                      ? AppColors.onPrimary
                                      : AppColors.textTertiary,
                                  fontWeight: widget.macroDays[index].isToday
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
                    barGroups: List.generate(widget.macroDays.length, (i) {
                      final day = widget.macroDays[i];
                      final total =
                          (day.protein + day.carbs + day.fat).toDouble();
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: total * _animation.value,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(5),
                            ),
                            rodStackItems: [
                              BarChartRodStackItem(
                                0,
                                (day.protein * _animation.value).toDouble(),
                                AppColors.protein.withValues(alpha: 0.9),
                              ),
                              BarChartRodStackItem(
                                (day.protein * _animation.value).toDouble(),
                                ((day.protein + day.carbs) *
                                        _animation.value)
                                    .toDouble(),
                                AppColors.carbs.withValues(alpha: 0.9),
                              ),
                              BarChartRodStackItem(
                                ((day.protein + day.carbs) *
                                        _animation.value)
                                    .toDouble(),
                                ((day.protein + day.carbs + day.fat) *
                                        _animation.value)
                                    .toDouble(),
                                AppColors.fat.withValues(alpha: 0.9),
                              ),
                            ],
                            color: Colors.transparent,
                          ),
                        ],
                      );
                    }),
                    maxY: maxTotal * 1.15,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final day = widget.macroDays[group.x];
                          return BarTooltipItem(
                            '${day.label}\nP: ${day.protein}g\nC: ${day.carbs}g\nF: ${day.fat}g',
                            const TextStyle(
                              fontFamily: 'Geist',
                              color: AppColors.onPrimary,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
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

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.tiny,
          ),
      ],
    );
  }
}