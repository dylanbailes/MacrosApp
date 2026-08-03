// Path: core/widgets/app_date_navigator.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Compact previous/next day stepper shared by the Log page header and the
/// Dashboard header.
///
/// The center label reads "Today", "Yesterday", "Tomorrow", or the calendar
/// date for older days. When viewing a day other than today a small "Today"
/// chip appears next to the arrows (tap it to jump back) — this doubles as a
/// back-out affordance so the user can always return to the live day.
class AppDateNavigator extends StatelessWidget {
  const AppDateNavigator({
    required this.date,
    required this.onPrevious,
    required this.onNext,
    this.onToday,
    this.showTodayChip = true,
    super.key,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  /// Jumps back to today; when null (or when already on today) no chip is
  /// rendered.
  final VoidCallback? onToday;
  final bool showTodayChip;

  bool get _isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String get _label {
    final now = DateTime.now();
    final diff = dayOnly(date).difference(dayOnly(now)).inDays;
    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    if (diff == 1) return 'Tomorrow';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final label = '${months[date.month - 1]} ${date.day}';
    return date.year == now.year ? label : '$label, ${date.year}';
  }

  static DateTime dayOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavButton(
          key: const Key('date-previous'),
          icon: Icons.chevron_left,
          tooltip: 'Previous day',
          onTap: onPrevious,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          _label,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.onPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _NavButton(
          key: const Key('date-next'),
          icon: Icons.chevron_right,
          tooltip: 'Next day',
          onTap: onNext,
        ),
        if (showTodayChip && onToday != null && !_isToday) ...[
          const SizedBox(width: AppSpacing.sm),
          Semantics(
            label: 'Jump to today',
            button: true,
            child: GestureDetector(
              key: const Key('date-today'),
              onTap: onToday,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 2,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                ),
                child: Text(
                  'Today',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        // 48px hit target (Blueprint Rule 16) around a compact 36px circle.
        child: Container(
          width: AppSpacing.buttonHeight,
          height: AppSpacing.buttonHeight,
          alignment: Alignment.center,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(
              icon,
              size: AppSpacing.iconLg,
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
