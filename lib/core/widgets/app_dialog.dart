// Path: widgets/app_dialog.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Shows a themed [AppDialog] route and resolves with the popped value.
///
/// Reference: Blueprint §2.8 — Dialogs
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required String title,
  String? message,
  Widget? content,
  List<Widget> actions = const [],
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => AppDialog(
      title: title,
      message: message,
      content: content,
      actions: actions,
    ),
  );
}

/// Shows a confirm/cancel dialog and resolves `true` when [confirmLabel] is
/// tapped, `false` on cancel or barrier dismiss.
///
/// Convenience for the common confirm flow (e.g. destructive deletes).
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool destructive = false,
  bool barrierDismissible = true,
}) async {
  final confirmed = await showAppDialog<bool>(
    context,
    title: title,
    message: message,
    barrierDismissible: barrierDismissible,
    actions: [
      AppButton(
        label: cancelLabel,
        variant: AppButtonVariant.ghost,
        size: AppButtonSize.medium,
        onPressed: () => Navigator.of(context).pop(false),
      ),
      AppButton(
        label: confirmLabel,
        variant: destructive
            ? AppButtonVariant.destructive
            : AppButtonVariant.primary,
        size: AppButtonSize.medium,
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ],
  );
  return confirmed ?? false;
}

/// The app's shared dialog chrome.
///
/// surfaceGlass fill, lg radius + hairline border come from the theme's
/// `dialogTheme`; title and message use the Geist type scale. Actions are
/// compact pill buttons so the dialog never feels heavy.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.actions = const [],
  });

  final String title;
  final String? message;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary),
      ),
      content: content ??
          (message == null
              ? null
              : Text(
                  message!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )),
      actions: actions.isEmpty ? null : actions,
    );
  }
}
