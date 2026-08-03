// Path: widgets\log_food_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_stepper_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/domain.dart';
import '../providers/food_providers.dart';

/// Bottom sheet for logging a food to a meal: pick a serving, adjust the
/// quantity, confirm the macro preview, choose the meal, then log.
///
/// When [initialEntry] is provided it runs in **edit mode**: the sheet is
/// pre-filled from the existing entry and saving calls
/// [FoodRepository.updateLogEntry] (preserving the entry id and log time)
/// instead of [FoodRepository.logFood]. Either way it invalidates
/// [dailyLogProvider] for the logged date and pops with the resulting
/// [LoggedFoodEntry] as its result.
class LogFoodSheet extends ConsumerStatefulWidget {
  const LogFoodSheet({
    required this.food,
    this.initialMeal,
    this.initialEntry,
    this.logDate,
    super.key,
  });

  final Food food;

  /// Meal to preselect when logging; defaults to a time-of-day suggestion.
  final MealType? initialMeal;

  /// When set, the sheet edits this entry instead of creating a new one.
  final LoggedFoodEntry? initialEntry;

  /// Calendar day the new entry is logged to (defaults to today). Used by
  /// date navigation so entries land on the day being viewed, not always
  /// the current one.
  final DateTime? logDate;

  @override
  ConsumerState<LogFoodSheet> createState() => _LogFoodSheetState();
}

class _LogFoodSheetState extends ConsumerState<LogFoodSheet> {
  static const double _minQuantity = 0.5;
  static const double _maxQuantity = 10.0;

  late MealType _meal;
  int _servingIndex = 0;
  double _quantity = 1.0;
  final TextEditingController _gramsController =
      TextEditingController(text: '100');
  bool _isSaving = false;

  Food get food => widget.food;
  bool get _hasServings => food.servings.isNotEmpty;
  ServingSize get _serving => food.servings[_servingIndex];
  bool get _isEditing => widget.initialEntry != null;

  @override
  void initState() {
    super.initState();
    final editing = widget.initialEntry;
    if (editing != null) {
      _meal = editing.mealType;
      // Prefill the logged quantity as-is so "Save" without edits preserves
      // the entry exactly. The stepper clamps on user interaction only.
      _quantity = editing.servings;
      _preselectServing(editing);
      if (!_hasServings) {
        _gramsController.text = _fmt(editing.grams);
      }
    } else {
      _meal = widget.initialMeal ??
          _defaultMealFor(widget.logDate ?? DateTime.now());
    }
  }

  /// Picks the serving whose size matches the entry's grams-per-serving, so
  /// editing keeps the same physical serving while staying adjustable.
  void _preselectServing(LoggedFoodEntry entry) {
    if (!_hasServings) return;
    final perServing = entry.servings <= 0 ? 0.0 : entry.grams / entry.servings;
    var best = 0;
    var bestDiff = double.infinity;
    for (var i = 0; i < food.servings.length; i++) {
      final diff = (food.servings[i].grams - perServing).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = i;
      }
    }
    _servingIndex = best;
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  /// Time-of-day meal suggestion (Blueprint "Intelligent Defaults").
  static MealType _defaultMealFor(DateTime time) {
    final hour = time.hour;
    if (hour < 10) return MealType.breakfast;
    if (hour < 15) return MealType.lunch;
    if (hour < 21) return MealType.dinner;
    return MealType.snacks;
  }

  double get _totalGrams {
    if (!_hasServings) {
      return double.tryParse(_gramsController.text) ?? 0;
    }
    return _quantity * _serving.grams;
  }

  int get _calories => (_totalGrams / 100 * food.caloriesPer100g).round();
  double get _protein => _round1(_totalGrams / 100 * food.proteinPer100g);
  double get _carbs => _round1(_totalGrams / 100 * food.carbsPer100g);
  double get _fat => _round1(_totalGrams / 100 * food.fatPer100g);

  static double _round1(double value) => (value * 10).roundToDouble() / 10;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Food identity ──────────────────────────────────────────
          Text(
            food.displayName,
            style: AppTextStyles.headlineLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (food.category != null) ...[
            const SizedBox(height: 2),
            Text(
              food.category!,
              style: AppTextStyles.caption,
            ),
          ],

          // ── Per-100g macro strip ───────────────────────────────────
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: Row(
              children: [
                _MacroItem(
                  value: '${food.caloriesPer100g}',
                  unit: 'kcal',
                  color: AppColors.energyNeutral,
                ),
                const SizedBox(width: AppSpacing.lg),
                _MacroItem(
                  value: _fmt(food.proteinPer100g),
                  unit: 'P · g',
                  color: AppColors.protein,
                ),
                const SizedBox(width: AppSpacing.lg),
                _MacroItem(
                  value: _fmt(food.carbsPer100g),
                  unit: 'C · g',
                  color: AppColors.carbs,
                ),
                const SizedBox(width: AppSpacing.lg),
                _MacroItem(
                  value: _fmt(food.fatPer100g),
                  unit: 'F · g',
                  color: AppColors.fat,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Serving selection ──────────────────────────────────────
          Text(
            'SERVING',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_hasServings)
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (var i = 0; i < food.servings.length; i++)
                  _SelectableChip(
                    label: food.servings[i].label,
                    selected: i == _servingIndex,
                    onTap: () => setState(() => _servingIndex = i),
                  ),
              ],
            )
          else
            AppTextField(
              controller: _gramsController,
              hintText: 'Grams',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
            ),

          const SizedBox(height: AppSpacing.md),

          // ── Quantity stepper ───────────────────────────────────────
          if (_hasServings)
            Row(
              children: [
                AppStepperButton(
                  key: const Key('serving-decrease'),
                  icon: Icons.remove,
                  onPressed: _quantity > _minQuantity
                      ? () => setState(
                            () => _quantity = (_quantity - 0.5)
                                .clamp(_minQuantity, _maxQuantity),
                          )
                      : null,
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _fmt(_quantity),
                        style:
                            AppTextStyles.numericDisplay.copyWith(fontSize: 28),
                      ),
                      Text(
                        '${_fmt(_totalGrams)} g total',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                AppStepperButton(
                  key: const Key('serving-increase'),
                  icon: Icons.add,
                  onPressed: _quantity < _maxQuantity
                      ? () => setState(
                            () => _quantity = (_quantity + 0.5)
                                .clamp(_minQuantity, _maxQuantity),
                          )
                      : null,
                ),
              ],
            )
          else
            Text(
              '${_fmt(_totalGrams)} g',
              style: AppTextStyles.caption,
            ),
          const SizedBox(height: AppSpacing.lg),

          // ── Macro preview ──────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_calories',
                style: AppTextStyles.displayMedium.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'kcal',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              const Spacer(),
              _MacroPreview(
                  label: 'P', grams: _protein, color: AppColors.protein),
              const SizedBox(width: AppSpacing.lg),
              _MacroPreview(label: 'C', grams: _carbs, color: AppColors.carbs),
              const SizedBox(width: AppSpacing.lg),
              _MacroPreview(label: 'F', grams: _fat, color: AppColors.fat),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Meal selection ─────────────────────────────────────────
          Text(
            'MEAL',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final meal in MealType.values)
                _SelectableChip(
                  label: meal.label,
                  selected: _meal == meal,
                  onTap: () => setState(() => _meal = meal),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Log action ─────────────────────────────────────────────
          AppButton(
            key: const Key('log-food-submit'),
            label: _isSaving
                ? 'Saving…'
                : _isEditing
                    ? 'Save changes'
                    : 'Log to ${_meal.label}',
            icon: _isSaving ? null : (_isEditing ? Icons.check : Icons.add),
            variant: AppButtonVariant.primary,
            size: AppButtonSize.large,
            isFullWidth: true,
            isLoading: _isSaving,
            onPressed: _isSaving ? null : _log,
          ),
        ],
      ),
    );
  }

  Future<void> _log() async {
    final grams = _totalGrams;
    if (grams <= 0) return;

    final editing = widget.initialEntry;
    final now = DateTime.now();
    final entry = LoggedFoodEntry(
      // Editing keeps the original id and log time; logging creates a new one.
      id: editing?.id ?? 'entry_${now.microsecondsSinceEpoch}',
      foodId: editing?.foodId ?? food.id,
      foodName: editing?.foodName ?? food.displayName,
      mealType: _meal,
      servingLabel: _hasServings
          ? '${_fmt(_quantity)} × ${_serving.label}'
          : '${_fmt(grams)} g',
      servings: _hasServings ? _quantity : 1,
      grams: grams,
      calories: _calories,
      protein: _protein,
      carbs: _carbs,
      fat: _fat,
      loggedAt: editing?.loggedAt ?? (widget.logDate ?? now),
    );

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(foodRepositoryProvider);
      if (_isEditing) {
        await repo.updateLogEntry(entry);
      } else {
        await repo.logFood(entry);
      }
      // Refresh the log for the day this entry belongs to. The family key is
      // day-normalized (see [dayOf]), so invalidate with the same normalized
      // date to hit the instance the Log page watches.
      ref.invalidate(dailyLogProvider(dayOf(entry.loggedAt)));
      if (mounted) {
        Navigator.of(context).pop(entry);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't log food — try again.")),
        );
      }
    }
  }

  static String _fmt(double value) {
    final rounded = (value * 10).roundToDouble() / 10;
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(1);
  }
}

// ── Small building blocks ─────────────────────────────────────────────────

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.headlineSmall.copyWith(
            color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  const _MacroItem({
    required this.value,
    required this.unit,
    required this.color,
  });

  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$value $unit',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _MacroPreview extends StatelessWidget {
  const _MacroPreview({
    required this.label,
    required this.grams,
    required this.color,
  });

  final String label;
  final double grams;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_fmt(grams)}g',
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.onPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: color),
        ),
      ],
    );
  }

  static String _fmt(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}
