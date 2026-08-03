// Path: providers\dashboard_state.dart
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

/// A single day's macro breakdown for weekly macro chart.
class WeeklyMacroDay {
  const WeeklyMacroDay({
    required this.label,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.isToday = false,
  });

  final String label;
  final int protein;
  final int carbs;
  final int fat;
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
    this.currentStreak = 12,
    this.longestStreak = 30,
    this.goalCompletionPct = 0.71,
    this.weeklyGoalDays = const [true, true, true, true, false, true, false],
    this.avgCaloriesLastWeek = 1900,
    this.waterConsumed = 1.4,
    this.waterTarget = 2.5,
    this.waterDrinkCount = 4,
    this.weeklyMacros = const [],
    this.currentWeight = 174.5,
    this.lastWeekWeight = 175.7,
    this.lastMonthWeight = 178.0,
    this.bmi = 24.2,
    this.weightTrend = const [],
    this.weightMovingAverage = const [],
    this.sparklineData = const [],
    this.proteinSparkline = const [],
    this.proteinDailyConsistency = const [true, true, false, true, false, true, true],
  });

  final String greeting;
  final int caloriesConsumed;
  final int caloriesTarget;
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

  // Statistics section fields
  final int currentStreak;
  final int longestStreak;
  final double goalCompletionPct;
  final List<bool> weeklyGoalDays;
  final double avgCaloriesLastWeek;
  final double waterConsumed;
  final double waterTarget;
  final int waterDrinkCount;
  final List<WeeklyMacroDay> weeklyMacros;
  final double currentWeight;
  final double lastWeekWeight;
  final double lastMonthWeight;
  final double? bmi;
  final List<double> weightTrend;
  final List<double> weightMovingAverage;
  final List<double> sparklineData;
  final List<double> proteinSparkline;
  final List<bool> proteinDailyConsistency;

  double get weightChange => currentWeight - lastWeekWeight;
  double get monthlyWeightChange => currentWeight - lastMonthWeight;
  double get waterProgress => waterTarget > 0 ? (waterConsumed / waterTarget).clamp(0.0, 1.0) : 0.0;
  double get waterProjected => waterDrinkCount > 0
      ? (waterConsumed / waterDrinkCount) * 6 // estimate 6 drinking sessions/day
      : 0.0;

  /// Returns a copy with the given fields replaced. Used by the dashboard
  /// provider to overlay real food-log data onto the mock base summary.
  DashboardSummary copyWith({
    String? greeting,
    int? caloriesConsumed,
    int? caloriesTarget,
    double? calorieTrendPct,
    List<MacroProgress>? macros,
    List<RecentMeal>? recentMeals,
    List<WeeklyDay>? weekly,
    int? weeklyTarget,
    List<WeeklyStat>? weeklyStats,
    List<DashboardStat>? stats,
    String? coachInsight,
    int? currentStreak,
    int? longestStreak,
    double? goalCompletionPct,
    List<bool>? weeklyGoalDays,
    double? avgCaloriesLastWeek,
    double? waterConsumed,
    double? waterTarget,
    int? waterDrinkCount,
    List<WeeklyMacroDay>? weeklyMacros,
    double? currentWeight,
    double? lastWeekWeight,
    double? lastMonthWeight,
    double? bmi,
    List<double>? weightTrend,
    List<double>? weightMovingAverage,
    List<double>? sparklineData,
    List<double>? proteinSparkline,
    List<bool>? proteinDailyConsistency,
  }) {
    return DashboardSummary(
      greeting: greeting ?? this.greeting,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      calorieTrendPct: calorieTrendPct ?? this.calorieTrendPct,
      macros: macros ?? this.macros,
      recentMeals: recentMeals ?? this.recentMeals,
      weekly: weekly ?? this.weekly,
      weeklyTarget: weeklyTarget ?? this.weeklyTarget,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      stats: stats ?? this.stats,
      coachInsight: coachInsight ?? this.coachInsight,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      goalCompletionPct: goalCompletionPct ?? this.goalCompletionPct,
      weeklyGoalDays: weeklyGoalDays ?? this.weeklyGoalDays,
      avgCaloriesLastWeek: avgCaloriesLastWeek ?? this.avgCaloriesLastWeek,
      waterConsumed: waterConsumed ?? this.waterConsumed,
      waterTarget: waterTarget ?? this.waterTarget,
      waterDrinkCount: waterDrinkCount ?? this.waterDrinkCount,
      weeklyMacros: weeklyMacros ?? this.weeklyMacros,
      currentWeight: currentWeight ?? this.currentWeight,
      lastWeekWeight: lastWeekWeight ?? this.lastWeekWeight,
      lastMonthWeight: lastMonthWeight ?? this.lastMonthWeight,
      bmi: bmi ?? this.bmi,
      weightTrend: weightTrend ?? this.weightTrend,
      weightMovingAverage: weightMovingAverage ?? this.weightMovingAverage,
      sparklineData: sparklineData ?? this.sparklineData,
      proteinSparkline: proteinSparkline ?? this.proteinSparkline,
      proteinDailyConsistency:
          proteinDailyConsistency ?? this.proteinDailyConsistency,
    );
  }
}
