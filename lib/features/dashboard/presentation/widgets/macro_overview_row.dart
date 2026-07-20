// Path: features/dashboard/presentation/widgets/macro_overview_row.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_metric_tile.dart';
import '../providers/dashboard_state.dart';

/// The 3-tile macro row: Protein / Carbs / Fat.
///
/// Reference: Blueprint §2.3 — Macro Tile ×3. Composes the shared
/// AppMetricTile (one library entry, color is the only difference across the
/// three), 12px gap between tiles. Shows remaining grams as the target suffix.
class MacroOverviewRow extends StatelessWidget {
  const MacroOverviewRow({
    super.key,
    required this.macros,
  });

  final List<MacroProgress> macros;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < macros.length; i++) ...[
          Expanded(
            child: AppMetricTile(
              label: macros[i].label.toUpperCase(),
              value: macros[i].consumed.round().toString(),
              target: '${macros[i].remaining.round()}${macros[i].unit} left',
              color: Color(macros[i].color),
              progress: macros[i].progress,
              isOverTarget: macros[i].isOverTarget,
            ),
          ),
          if (i < macros.length - 1) const SizedBox(width: AppSpacing.md),
        ],
      ],
    );
  }
}

/// A labeled section header row used on the dashboard.
///
/// Combines an uppercase eyebrow label with an optional trailing action
/// (e.g., a "View all" link). Keeps the Nothing OS scannable hierarchy.
class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.label,
    this.actionLabel,
    this.onAction,
  });

  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelLarge,
        ),
        if (actionLabel != null)
          Semantics(
            label: actionLabel,
            child: GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                  horizontal: AppSpacing.sm,
                ),
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}