// Path: features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../providers/dashboard_provider.dart';
import '../providers/dashboard_state.dart';
import '../widgets/ai_coach_entry_card.dart';
import '../widgets/analytics_hero_section.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/macro_overview_row.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/recent_meals_list.dart';
import '../widgets/dashboard_stats_section.dart';

/// The daily landing screen.
///
/// Reference: Blueprint §3.1 — Dashboard (Home). Prioritizes fast logging,
/// remaining calories/macros, today's progress, recent meals, and useful
/// statistics. The bottom nav + FAB are provided by the app shell (HomePage),
/// so this screen renders only its content. Mock data is supplied by
/// [dashboardProvider] until a backend exists.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

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
                      if (summaryAsync.isLoading)
                        const _DashboardSkeleton()
                      else if (summaryAsync.hasError)
                        _ErrorState(onRetry: notifier.refresh)
                      else if (summaryAsync.hasValue)
                        _DashboardContent(summary: summaryAsync.value!),
                      // Bottom padding so content clears the floating nav bar
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

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardHeader(
          greeting: summary.greeting,
          dateLabel: summary.dateLabel,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        AiCoachEntryCard(insight: summary.coachInsight),
        const SizedBox(height: AppSpacing.xxxl),
        AnalyticsHeroSection(
          summary: summary,
          onTap: () => context.push('/profile/coach'),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        const DashboardSectionHeader(label: 'Macros'),
        const SizedBox(height: AppSpacing.md),
        MacroOverviewRow(macros: summary.macros),
        const SizedBox(height: AppSpacing.xxxl),
        DashboardSectionHeader(
          label: 'Recent Meals',
          actionLabel: 'View all',
          onAction: () => context.go('/log'),
        ),
        const SizedBox(height: AppSpacing.md),
        RecentMealsList(
          meals: summary.recentMeals,
          onTapMeal: (_) => context.push('/log'),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        DashboardSectionHeader(label: 'Quick Actions'),
        const SizedBox(height: AppSpacing.md),
        QuickActionsRow(
          actions: [
            QuickAction(
              label: 'Log Water',
              icon: Icons.water_drop_outlined,
              onTap: () => context.push('/log'),
            ),
            QuickAction(
              label: 'Log Weight',
              icon: Icons.monitor_weight_outlined,
              onTap: () => context.push('/analytics'),
            ),
            QuickAction(
              label: 'Scan Barcode',
              icon: Icons.qr_code_scanner_outlined,
              onTap: () => context.push('/log'),
            ),
            QuickAction(
              label: 'Quick Add',
              icon: Icons.add_outlined,
              onTap: () => context.push('/log'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxxl),
        DashboardStatsSection(summary: summary),
      ],
    );
  }
}

/// Skeleton loading state matching the dashboard's content shape.
///
/// Reference: Blueprint §4.2 — Dashboard shows a skeleton hero, 3 skeleton
/// macro tiles, and 3 skeleton log rows on first paint.
class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header placeholder
        const AppSkeleton(width: 180, height: 28, borderRadius: AppBorderRadius.sm),
        const SizedBox(height: AppSpacing.xxxl),
        
        // Section label placeholder
        const AppSkeleton(width: 120, height: 16, borderRadius: AppBorderRadius.sm),
        const SizedBox(height: AppSpacing.md),
        
        // Medium cards row: Streak, Goals, Avg Calories
        Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              Expanded(child: AppSkeletonShapes.metricTile()),
              if (i < 2) const SizedBox(width: AppSpacing.lg),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        
        // Hero chart: 7-Day Calories
        AppSkeleton(
          width: double.infinity,
          height: 200,
          borderRadius: AppBorderRadius.md,
        ),
        const SizedBox(height: AppSpacing.xl),
        
        // Hero chart: Macros This Week
        AppSkeleton(
          width: double.infinity,
          height: 160,
          borderRadius: AppBorderRadius.md,
        ),
        const SizedBox(height: AppSpacing.xl),
        
        // Compact cards row: Water, Protein, Weight
        Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              Expanded(child: AppSkeletonShapes.metricTile()),
              if (i < 2) const SizedBox(width: AppSpacing.lg),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xxxl),
        
        // Recent meals
        for (var i = 0; i < 3; i++) ...[
          AppSkeletonShapes.logRow(width: double.infinity),
          const SizedBox(height: AppSpacing.sm),
        ],
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
              "Couldn't load your dashboard",
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