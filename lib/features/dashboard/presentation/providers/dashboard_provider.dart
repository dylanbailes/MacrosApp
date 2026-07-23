// Path: providers\dashboard_provider.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_state.dart';

/// Provides the Dashboard's daily summary.
///
/// Until a backend exists, this returns mock data after a short simulated
/// delay so the dashboard's skeleton loading state is exercised (Blueprint §4.2).
final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardSummary>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardSummary> {
  @override
  Future<DashboardSummary> build() async {
    // Simulate a network fetch so the skeleton loading state is visible.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockSummary();
  }

  DashboardSummary _mockSummary() {
    final now = DateTime.now();
    final dateLabel =
        '${_weekday(now.weekday)} ${now.month}/${now.day}';

    return DashboardSummary(
      greeting: 'Good afternoon',
      dateLabel: dateLabel,
      caloriesConsumed: 1240,
      caloriesTarget: 2200,
      calorieTrendPct: 8.0,
      macros: const [
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
      recentMeals: const [
        RecentMeal(
          id: 'm1',
          name: 'Grilled Chicken Salad',
          calories: 350,
          protein: 30,
          carbs: 20,
          fat: 10,
          timeLabel: '12:30 PM',
        ),
        RecentMeal(
          id: 'm2',
          name: 'Quinoa Bowl',
          calories: 420,
          protein: 25,
          carbs: 35,
          fat: 15,
          timeLabel: '9:15 AM',
        ),
        RecentMeal(
          id: 'm3',
          name: 'Protein Smoothie',
          calories: 280,
          protein: 40,
          carbs: 10,
          fat: 5,
          timeLabel: '8:00 AM',
        ),
      ],
      weekly: const [
        WeeklyDay(label: 'Mon', calories: 1980),
        WeeklyDay(label: 'Tue', calories: 2100),
        WeeklyDay(label: 'Wed', calories: 1850),
        WeeklyDay(label: 'Thu', calories: 2200),
        WeeklyDay(label: 'Fri', calories: 1750),
        WeeklyDay(label: 'Sat', calories: 2400),
        WeeklyDay(label: 'Sun', calories: 1240, isToday: true),
      ],
      weeklyTarget: 2200,
      weeklyStats: const [
        WeeklyStat(label: 'Avg Calories', value: '2,050'),
        WeeklyStat(label: 'Avg Protein', value: '142g', accent: 0xFF3D8BFD),
        WeeklyStat(label: 'Goal Days', value: '5/7'),
        WeeklyStat(label: 'Streak', value: '12', accent: 0xFFFF6B5E),
      ],
      stats: const [
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
      weeklyGoalDays: const [true, true, true, true, false, true, false],
      avgCaloriesLastWeek: 1900,
      waterConsumed: 1.4,
      waterTarget: 2.5,
      waterDrinkCount: 4,
      weeklyMacros: const [
        WeeklyMacroDay(label: 'Mon', protein: 120, carbs: 180, fat: 65),
        WeeklyMacroDay(label: 'Tue', protein: 145, carbs: 200, fat: 70),
        WeeklyMacroDay(label: 'Wed', protein: 110, carbs: 160, fat: 55),
        WeeklyMacroDay(label: 'Thu', protein: 155, carbs: 210, fat: 75),
        WeeklyMacroDay(label: 'Fri', protein: 100, carbs: 150, fat: 50),
        WeeklyMacroDay(label: 'Sat', protein: 160, carbs: 220, fat: 80),
        WeeklyMacroDay(label: 'Sun', protein: 96, carbs: 132, fat: 41, isToday: true),
      ],
      currentWeight: 174.5,
      lastWeekWeight: 175.7,
      lastMonthWeight: 178.0,
      bmi: 24.2,
      weightTrend: const [176.2, 175.8, 175.5, 175.0, 174.8, 174.6, 174.5],
      weightMovingAverage: const [175.9, 175.7, 175.5, 175.3, 175.1, 174.9, 174.7],
      sparklineData: const [2100, 1980, 2050, 2200, 1850, 2400, 1240],
      proteinSparkline: const [140, 132, 128, 145, 118, 150, 96],
      proteinDailyConsistency: const [true, true, false, true, false, true, true],
    );
  }

  String _weekday(int day) {
    const names = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return names[(day - 1) % 7];
  }

  /// Re-fetch the summary (used by pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => _mockSummary());
  }
}