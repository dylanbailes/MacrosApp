// Path: widgets\app_section_header.dart
import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// A section header label used throughout the app.
///
/// Renders as an uppercase label with letter-spacing, matching the spec's
/// "Label" style (Inter Medium 13/16, +4% tracking, ALL CAPS).
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.label,
    this.padding = EdgeInsets.zero,
  });

  final String label;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelLarge,
      ),
    );
  }
}