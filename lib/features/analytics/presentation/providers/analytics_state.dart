/// Analytics domain models for trend data and insights.
///
/// Reference: Blueprint §3.6 — Analytics screen.
library;

import 'package:flutter/material.dart';

/// A single data point for chart display.
class ChartPoint {
  const ChartPoint({
    required this.label,
    required this.value,
    this.isToday = false,
  });

  final String label;
  final double value;
  final bool isToday;
}

/// A day's macro breakdown for the macro trend chart.
class MacroPoint {
  const MacroPoint({
    required this.label,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.isToday = false,
  });

  final String label;
  final double protein;
  final double carbs;
  final double fat;
  final bool isToday;
}

/// A single weight entry.
class WeightEntry {
  const WeightEntry({
    required this.date,
    required this.weight,
    this.isEstimated = false,
  });

  final String date;
  final double weight;
  final bool isEstimated;
}

/// A single day in the logging heatmap.
class HeatmapDay {
  const HeatmapDay({
    required this.date,
    required this.adherence, // 0.0 - 1.0
    required this.hasLogs,
  });

  final DateTime date;
  final double adherence;
  final bool hasLogs;
}

/// Weekly average stat displayed in the summary row.
class WeeklyAverage {
  const WeeklyAverage({
    required this.label,
    required this.value,
    required this.unit,
    this.color,
  });

  final String label;
  final String value;
  final String unit;
  final Color? color;
}

/// Analytics segment type.
enum AnalyticsSegment { nutrition, weight }

/// Analytics time range.
enum AnalyticsRange { week1, month1, month3, month6, year1, all }

/// Complete analytics data model.
class AnalyticsData {
  const AnalyticsData({
    required this.calorieTrend,
    required this.macroTrend,
    required this.calorieTarget,
    required this.weightEntries,
    required this.heatmapDays,
    required this.weeklyAverages,
    required this.currentWeight,
    required this.weightTrendValue,
    required this.weightChange,
    required this.recentWeightEntries,
  });

  /// Daily calorie data for the trend chart.
  final List<ChartPoint> calorieTrend;

  /// Daily macro data for the macro trend chart.
  final List<MacroPoint> macroTrend;

  /// Daily calorie target.
  final int calorieTarget;

  /// Weight entries for the weight chart.
  final List<WeightEntry> weightEntries;

  /// Days for the logging heatmap.
  final List<HeatmapDay> heatmapDays;

  /// Weekly average stats.
  final List<WeeklyAverage> weeklyAverages;

  /// Current smoothed trend weight.
  final double currentWeight;

  /// Weekly weight trend value (direction).
  final double weightTrendValue;

  /// Weight change vs last week.
  final double weightChange;

  /// Recent weight entries for the list.
  final List<WeightEntry> recentWeightEntries;
}