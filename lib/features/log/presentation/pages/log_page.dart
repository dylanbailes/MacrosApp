// Path: pages\log_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_date_navigator.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/domain.dart';
import '../../../../features/settings/presentation/providers/settings_providers.dart';
import '../providers/food_providers.dart';
import '../widgets/log_day_summary.dart';
import '../widgets/log_food_sheet.dart';
import '../widgets/log_meal_section.dart';
import '../widgets/log_quick_input_bar.dart';

/// The Food Log screen — a chronological, editable record of everything
/// logged for the day being viewed, grouped by meal sections.
///
/// Blueprint §3.2: Food Log
/// Features:
/// - Sticky header with "Log" title and a date navigator (◀ today ▶)
/// - Daily calorie summary bar (real totals from [dailyLogProvider])
/// - Quick input row: Scan barcode / Take photo / Search
/// - Meal sections (Breakfast, Lunch, Dinner, Snacks) fed by the day log,
///   with tap-to-edit and delete (with undo) per entry.
class LogPage extends ConsumerWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The shared, day-normalized date the user is viewing. Navigating it on
    // this page (header arrows) also moves the dashboard, and vice-versa.
    final date = ref.watch(selectedDateProvider);
    final dayLog = ref.watch(dailyLogProvider(date));
    // Goals come from the shared settings (editable on Profile/Settings), so
    // the log's daily summary target stays in sync with the dashboard.
    final goals = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        child: dayLog.when(
          loading: () => const _LogPageSkeleton(),
          error: (_, __) => _LogPageError(
            onRetry: () => ref.invalidate(dailyLogProvider(date)),
          ),
          data: (log) => _LogContent(
            log: log,
            goals: goals,
            date: date,
            onSearch: () => context.push(AppRoutes.foodSearch),
            onPreviousDay: () =>
                ref.read(selectedDateProvider.notifier).shift(-1),
            onNextDay: () => ref.read(selectedDateProvider.notifier).shift(1),
            onToday: () =>
                ref.read(selectedDateProvider.notifier).jumpToToday(),
            onTapEntry: (entry) => _editEntry(context, ref, entry),
            onDeleteEntry: (entry) => _deleteEntry(context, ref, entry),
          ),
        ),
      ),
    );
  }

  /// Opens the log sheet in edit mode, pre-filled from the existing entry.
  /// The food is resolved by id so serving chips/grams are available; if the
  /// food no longer exists, a synthetic food is reconstructed from the entry
  /// snapshot so the entry is still editable.
  Future<void> _editEntry(
    BuildContext context,
    WidgetRef ref,
    LoggedFoodEntry entry,
  ) async {
    final repository = ref.read(foodRepositoryProvider);
    Food? food;
    if (entry.foodId != null) {
      food = await repository.getFoodById(entry.foodId!);
    }
    if (!context.mounted) return;
    food ??= _foodFromEntry(entry);

    final updated = await showAppBottomSheet<LoggedFoodEntry>(
      context,
      child: LogFoodSheet(food: food, initialEntry: entry),
    );
    if (updated == null || !context.mounted) return;

    showAppToast(context, message: 'Updated ${updated.foodName}');
  }

  Future<void> _deleteEntry(
    BuildContext context,
    WidgetRef ref,
    LoggedFoodEntry entry,
  ) async {
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Delete ${entry.foodName}?',
      message: 'This removes it from your ${entry.mealType.label} log.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return;

    final repository = ref.read(foodRepositoryProvider);
    await repository.removeLogEntry(entry.id);
    ref.invalidate(dailyLogProvider(dayOf(entry.loggedAt)));
    if (!context.mounted) return;

    showAppToast(
      context,
      message: 'Deleted ${entry.foodName}',
      variant: AppToastVariant.undoable,
      onUndo: () async {
        // The toast may outlive the widget; bail if it was disposed.
        if (!context.mounted) return;
        // Re-insert with a fresh id so the undo always succeeds.
        await repository.logFood(entry.copyWith(
          id: 'entry_${DateTime.now().microsecondsSinceEpoch}',
        ));
        ref.invalidate(dailyLogProvider(dayOf(entry.loggedAt)));
      },
    );
  }

  /// Reconstructs a [Food] from an entry's snapshot when the original food
  /// record no longer exists. Per-100 g values are derived from the entry's
  /// totals so the edit sheet shows correct numbers.
  static Food _foodFromEntry(LoggedFoodEntry entry) {
    final grams = entry.grams <= 0 ? 100.0 : entry.grams;
    return Food(
      id: entry.foodId ?? entry.id,
      name: entry.foodName,
      source: FoodSource.custom,
      caloriesPer100g: (entry.calories / grams * 100).round(),
      proteinPer100g: entry.protein / grams * 100,
      carbsPer100g: entry.carbs / grams * 100,
      fatPer100g: entry.fat / grams * 100,
    );
  }
}

// ── Log content (data-backed) ────────────────────────────────────────────

class _LogContent extends StatelessWidget {
  const _LogContent({
    required this.log,
    required this.goals,
    required this.date,
    required this.onSearch,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onToday,
    required this.onTapEntry,
    required this.onDeleteEntry,
  });

  final DayLog log;
  final SettingsState goals;
  final DateTime date;
  final VoidCallback onSearch;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onToday;
  final void Function(LoggedFoodEntry entry) onTapEntry;
  final void Function(LoggedFoodEntry entry) onDeleteEntry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Sticky Header ──────────────────────────────────────────────
        SliverPersistentHeader(
          pinned: true,
          delegate: _LogHeaderDelegate(
            date: date,
            onPrevious: onPreviousDay,
            onNext: onNextDay,
            onToday: onToday,
          ),
        ),

        // ── Daily Summary ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: LogDaySummary(
            consumedCalories: log.totalCalories,
            targetCalories: goals.calorieTarget,
            proteinGrams: log.totalProtein,
            carbsGrams: log.totalCarbs,
            fatGrams: log.totalFat,
            proteinTarget: goals.proteinTarget.toDouble(),
            carbsTarget: goals.carbsTarget.toDouble(),
            fatTarget: goals.fatTarget.toDouble(),
          ),
        ),

        // ── Quick Input Row ────────────────────────────────────────────
        SliverToBoxAdapter(
          child: LogQuickInputBar(
            onScanBarcode: () => _showComingSoon(context, 'Barcode Scan'),
            onTakePhoto: () => _showComingSoon(context, 'AI Photo Analysis'),
            onSearch: onSearch,
          ),
        ),

        // ── Empty day banner ───────────────────────────────────────────
        if (log.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: AppCard(
                child: AppEmptyState(
                  icon: CupertinoIcons.sparkles,
                  title: 'Nothing logged yet',
                  hint: 'Search for a food to add your first entry.',
                  actionLabel: 'Search foods',
                  onAction: onSearch,
                  compact: true,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

        // ── Meal Sections ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              for (final meal in MealType.values) ...[
                LogMealSection(
                  label: meal.label,
                  entries: log.forMeal(meal),
                  defaultIcon: _mealIcon(meal),
                  onTapEntry: onTapEntry,
                  onDeleteEntry: onDeleteEntry,
                ),
                if (meal != MealType.values.last)
                  const SizedBox(height: AppSpacing.xl),
              ],
              const SizedBox(height: AppSpacing.quadXl),
            ],
          ),
        ),
      ],
    );
  }

  static IconData _mealIcon(MealType meal) {
    return switch (meal) {
      MealType.breakfast => Icons.breakfast_dining_outlined,
      MealType.lunch => Icons.lunch_dining_outlined,
      MealType.dinner => Icons.dinner_dining_outlined,
      MealType.snacks => Icons.icecream_outlined,
    };
  }

  void _showComingSoon(BuildContext context, String feature) {
    showAppToast(context, message: '$feature — coming soon');
  }
}

// ── Sticky Header Delegate ─────────────────────────────────────────────

class _LogHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _LogHeaderDelegate({
    required this.date,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final opacity = (1.0 - (shrinkOffset / maxExtent).clamp(0.0, 1.0));

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: maxExtent, maxHeight: maxExtent),
      child: Opacity(
        opacity: opacity,
        child: AppScreenHeader(
          // Matches the log screen's lg margins (AppScreenHeader defaults to
          // the xl screen margin, which the dashboard page supplies via its
          // own sliver padding).
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          title: 'Food Log',
          trailing: AppDateNavigator(
            date: date,
            onPrevious: onPrevious,
            onNext: onNext,
            onToday: onToday,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant _LogHeaderDelegate oldDelegate) {
    return date != oldDelegate.date ||
        onPrevious != oldDelegate.onPrevious ||
        onNext != oldDelegate.onNext ||
        onToday != oldDelegate.onToday;
  }
}

// ── Loading / error states ────────────────────────────────────────────

class _LogPageSkeleton extends StatelessWidget {
  const _LogPageSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        AppSkeletonShapes.logRow(),
        const SizedBox(height: AppSpacing.sm),
        AppSkeletonShapes.logRow(),
        const SizedBox(height: AppSpacing.sm),
        AppSkeletonShapes.logRow(),
        const SizedBox(height: AppSpacing.xl),
        AppSkeletonShapes.logRow(),
        const SizedBox(height: AppSpacing.sm),
        AppSkeletonShapes.logRow(),
      ],
    );
  }
}

class _LogPageError extends StatelessWidget {
  const _LogPageError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 40,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Couldn't load your log",
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Try again',
            variant: AppButtonVariant.secondary,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
