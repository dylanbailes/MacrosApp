// Path: widgets/app_section_header.dart
import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A section header label used throughout the app.
///
/// Renders as an uppercase label with letter-spacing, matching the spec's
/// "Label" style (Geist Medium 13/16, +4% tracking, ALL CAPS).
///
/// [trailing] lets screens place a right-aligned action (e.g. "View all")
/// without hand-rolling a Row + Spacer at every call site.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.label,
    super.key,
    this.padding = EdgeInsets.zero,
    this.trailing,
    this.labelStyle,
  });

  final String label;
  final EdgeInsetsGeometry padding;

  /// Optional right-aligned action widget (link, button, subtotal).
  final Widget? trailing;

  /// Overrides the default [AppTextStyles.labelLarge] (e.g. a muted color
  /// for dense log-section headers).
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: labelStyle ?? AppTextStyles.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
