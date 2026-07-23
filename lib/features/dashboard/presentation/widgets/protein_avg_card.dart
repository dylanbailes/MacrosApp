// Path: widgets\protein_avg_card.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_interactive_card.dart';
import '../providers/dashboard_state.dart';

/// Protein average card with target, 7-day sparkline, and daily consistency dots.
///
/// Nothing OS style: number in dot matrix, labels in Geist, protein blue accent.
class ProteinAvgCard extends StatelessWidget {
  const ProteinAvgCard({
    super.key,
    required this.protein,
    required this.proteinSparkline,
    required this.proteinDailyConsistency,
  });

  final MacroProgress protein;
  final List<double> proteinSparkline;
  final List<bool> proteinDailyConsistency;

  @override
  Widget build(BuildContext context) {
    return AppInteractiveCard(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            Text('PROTEIN AVG', style: AppTextStyles.tinyMedium),
            const SizedBox(height: AppSpacing.xs),
            // Number
            Text(
              '${protein.consumed.toInt()}',
              style: AppTextStyles.cardMetric.copyWith(
                color: AppColors.protein,
              ),
            ),
            const SizedBox(height: 2),
            // Target
            Text(
              '/ ${protein.target.toInt()}g target',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.sm),
            // Thin progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: protein.progress,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.protein),
                minHeight: 3,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // 7-day sparkline
            SizedBox(
              height: 24,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(proteinSparkline.length, (i) {
                        return FlSpot(i.toDouble(), proteinSparkline[i]);
                      }),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: AppColors.protein,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.protein.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                  lineTouchData: const LineTouchData(enabled: false),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Daily consistency dots
            Row(
              children: List.generate(proteinDailyConsistency.length, (i) {
                final isHit = proteinDailyConsistency[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isHit ? AppColors.protein : AppColors.divider,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      padding: EdgeInsets.zero,
      borderRadius: AppBorderRadius.md,
      level: 1,
      accentColor: AppColors.protein,
      clip: false,
    );
  }
}