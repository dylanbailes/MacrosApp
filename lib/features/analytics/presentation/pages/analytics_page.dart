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
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../providers/analytics_provider.dart';
import '../providers/analytics_state.dart';
import '../widgets/analytics_calorie_chart.dart';
import '../widgets/analytics_heatmap.dart';
import '../widgets/analytics_macro_chart.dart';
import '../widgets/analytics_range_tabs.dart';
import '../widgets/analytics_recent_entries.dart';
import '../widgets/analytics_search_bar.dart';
import '../widgets/analytics_segmented_control.dart';
import '../widgets/analytics_stat_card.dart';
import '../widgets/analytics_weigh_in_headline.dart';
import '../widgets/analytics_weight_chart.dart';

/// The Analytics page.
///
/// Composed of a segmented control (Nutrition / Weight), search bar,
/// and varied data presentations: line charts, multi-line charts,
/// scatter charts, heatmaps, stat cards, and weigh-in headlines.
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
                      // Page Header
                      Text(
                        'Analytics',
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Search Bar
                      AnalyticsSearchBar(
                        onChanged: (query, range) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Segmented Control
                      AnalyticsSegmentedControl(
                        segment: _segment,
                        onChanged: (segment) {
                          setState(() => _segment = segment);
                        },
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
                          onRangeChanged: (range) {
                            setState(() => _range = range);
                          },
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
    final showCalories = searchQuery.isEmpty ||
        searchQuery.toLowerCase().contains('calorie');
    final showMacros = searchQuery.isEmpty ||
        searchQuery.toLowerCase().contains('macro') ||
        searchQuery.toLowerCase().contains('protein') ||
        searchQuery.toLowerCase().contains('carbs') ||
        searchQuery.toLowerCase().contains('fat');
    final showWeight = searchQuery.isEmpty ||
        searchQuery.toLowerCase().contains('weight');

    if (segment == AnalyticsSegment.nutrition) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nutrition content
          AnalyticsRangeTabs(
            range: range,
            onChanged: onRangeChanged,
          ),
          const SizedBox(height: AppSpacing.lg),

          if (showCalories) ...[
            Text('CALORIE TREND', style: AppTextStyles.tinyMedium),
            const SizedBox(height: AppSpacing.sm),
            AnalyticsCalorieChart(
              data: data.calorieTrend,
              target: data.calorieTarget,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],

          if (showMacros) ...[
            Text('MACRO TREND', style: AppTextStyles.tinyMedium),
            const SizedBox(height: AppSpacing.sm),
            AnalyticsMacroChart(data: data.macroTrend),
            const SizedBox(height: AppSpacing.xxxl),
          ],

          // Weekly Averages
          Text('WEEKLY AVERAGES', style: AppTextStyles.tinyMedium),
          const SizedBox(height: AppSpacing.sm),
          _buildWeeklyAverages(data),
          const SizedBox(height: AppSpacing.xxxl),

          // Logging Heatmap
          Text('LOGGING ACTIVITY', style: AppTextStyles.tinyMedium),
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
            AnalyticsRangeTabs(
              range: range,
              onChanged: onRangeChanged,
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('WEIGHT TREND', style: AppTextStyles.tinyMedium),
            const SizedBox(height: AppSpacing.sm),
            AnalyticsWeightChart(entries: data.weightEntries),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Log Weight button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Weight logging coming soon'),
                    backgroundColor: AppColors.surfaceGlass,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                ),
                child: const Text(
                  'Log Weight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Geist',
                    color: AppColors.textOnPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
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
              child: AnalyticsStatCard(
                label: avg.label,
                value: avg.value,
                unit: avg.unit,
                color: avg.color,
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
        const AppSkeleton(width: 300, height: 32, borderRadius: AppBorderRadius.pill),
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