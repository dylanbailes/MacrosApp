// Path: widgets/app_list_row.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';
import 'app_card.dart';

/// The unified list row used by food logs, search results, and recent meals.
///
/// Reference: Blueprint §2.6 — Log Row
///
/// Anatomy: 40×40 rounded-square leading glyph · title + subtitle stacked ·
/// trailing tabular value + optional macro dots · optional delete affordance.
///
/// Replaces the private row widgets in `log_food_row.dart`,
/// `food_search_result_row.dart`, and `recent_meals_list.dart` so every row
/// in the app shares one structure, one spacing, and one interaction.
class AppListRow extends StatelessWidget {
  const AppListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.icon = Icons.restaurant_outlined,
    this.trailing,
    this.onTap,
    this.onDelete,
  });

  /// Primary line (food name / entry title).
  final String title;

  /// Secondary meta line (serving info, brand, time, category…).
  final String? subtitle;

  /// Custom leading widget; when null a 40×40 glyph with [icon] is rendered.
  final Widget? leading;

  /// Glyph used for the default leading square.
  final IconData icon;

  /// Optional trailing widget (tabular value, macro dots, etc.).
  final Widget? trailing;

  final VoidCallback? onTap;

  /// Optional delete action; renders a small trailing delete button.
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.row,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      child: Row(
        children: [
          // Leading glyph (40×40 rounded square)
          leading ??
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Icon(
                  icon,
                  size: AppSpacing.iconMd,
                  color: AppColors.iconDefault,
                ),
              ),
          const SizedBox(width: AppSpacing.md),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Trailing value
          if (trailing != null) trailing!,
          // Delete affordance
          if (onDelete != null) ...[
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              key: const Key('delete-log-entry'),
              onPressed: onDelete,
              icon: Icons.delete_outline,
              variant: AppButtonVariant.icon,
              size: AppButtonSize.small,
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact right-aligned value + macro dots for [AppListRow.trailing].
class AppListRowTrailing extends StatelessWidget {
  const AppListRowTrailing({
    super.key,
    required this.value,
    this.unit,
    this.dots = const [],
    this.valueColor = AppColors.onPrimary,
  });

  /// The numeral (already formatted, e.g. "330").
  final String value;

  /// Optional unit shown as a small suffix (e.g. "kcal").
  final String? unit;

  /// Macro dot colors (protein/carbs/fat); empty hides the dot row.
  final List<Color> dots;

  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: AppTextStyles.titleSmall.copyWith(
                color: valueColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 2),
              Text(
                unit!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
        if (dots.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final color in dots) _MacroDot(color: color),
            ],
          ),
        ],
      ],
    );
  }
}

class _MacroDot extends StatelessWidget {
  const _MacroDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(left: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
