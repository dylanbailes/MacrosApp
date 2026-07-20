// Path: features/dashboard/presentation/providers/dashboard_state.dart
import 'package:flutter/material.dart';

/// Immutable domain model for the Dashboard's daily summary.
///
/// Mock data model used until a backend data source exists. Kept as a plain
/// immutable class (no build_runner dependency) so the dashboard can be built
/// and tested without a server.
class MacroProgress {
  const MacroProgress({
    required this.label,
    required this.consumed,
    required this.target,
    required this.unit,
    required this.color,
  });

  final String label;
  final double consumed;
  final double target;
  final String unit;
  final int color; // Color value passed via AppColors constants

  double get progress => (target <= 0) ? 0.0 : (consumed / target).clamp(0.0, 1.0);
  bool get isOverTarget => consumed > target;
  double get remaining => (target - consumed).clamp(0.0, double.infinity);
}

class RecentMeal {
  const RecentMeal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.timeLabel,
  });

  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String timeLabel;
}

class DashboardStat {
  const DashboardStat({
    required this.label,
    required this.value,
    required this.unit,
    this.icon,
  });

  final String label;
  final String value;
  final String unit;
  final IconData? icon;
}

/// A single day in the weekly calorie overview.
class WeeklyDay {
  const WeeklyDay({
    required this.label,
    required this.calories,
    this.isToday = false,
  });

  final String label;
  final int calories;
  final bool isToday;
}

/// Compact stat shown beneath the weekly overview graph.
class WeeklyStat {
  const WeeklyStat({
    required this.label,
    required this.value,
    this.accent,
  });

  final String label;
  final String value;
  final int? accent;
}

class DashboardSummary {
  const DashboardSummary({
    required this.greeting,
    required this.dateLabel,
    required this.caloriesConsumed,
    required this.caloriesTarget,
    required this.calorieTrendPct,
    required this.macros,
    required this.recentMeals,
    required this.weekly,
    required this.weeklyTarget,
    required this.weeklyStats,
    required this.stats,
    required this.coachInsight,
  });

  final String greeting;
  final String dateLabel;
  final int caloriesConsumed;
  final int caloriesTarget;

  /// Percent change vs yesterday (e.g. 8.0 means +8%).
  final double calorieTrendPct;

  double get calorieProgress =>
      (caloriesTarget <= 0) ? 0.0 : (caloriesConsumed / caloriesTarget).clamp(0.0, 1.0);
  bool get isOverTarget => caloriesConsumed > caloriesTarget;
  int get caloriesRemaining => (caloriesTarget - caloriesConsumed).clamp(0, caloriesTarget);

  final List<MacroProgress> macros;
  final List<RecentMeal> recentMeals;
  final List<WeeklyDay> weekly;
  final int weeklyTarget;
  final List<WeeklyStat> weeklyStats;
  final List<DashboardStat> stats;
  final String coachInsight;
}
