// Path: widgets\app_toast.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Shows an [AppToast] in the root overlay with an entrance animation and
/// auto-dismiss. Safe to call from any page (the entry is inserted into the
/// root overlay so it survives route pops).
void showAppToast(
  BuildContext context, {
  required String message,
  AppToastVariant variant = AppToastVariant.confirmation,
  VoidCallback? onUndo,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => AppToastHost(
      toast: AppToast(
        message: message,
        variant: variant,
        onUndo: onUndo,
      ),
      onDismissed: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

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
    required this.message, super.key,
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
                fontFamily: kGeistFont,
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
                  fontFamily: kGeistFont,
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

/// Hosts a single [AppToast] with an entrance animation and auto-dismiss.
class AppToastHost extends StatefulWidget {
  const AppToastHost({
    required this.toast,
    required this.onDismissed,
    super.key,
  });

  final AppToast toast;
  final VoidCallback onDismissed;

  @override
  State<AppToastHost> createState() => _AppToastHostState();
}

class _AppToastHostState extends State<AppToastHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismissed());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppSpacing.xxl,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: SlideTransition(
        position: _slide,
        child: widget.toast,
      ),
    );
  }
}