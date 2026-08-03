// Path: widgets/app_segmented_control.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A single selectable option in [AppSegmentedControl].
class AppSegmentedOption<T> {
  const AppSegmentedOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// A pill segmented control with a sliding active segment.
///
/// Reference: Blueprint §2.8 — Chip / Segmented Control / Range Tabs.
///
/// The active segment renders as a brighter, accent-bordered pill that
/// *slides* between positions (not cross-fading), so the control reads as one
/// continuous track. Used for both range tabs (1W/1M/3M/6M/1Y/ALL) and the
/// Nutrition/Weight segment switch — one control, no forked variants.
///
/// Options are laid out in uniform-width slots derived from the widest label,
/// which is what lets the pill animate to an exact position. The whole track
/// is horizontally scrollable so long option sets (six range tabs) never
/// overflow on narrow screens; when it fits, it hugs content and left-aligns.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<AppSegmentedOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = options.indexWhere((o) => o.value == value);

    // Uniform slot width from the widest label (label + breathing padding).
    var widest = 0.0;
    for (final option in options) {
      final painter = TextPainter(
        text: TextSpan(text: option.label, style: AppTextStyles.labelLarge),
        textDirection: TextDirection.ltr,
      )..layout();
      if (painter.width > widest) widest = painter.width;
    }
    final slotWidth = widest + AppSpacing.xxxl;

    const gap = AppSpacing.xs;
    final pillLeft =
        (selectedIndex < 0 ? 0 : selectedIndex) * (slotWidth + gap);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          border: Border.all(color: AppColors.divider),
        ),
        child: Stack(
          children: [
            // Sliding active pill (behind the labels).
            AnimatedPositioned(
              duration: AppDurations.fast,
              curve: Curves.easeOutCubic,
              left: pillLeft.toDouble(),
              top: 0,
              bottom: 0,
              width: slotWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
            // Tappable option labels on top.
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0) const SizedBox(width: gap),
                  _SegmentButton(
                    label: options[i].label,
                    isSelected: i == selectedIndex,
                    width: slotWidth,
                    onTap: () => onChanged(options[i].value),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      inMutuallyExclusiveGroup: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: width,
          height: AppSpacing.buttonHeight - AppSpacing.sm,
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color:
                    isSelected ? AppColors.onPrimary : AppColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
