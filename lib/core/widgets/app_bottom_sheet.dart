// Path: widgets/app_bottom_sheet.dart
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

/// Shows [child] in the shared [AppBottomSheet] chrome and resolves with the
/// popped value.
///
/// Reference: Blueprint §2.8 — Bottom Sheets
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    // The chrome paints the surfaceGlass fill + top radius itself, so the
    // route stays transparent to avoid a double surface behind it.
    backgroundColor: Colors.transparent,
    builder: (_) => AppBottomSheet(child: child),
  );
}

/// The shared bottom-sheet chrome: surfaceGlass fill, lg top radius, drag
/// handle, keyboard-inset lift, safe area, and scrollable padded content.
///
/// Replaces hand-rolled sheet scaffolding in feature widgets — a sheet now
/// only supplies its [child] content column.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.child,
    super.key,
    this.padding,
    this.showDragHandle = true,
  });

  final Widget child;

  /// Padding around the content below the drag handle. Defaults to the
  /// standard sheet padding (lg / sm / lg / xl).
  final EdgeInsetsGeometry? padding;

  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: AppDurations.fast,
      curve: Curves.easeOut,
      // Lift the sheet above the on-screen keyboard.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceGlass,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppBorderRadius.lg),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: padding ??
                const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag handle ────────────────────────────────────────────
                if (showDragHandle) ...[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.dividerStrong,
                        borderRadius: BorderRadius.circular(
                          AppBorderRadius.pill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
