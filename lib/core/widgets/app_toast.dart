// Path: widgets\app_toast.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// A toast notification for confirming transient, low-stakes actions.
///
/// Reference: Blueprint §2.9 — Toast / Snackbar
/// 
/// Variants:
/// - Confirmation: checkmark icon, status.positive accent
/// - Undo-able: adds "Undo" text action on the right
/// - Error: small status.negative icon
class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.message,
    this.variant = AppToastVariant.confirmation,
    this.onUndo,
    this.duration = const Duration(seconds: 4),
  });

  final String message;
  final AppToastVariant variant;
  final VoidCallback? onUndo;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            _icon,
            size: 18,
            color: _iconColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          // Message
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.onPrimary,
              ),
            ),
          ),
          // Undo action
          if (onUndo != null) ...[
            const SizedBox(width: AppSpacing.lg),
            GestureDetector(
              onTap: onUndo,
              child: const Text(
                'Undo',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData get _icon {
    return switch (variant) {
      AppToastVariant.confirmation => Icons.check_circle_outline,
      AppToastVariant.undoable => Icons.check_circle_outline,
      AppToastVariant.error => Icons.error_outline,
    };
  }

  Color get _iconColor {
    return switch (variant) {
      AppToastVariant.confirmation => AppColors.success,
      AppToastVariant.undoable => AppColors.success,
      AppToastVariant.error => AppColors.error,
    };
  }
}

enum AppToastVariant { confirmation, undoable, error }