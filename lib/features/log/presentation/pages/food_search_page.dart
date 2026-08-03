// Path: pages\food_search_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/domain.dart';
import '../providers/food_providers.dart';
import '../widgets/log_food_sheet.dart';

/// Fast food search (Blueprint §3.3).
///
/// - Results appear as you type (debounced, no search button).
/// - Empty query shows the most popular foods (browse mode).
/// - Tapping a result opens the log-to-meal sheet.
/// - After logging, the page returns to the log screen with a confirmation.
class FoodSearchPage extends ConsumerStatefulWidget {
  const FoodSearchPage({super.key});

  @override
  ConsumerState<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends ConsumerState<FoodSearchPage> {
  static const Duration _debounceDuration = Duration(milliseconds: 250);

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      if (mounted && _query != value.trim()) {
        setState(() => _query = value.trim());
      }
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _controller.clear();
    setState(() => _query = '');
  }

  Future<void> _openLogSheet(Food food) async {
    // Log to the day currently being viewed (today, or a past/future day via
    // the date navigator), not necessarily the actual current day.
    final logDate = ref.read(selectedDateProvider);
    final entry = await showAppBottomSheet<LoggedFoodEntry>(
      context,
      child: LogFoodSheet(food: food, logDate: logDate),
    );
    if (entry == null || !mounted) return;

    showAppToast(context,
        message: 'Added ${entry.foodName} · ${entry.mealType.label}');
    // Return to the log screen — the entry is now in the day log.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: back + search field ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  AppButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.arrow_back,
                    variant: AppButtonVariant.icon,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _controller,
                      hintText: 'Search foods…',
                      prefixIcon: Icons.search,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.close,
                                  size: AppSpacing.iconMd),
                              tooltip: 'Clear',
                            ),
                      onChanged: _onQueryChanged,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _query.isEmpty
                  ? _PopularFoods(onTapFood: _openLogSheet)
                  : _SearchResults(
                      query: _query,
                      onTapFood: _openLogSheet,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Browse mode: popular foods ───────────────────────────────────────────

class _PopularFoods extends ConsumerWidget {
  const _PopularFoods({required this.onTapFood});

  final void Function(Food food) onTapFood;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(foodSearchProvider(''));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AppSectionHeader(label: 'Popular'),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(child: _buildBody(ref, results)),
      ],
    );
  }

  Widget _buildBody(WidgetRef ref, AsyncValue<List<Food>> results) {
    return results.when(
      loading: () => const _ResultListSkeleton(),
      error: (_, __) => _ErrorState(
        onRetry: () => ref.refresh(foodSearchProvider('')),
      ),
      data: (foods) => foods.isEmpty
          ? const Center(child: AppEmptyState(title: 'No foods yet.'))
          : _FoodList(foods: foods, onTapFood: onTapFood),
    );
  }
}

// ── Search mode: debounced query results ─────────────────────────────────

class _SearchResults extends ConsumerWidget {
  const _SearchResults({
    required this.query,
    required this.onTapFood,
  });

  final String query;
  final void Function(Food food) onTapFood;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(foodSearchProvider(query));

    return results.when(
      loading: () => const _ResultListSkeleton(),
      error: (_, __) => _ErrorState(
        onRetry: () => ref.refresh(foodSearchProvider(query)),
      ),
      data: (foods) {
        if (foods.isEmpty) {
          return Center(
            child: AppEmptyState(
              icon: Icons.search_off_outlined,
              title: "No results for '$query'",
              hint: 'Try a different spelling.',
            ),
          );
        }
        return _FoodList(foods: foods, onTapFood: onTapFood);
      },
    );
  }
}

// ── Shared list / states ─────────────────────────────────────────────────

class _FoodList extends StatelessWidget {
  const _FoodList({
    required this.foods,
    required this.onTapFood,
  });

  final List<Food> foods;
  final void Function(Food food) onTapFood;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.quadXl,
      ),
      itemCount: foods.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final food = foods[index];
        return _SearchResultRow(
          food: food,
          onTap: () => onTapFood(food),
        );
      },
    );
  }
}

/// A search result rendered via the shared [AppListRow] (Blueprint §2.6).
/// Calories shown are for the first available serving (falling back to
/// per-100 g when no servings exist).
class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.food,
    this.onTap,
  });

  final Food food;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasServingInfo = food.servings.isNotEmpty;

    return AppListRow(
      title: food.name,
      subtitle: _subtitle(hasServingInfo),
      icon: _categoryIcon(food.category),
      trailing: AppListRowTrailing(
        value: '${_caloriesForDefaultServing(food)}',
        dots: const [
          AppColors.protein,
          AppColors.carbs,
          AppColors.fat,
        ],
      ),
      onTap: onTap,
    );
  }

  String _subtitle(bool hasServingInfo) {
    final parts = <String>[
      if (food.brand != null && food.brand!.isNotEmpty) food.brand!,
      if (food.category != null && food.category!.isNotEmpty) food.category!,
    ];
    if (parts.isEmpty) {
      return hasServingInfo
          ? '${food.servings.first.label} · per serving'
          : 'per 100g';
    }
    return parts.join(' · ');
  }

  /// Calories for the first serving (or per 100 g when no servings defined).
  static int _caloriesForDefaultServing(Food food) {
    if (food.servings.isEmpty) return food.caloriesPer100g;
    final grams = food.servings.first.grams;
    return (grams / 100 * food.caloriesPer100g).round();
  }

  static IconData _categoryIcon(String? category) {
    return switch (category) {
      'Protein' => Icons.egg_alt_outlined,
      'Grains & Carbs' => Icons.rice_bowl_outlined,
      'Fruits' => Icons.eco_outlined,
      'Vegetables' => Icons.grass_outlined,
      'Fats & Nuts' => Icons.spa_outlined,
      'Dairy' => Icons.icecream_outlined,
      'Legumes' => Icons.grain,
      'Snacks' => Icons.cookie_outlined,
      _ => Icons.restaurant_outlined,
    };
  }
}

class _ResultListSkeleton extends StatelessWidget {
  const _ResultListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, __) => AppSkeletonShapes.logRow(),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

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
            "Couldn't search foods",
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
