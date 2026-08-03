// Path: providers\dashboard_provider.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/app_formatters.dart';
import '../../../../features/log/domain/domain.dart';
import '../../../../features/log/presentation/providers/food_providers.dart';
import '../../../../features/settings/presentation/providers/settings_providers.dart';
import 'dashboard_state.dart';

/// Provides the Dashboard's daily summary.
///
/// The calorie ring, macro tiles, recent-meals list, and the weekly overview
/// are **real** — they come from the food log via [dailyLogProvider].
/// Sections that don't have a data source yet (water, weight, streaks)
/// keep their mock base values so the dashboard stays fully populated.
final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardSummary>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardSummary> {
  @override
  Future<DashboardSummary> build() async {
    // Simulate a network fetch so the skeleton loading state is visible.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // Goals come from the shared settings (editable on Profile/Settings) so
    // the hero ring, macro tiles, and weekly target all move together.
    final goals = ref.watch(settingsProvider);

    // Follow the shared viewed date (the header's ◀ today ▶ stepper), so the
    // dashboard always describes the same day as the Log page.
    final selected = dayOf(ref.watch(selectedDateProvider));
    final today = selected;
    final yesterday = dayOf(selected.subtract(const Duration(days: 1)));
    final todayLog = await ref.watch(dailyLogProvider(today).future);
    final yesterdayLog = await ref.watch(dailyLogProvider(yesterday).future);
    final week = await _weekData(selected, goals.calorieTarget);

    return _mockSummary().copyWith(
      caloriesConsumed: todayLog.totalCalories,
      caloriesTarget: goals.calorieTarget,
      macros: _realMacros(todayLog, goals),
      recentMeals: _recentMeals(todayLog),
      calorieTrendPct:
          _trendPct(todayLog.totalCalories, yesterdayLog.totalCalories),
      weekly: week.days,
      weeklyTarget: goals.calorieTarget,
      weeklyStats: week.stats,
      // Keep the Streak card in sync with the weekly overview (same week of
      // real data). longestStreak stays an all-time placeholder.
      weeklyGoalDays: week.goalFlags,
      currentStreak: week.streak,
    );
  }

  // ── Real data mapping ─────────────────────────────────────────────────

  List<MacroProgress> _realMacros(DayLog log, SettingsState goals) {
    return [
      MacroProgress(
        label: 'Protein',
        consumed: log.totalProtein,
        target: goals.proteinTarget.toDouble(),
        unit: 'g',
        color: 0xFF3D8BFD,
      ),
      MacroProgress(
        label: 'Carbs',
        consumed: log.totalCarbs,
        target: goals.carbsTarget.toDouble(),
        unit: 'g',
        color: 0xFFFFB020,
      ),
      MacroProgress(
        label: 'Fat',
        consumed: log.totalFat,
        target: goals.fatTarget.toDouble(),
        unit: 'g',
        color: 0xFFFF6B5E,
      ),
    ];
  }

  /// The most recent logged entries (up to 3), newest first.
  List<RecentMeal> _recentMeals(DayLog log) {
    final sorted = [...log.entries]
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    return [
      for (final entry in sorted.take(3))
        RecentMeal(
          id: entry.id,
          name: entry.foodName,
          calories: entry.calories,
          protein: entry.protein.round(),
          carbs: entry.carbs.round(),
          fat: entry.fat.round(),
          timeLabel: AppFormatters.timeOfDay(entry.loggedAt),
        ),
    ];
  }

  /// Day-over-day calorie change.
  ///
  /// With no baseline (empty yesterday) the change is effectively unbounded,
  /// so show a clean +100% only when there's something to compare today;
  /// otherwise 0%.
  double _trendPct(int today, int yesterday) {
    if (yesterday <= 0) return today > 0 ? 100 : 0;
    return ((today - yesterday) / yesterday) * 100;
  }

  /// Real 7-day calorie data for the weekly overview, ending on [end] (the
  /// day being viewed). Each day's total comes from the food log; the stats
  /// (avg calories/protein, goal days, hit streak) derive from the same week
  /// and move with the date navigator.
  Future<
      ({
        List<WeeklyDay> days,
        List<WeeklyStat> stats,
        List<bool> goalFlags,
        int streak,
      })> _weekData(
    DateTime end,
    int calorieTarget,
  ) async {
    final realToday = dayOf(DateTime.now());
    final days = <WeeklyDay>[];
    final totals = <int>[];
    final proteins = <double>[];

    for (var i = 6; i >= 0; i--) {
      final day = DateTime(end.year, end.month, end.day - i);
      final log = await ref.watch(dailyLogProvider(day).future);
      totals.add(log.totalCalories);
      proteins.add(log.totalProtein);
      days.add(WeeklyDay(
        label: _weekdayShort(day.weekday),
        calories: log.totalCalories,
        isToday: day == realToday,
      ));
    }

    final avgCalories = totals.reduce((a, b) => a + b) / totals.length;
    final avgProtein = proteins.reduce((a, b) => a + b) / proteins.length;
    final goalDays = totals.where((c) => c >= calorieTarget).length;
    final streak = _currentStreak(totals, calorieTarget);

    return (
      days: days,
      stats: [
        WeeklyStat(
          label: 'Avg Calories',
          value: AppFormatters.comma(avgCalories.round()),
        ),
        WeeklyStat(
          label: 'Avg Protein',
          value: '${avgProtein.round()}g',
          accent: 0xFF3D8BFD,
        ),
        WeeklyStat(label: 'Goal Days', value: '$goalDays/7'),
        WeeklyStat(
          label: 'Streak',
          value: '$streak',
          accent: 0xFFFF6B5E,
        ),
      ],
      goalFlags: [for (final c in totals) c >= calorieTarget],
      streak: streak,
    );
  }

  /// Consecutive days ending at the last day of [totals] (the viewed day)
  /// that met the calorie target.
  static int _currentStreak(List<int> totals, int calorieTarget) {
    var streak = 0;
    for (var i = totals.length - 1; i >= 0; i--) {
      if (totals[i] >= calorieTarget) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static String _weekdayShort(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  // ── Mock base (unchanged sections) ────────────────────────────────────

  DashboardSummary _mockSummary() {
    return const DashboardSummary(
      greeting: 'Good afternoon',
      caloriesConsumed: 0,
      caloriesTarget: 2200,
      calorieTrendPct: 0,
      macros: [
        MacroProgress(
          label: 'Protein',
          consumed: 96,
          target: 165,
          unit: 'g',
          color: 0xFF3D8BFD,
        ),
        MacroProgress(
          label: 'Carbs',
          consumed: 132,
          target: 220,
          unit: 'g',
          color: 0xFFFFB020,
        ),
        MacroProgress(
          label: 'Fat',
          consumed: 41,
          target: 73,
          unit: 'g',
          color: 0xFFFF6B5E,
        ),
      ],
      recentMeals: [],
      // The weekly overview is always overlaid with real 7-day data in
      // build(), so the mock base keeps it empty.
      weekly: [],
      weeklyTarget: 2200,
      weeklyStats: [],
      stats: [
        DashboardStat(
          label: 'Streak',
          value: '12',
          unit: 'days',
          icon: Icons.local_fire_department,
        ),
        DashboardStat(
          label: 'Goal Hit Rate',
          value: '5',
          unit: '/ 7',
          icon: Icons.check_circle_outline,
        ),
        DashboardStat(
          label: 'Avg Calories',
          value: '1980',
          unit: 'kcal',
          icon: Icons.show_chart,
        ),
        DashboardStat(
          label: 'Water',
          value: '1.4',
          unit: 'L',
          icon: Icons.water_drop,
        ),
      ],
      coachInsight:
          'Your protein has been low 3 days running — want a suggestion?',
      // Extended statistics data
      longestStreak: 30,
      goalCompletionPct: 0.71,
      weeklyGoalDays: [true, true, true, true, false, true, false],
      avgCaloriesLastWeek: 1900,
      waterConsumed: 1.4,
      waterTarget: 2.5,
      waterDrinkCount: 4,
      weeklyMacros: [
        WeeklyMacroDay(label: 'Mon', protein: 120, carbs: 180, fat: 65),
        WeeklyMacroDay(label: 'Tue', protein: 145, carbs: 200, fat: 70),
        WeeklyMacroDay(label: 'Wed', protein: 110, carbs: 160, fat: 55),
        WeeklyMacroDay(label: 'Thu', protein: 155, carbs: 210, fat: 75),
        WeeklyMacroDay(label: 'Fri', protein: 100, carbs: 150, fat: 50),
        WeeklyMacroDay(label: 'Sat', protein: 160, carbs: 220, fat: 80),
        WeeklyMacroDay(
            label: 'Sun', protein: 96, carbs: 132, fat: 41, isToday: true),
      ],
      currentWeight: 174.5,
      lastWeekWeight: 175.7,
      lastMonthWeight: 178.0,
      bmi: 24.2,
      weightTrend: [176.2, 175.8, 175.5, 175.0, 174.8, 174.6, 174.5],
      weightMovingAverage: [175.9, 175.7, 175.5, 175.3, 175.1, 174.9, 174.7],
      sparklineData: [2100, 1980, 2050, 2200, 1850, 2400, 1240],
      proteinSparkline: [140, 132, 128, 145, 118, 150, 96],
      proteinDailyConsistency: [true, true, false, true, false, true, true],
    );
  }

  /// Re-fetch the summary (used by pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
