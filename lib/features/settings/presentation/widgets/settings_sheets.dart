// Path: widgets/settings_sheets.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/formatting/app_formatters.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../../../core/widgets/app_stepper_button.dart';
import '../providers/settings_providers.dart';

/// Bottom sheet content for picking the measurement system.
///
/// Rendered inside the shared [AppBottomSheet] chrome via
/// `showAppBottomSheet<UnitSystem>`. Tapping an option pops with the chosen
/// [UnitSystem] (the sheet never commits state itself).
class UnitPickerSheet extends StatelessWidget {
  const UnitPickerSheet({required this.current, super.key});

  final UnitSystem current;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Units', style: AppTextStyles.headlineLarge),
        const SizedBox(height: 2),
        Text(
          'How measurements are displayed',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final system in UnitSystem.values) ...[
          AppListRow(
            icon: system == UnitSystem.metric
                ? Icons.straighten_outlined
                : Icons.rule_outlined,
            title: system.label,
            subtitle: system.subtitle,
            trailing: system == current
                ? const Icon(
                    Icons.check,
                    size: AppSpacing.iconMd,
                    color: AppColors.primary,
                  )
                : null,
            onTap: () => Navigator.of(context).pop(system),
          ),
          if (system != UnitSystem.values.last)
            const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Bottom sheet content for editing the daily calorie/macro targets.
///
/// Steppers adjust a local draft; "Save goals" commits it to
/// [settingsProvider] and closes. Feeds the Profile Goals Summary card and
/// the dashboard's hero/macro targets once they read the same provider.
class GoalsEditorSheet extends ConsumerStatefulWidget {
  const GoalsEditorSheet({super.key});

  @override
  ConsumerState<GoalsEditorSheet> createState() => _GoalsEditorSheetState();
}

class _GoalsEditorSheetState extends ConsumerState<GoalsEditorSheet> {
  static const int _caloriesStep = 50;
  static const int _macroStep = 5;
  static const int _caloriesMin = 1000;
  static const int _caloriesMax = 5000;
  static const int _macroMin = 30;
  static const int _macroMax = 600;

  late int _calories;
  late int _protein;
  late int _carbs;
  late int _fat;

  @override
  void initState() {
    super.initState();
    final goals = ref.read(settingsProvider);
    _calories = goals.calorieTarget;
    _protein = goals.proteinTarget;
    _carbs = goals.carbsTarget;
    _fat = goals.fatTarget;
  }

  void _save() {
    ref.read(settingsProvider.notifier).setGoals(
          calorieTarget: _calories,
          proteinTarget: _protein,
          carbsTarget: _carbs,
          fatTarget: _fat,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Daily Goals', style: AppTextStyles.headlineLarge),
        const SizedBox(height: 2),
        Text('Calorie and macro targets', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.lg),
        _GoalRow(
          label: 'Calories',
          value: AppFormatters.comma(_calories),
          unit: 'kcal',
          color: AppColors.energyNeutral,
          decreaseKey: const Key('goal-calories-decrease'),
          increaseKey: const Key('goal-calories-increase'),
          onDecrease: () => setState(
            () => _calories =
                (_calories - _caloriesStep).clamp(_caloriesMin, _caloriesMax),
          ),
          onIncrease: () => setState(
            () => _calories =
                (_calories + _caloriesStep).clamp(_caloriesMin, _caloriesMax),
          ),
        ),
        _GoalRow(
          label: 'Protein',
          value: '$_protein',
          unit: 'g',
          color: AppColors.protein,
          onDecrease: () => setState(
            () =>
                _protein = (_protein - _macroStep).clamp(_macroMin, _macroMax),
          ),
          onIncrease: () => setState(
            () =>
                _protein = (_protein + _macroStep).clamp(_macroMin, _macroMax),
          ),
        ),
        _GoalRow(
          label: 'Carbs',
          value: '$_carbs',
          unit: 'g',
          color: AppColors.carbs,
          onDecrease: () => setState(
            () => _carbs = (_carbs - _macroStep).clamp(_macroMin, _macroMax),
          ),
          onIncrease: () => setState(
            () => _carbs = (_carbs + _macroStep).clamp(_macroMin, _macroMax),
          ),
        ),
        _GoalRow(
          label: 'Fat',
          value: '$_fat',
          unit: 'g',
          color: AppColors.fat,
          onDecrease: () => setState(
            () => _fat = (_fat - _macroStep).clamp(_macroMin, _macroMax),
          ),
          onIncrease: () => setState(
            () => _fat = (_fat + _macroStep).clamp(_macroMin, _macroMax),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppButton(
          label: 'Save goals',
          icon: Icons.check,
          variant: AppButtonVariant.primary,
          isFullWidth: true,
          onPressed: _save,
        ),
      ],
    );
  }
}

/// One goal stepper row: label + colored value on the left, − / + on the right.
class _GoalRow extends StatelessWidget {
  const _GoalRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.onDecrease,
    required this.onIncrease,
    this.decreaseKey,
    this.increaseKey,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final Key? decreaseKey;
  final Key? increaseKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: AppTextStyles.macroLabel),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: color,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(unit, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          AppStepperButton(
            key: decreaseKey,
            icon: Icons.remove,
            onPressed: onDecrease,
          ),
          const SizedBox(width: AppSpacing.lg),
          AppStepperButton(
            key: increaseKey,
            icon: Icons.add,
            onPressed: onIncrease,
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet content with the app identity and version.
class AboutSheet extends StatelessWidget {
  const AboutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: AppSpacing.avatarLg,
              height: AppSpacing.avatarLg,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.restaurant_outlined,
                size: AppSpacing.iconXl,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Macro Tracker', style: AppTextStyles.headlineLarge),
                const SizedBox(height: 2),
                Text('Version 1.0.0', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'A fast, premium macro and nutrition tracker designed for gym '
          'enthusiasts and athletes.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Designed in the Nothing philosophy — true black surfaces, one '
          'accent, dot-matrix numerals, and motion that means something.',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}

/// Bottom sheet content listing the open-source projects the app is built on.
class OpenSourceSheet extends StatelessWidget {
  const OpenSourceSheet({super.key});

  static const List<String> _packages = [
    'Flutter',
    'Riverpod',
    'GoRouter',
    'Drift',
    'fl_chart',
    'Google Fonts (Geist & Nothing)',
    'Dio',
    'intl',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Open Source', style: AppTextStyles.headlineLarge),
        const SizedBox(height: 2),
        Text(
          'Powered by these open-source projects',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppSpacing.md),
        for (final package in _packages)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: AppSpacing.iconMd,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(package, style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
      ],
    );
  }
}
