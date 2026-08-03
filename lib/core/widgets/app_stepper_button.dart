// Path: widgets/app_stepper_button.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// A circular − / + stepper button for quantity and goal editing.
///
/// Replaces the private stepper button in the log sheet so every stepper in
/// the app (serving quantities, goal targets) shares one visual: a 48px
/// circle, `surfaceElevated` when enabled and muted `surface` when disabled.
class AppStepperButton extends StatelessWidget {
  const AppStepperButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.size = AppSpacing.quadXl,
  });

  final IconData icon;

  /// Null renders the disabled (muted) state.
  final VoidCallback? onPressed;

  /// Circle diameter; defaults to the 48px touch-target floor.
  final double size;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled ? AppColors.surfaceElevated : AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(
          icon,
          size: AppSpacing.iconMd,
          color: enabled ? AppColors.onPrimary : AppColors.textDisabled,
        ),
      ),
    );
  }
}
