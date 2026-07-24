/// Riverpod provider for the Analytics screen.
///
/// Reference: Blueprint §3.6 — Analytics screen.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_state.dart';

/// Provides analytics data with mock data until a backend exists.
final analyticsProvider =
    AsyncNotifierProvider<AnalyticsNotifier, AnalyticsData>(
  AnalyticsNotifier.new,
);

class AnalyticsNotifier extends AsyncNotifier<AnalyticsData> {
  @override
  Future<AnalyticsData> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _mockData();
  }

  AnalyticsData _mockData() {
    final now = DateTime.now();

    // Generate 30 days of calorie data
    final calorieTrend = List.generate(30, (i) {
      final date = now.subtract(Duration(days: 29 - i));
      final dayLabel = '${date.month}/${date.day}';
      // Create a realistic pattern with some variance
      final base = 2000.0;
      final variance = (i % 7) * 100.0 - 300.0;
      final weekend = (date.weekday == 6 || date.weekday == 7) ? 200.0 : 0.0;
      return ChartPoint(
        label: dayLabel,
        value: base + variance + weekend + (i * 5.0),
        isToday: i == 29,
      );
    });

    // Generate 30 days of macro data
    final macroTrend = List.generate(30, (i) {
      final date = now.subtract(Duration(days: 29 - i));
      final dayLabel = '${date.month}/${date.day}';
      return MacroPoint(
        label: dayLabel,
        protein: 120 + (i % 5) * 10.0,
        carbs: 180 + (i % 7) * 15.0 - 50.0,
        fat: 60 + (i % 4) * 8.0,
        isToday: i == 29,
      );
    });

    // Generate weight entries (90 days)
    final weightEntries = List.generate(90, (i) {
      final date = now.subtract(Duration(days: 89 - i));
      final dayLabel = '${date.month}/${date.day}';
      final baseWeight = 175.0 - (i * 0.05);
      final noise = (i % 7) * 0.3 - 1.0;
      return WeightEntry(
        date: dayLabel,
        weight: baseWeight + noise,
        isEstimated: i % 5 == 0,
      );
    });

    // Generate heatmap data (90 days)
    final heatmapDays = List.generate(90, (i) {
      final date = now.subtract(Duration(days: 89 - i));
      final adherence = [0.0, 0.33, 0.66, 1.0][i % 4];
      return HeatmapDay(
        date: date,
        adherence: adherence,
        hasLogs: i % 4 != 0,
      );
    });

    // Recent weight entries
    final recentWeightEntries = List.generate(7, (i) {
      final date = now.subtract(Duration(days: i));
      final dayLabel = '${date.month}/${date.day}';
      return WeightEntry(
        date: dayLabel,
        weight: 174.5 - (i * 0.2),
      );
    });

    return AnalyticsData(
      calorieTrend: calorieTrend,
      macroTrend: macroTrend,
      calorieTarget: 2200,
      weightEntries: weightEntries,
      heatmapDays: heatmapDays,
      weeklyAverages: [
        const WeeklyAverage(label: 'Avg Calories', value: '2,050', unit: 'kcal'),
        WeeklyAverage(label: 'Avg Protein', value: '142', unit: 'g', color: const Color(0xFF3D8BFD)),
        const WeeklyAverage(label: 'Goal Days', value: '5', unit: '/7'),
        WeeklyAverage(label: 'Goal Completion', value: '71', unit: '%', color: const Color(0xFF34D399)),
      ],
      currentWeight: 174.5,
      weightTrendValue: -0.8,
      weightChange: -1.2,
      recentWeightEntries: recentWeightEntries,
    );
  }

  /// Re-fetch analytics data (used by pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => _mockData());
  }
}