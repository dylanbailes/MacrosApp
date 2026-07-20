// Path: features/dashboard/presentation/widgets/stats_grid.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_stat_display.dart';
import '../providers/dashboard_state.dart';

/// Useful statistics grid for the Dashboard.
///
/// Reference: Blueprint §3.1 — Weekly Snapshot / Useful Statistics. A 2×2 grid
/// of AppStatDisplay blocks (streak, goal-hit rate, avg calories, water).
class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.stats,
  });

  final List<DashboardStat> stats;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.6,
      children: [
        for (final stat in stats)
          AppStatDisplay(
            label: stat.label,
            value: stat.value,
            subValue: stat.unit,
            icon: stat.icon,
          ),
      ],
    );
  }
}