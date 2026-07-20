// Path: features/dashboard/presentation/providers/dashboard_provider.dart
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