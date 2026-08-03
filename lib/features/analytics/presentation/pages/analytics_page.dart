/// The Analytics page with detailed trend data and insights.
///
/// Reference: Blueprint §3.6 — Analytics screen.
/// Features Nutrition and Weight segments with varied chart types.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_segmented_control.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_stat_display.dart';
import '../../../../core/widgets/app_toast.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/analytics_calorie_chart.dart';
import '../widgets/analytics_heatmap.dart';
import '../widgets/analytics_macro_chart.dart';
import '../widgets/analytics_recent_entries.dart';
import '../widgets/analytics_search_bar.dart';
import '../widgets/analytics_weigh_in_headline.dart';
import '../widgets/analytics_weight_chart.dart';

/// Nutrition / Weight segment switch options.
const _segmentOptions = [
  AppSegmentedOption(value: AnalyticsSegment.nutrition, label: 'Nutrition'),
  AppSegmentedOption(value: AnalyticsSegment.weight, label: 'Weight'),
];

/// Chart range-tab options (Blueprint §2.8 — Range Tabs).
const _rangeOptions = [
  AppSegmentedOption(value: AnalyticsRange.week1, label: '1W'),
  AppSegmentedOption(value: AnalyticsRange.month1, label: '1M'),
  AppSegmentedOption(value: AnalyticsRange.month3, label: '3M'),
  AppSegmentedOption(value: AnalyticsRange.month6, label: '6M'),
  AppSegmentedOption(value: AnalyticsRange.year1, label: '1Y'),
  AppSegmentedOption(value: AnalyticsRange.all, label: 'ALL'),
];

/// The Analytics page.
///
/// Composed of a shared [AppScreenHeader], the kit [AppSegmentedControl] for
/// both the Nutrition/Weight switch and the chart range tabs, and varied data
/// presentations: line charts, multi-line charts, heatmaps, stat cards via
/// [AppStatDisplay], and weigh-in headlines.
class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  AnalyticsSegment _segment = AnalyticsSegment.nutrition;
  AnalyticsRange _range = AnalyticsRange.month1;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(analyticsProvider);
    final notifier = ref.read(analyticsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surfaceElevated,
          onRefresh: notifier.refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // Page header (the page sliver provides the margin).
                      const AppScreenHeader(
                        title: 'Analytics',
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Search bar
                      AnalyticsSearchBar(
                        onChanged: (query, range) {
                          setState(() => _searchQuery = query);
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Nutrition / Weight segment switch
                      AppSegmentedControl<AnalyticsSegment>(
                        options: _segmentOptions,
                        value: _segment,
                        onChanged: (segment) =>
                            setState(() => _segment = segment),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Content based on segment
                      if (analyticsAsync.isLoading)
                        const _AnalyticsSkeleton()
                      else if (analyticsAsync.hasError)
                        _ErrorState(onRetry: notifier.refresh)
                      else if (analyticsAsync.hasValue)
                        _AnalyticsContent(
                          data: analyticsAsync.value!,
                          segment: _segment,
                          range: _range,
                          searchQuery: _searchQuery,
                          onRangeChanged: (range) =>
                              setState(() => _range = range),
                        ),

                      // Bottom padding for nav bar
                      const SizedBox(height: AppSpacing.quadXl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The main analytics content, switching between Nutrition and Weight.
class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({
    required this.data,
    required this.segment,
    required this.range,
    required this.searchQuery,
    required this.onRangeChanged,
  });

  final AnalyticsData data;
  final AnalyticsSegment segment;
  final AnalyticsRange range;
  final String searchQuery;
  final ValueChanged<AnalyticsRange> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    // Apply search filter - simple implementation
    final showCalories =
        searchQuery.isEmpty || searchQuery.toLowerCase().contains('calorie');
    final showMacros = searchQuery.isEmpty ||
        searchQuery.toLowerCase().contains('macro') ||
        searchQuery.toLowerCase().contains('protein') ||
        searchQuery.toLowerCase().contains('carbs') ||
        searchQuery.toLowerCase().contains('fat');
    final showWeight =
        searchQuery.isEmpty || searchQuery.toLowerCase().contains('weight');

    if (segment == AnalyticsSegment.nutrition) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Range tabs
          AppSegmentedControl<AnalyticsRange>(
            options: _rangeOptions,
            value: range,
            onChanged: onRangeChanged,
          ),
          const SizedBox(height: AppSpacing.lg),

          // The charts carry their own header row.
          if (showCalories) ...[
            AnalyticsCalorieChart(
              data: data.calorieTrend,
              target: data.calorieTarget,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],

          if (showMacros) ...[
            AnalyticsMacroChart(data: data.macroTrend),
            const SizedBox(height: AppSpacing.xxxl),
          ],

          // Weekly Averages
          const AppSectionHeader(label: 'Weekly Averages'),
          const SizedBox(height: AppSpacing.sm),
          _buildWeeklyAverages(data),
          const SizedBox(height: AppSpacing.xxxl),

          // Logging Heatmap
          const AppSectionHeader(label: 'Logging Activity'),
          const SizedBox(height: AppSpacing.sm),
          AnalyticsHeatmap(days: data.heatmapDays),
        ],
      );
    } else {
      // Weight segment
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showWeight) ...[
            AnalyticsWeighInHeadline(
              currentWeight: data.currentWeight,
              trendValue: data.weightTrendValue,
              weightChange: data.weightChange,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          if (showWeight) ...[
            AppSegmentedControl<AnalyticsRange>(
              options: _rangeOptions,
              value: range,
              onChanged: onRangeChanged,
            ),
            const SizedBox(height: AppSpacing.lg),
            AnalyticsWeightChart(entries: data.weightEntries),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Log Weight button
          AppButton(
            label: 'Log Weight',
            icon: Icons.monitor_weight_outlined,
            variant: AppButtonVariant.primary,
            isFullWidth: true,
            onPressed: () =>
                showAppToast(context, message: 'Weight logging coming soon'),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Recent Entries
          if (showWeight) ...[
            AnalyticsRecentEntries(entries: data.recentWeightEntries),
          ],
        ],
      );
    }
  }

  Widget _buildWeeklyAverages(AnalyticsData data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: data.weeklyAverages.map((avg) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: SizedBox(
              width: 140,
              child: AppStatDisplay(
                label: avg.label,
                value: avg.value,
                unit: avg.unit,
                valueColor: avg.color,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Skeleton loading state for the analytics page.
class _AnalyticsSkeleton extends StatelessWidget {
  const _AnalyticsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Range tabs skeleton
        const AppSkeleton(
            width: 300, height: 32, borderRadius: AppBorderRadius.pill),
        const SizedBox(height: AppSpacing.lg),
        // Chart skeleton
        const AppSkeleton(
          width: double.infinity,
          height: 200,
          borderRadius: AppBorderRadius.md,
        ),
        const SizedBox(height: AppSpacing.xl),
        // Another chart skeleton
        const AppSkeleton(
          width: double.infinity,
          height: 180,
          borderRadius: AppBorderRadius.md,
        ),
        const SizedBox(height: AppSpacing.xl),
        // Stat cards row
        Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              const Expanded(
                child: AppSkeleton(
                  width: double.infinity,
                  height: 80,
                  borderRadius: AppBorderRadius.sm,
                ),
              ),
              if (i < 3) const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({this.onRetry});

  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "Couldn't load analytics data",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            GestureDetector(
              onTap: onRetry,
              child: Text(
                'Try again',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
