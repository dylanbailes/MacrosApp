// Path: widgets/app_screen_header.dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// The shared screen header: title + optional subtitle with an optional
/// trailing action, plus an optional bottom slot (e.g. a date navigator).
///
/// Reference: Blueprint §3.1 — Page Header
///
/// Screens compose this instead of forking one-off headers:
/// - Dashboard: greeting + settings gear, date navigator below
/// - Food Log: "Food Log" title + date navigator below
/// - Food Search, Analytics, Profile, Settings: title + back/settings gear
class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.leading,
    this.bottom,
    this.padding,
  });

  /// Primary heading (e.g. a greeting or screen name).
  final String title;

  /// Optional secondary line beneath the title.
  final String? subtitle;

  /// Optional leading widget (back button, avatar) rendered before the title
  /// — for pushed screens that need a retreat affordance on the left.
  final Widget? leading;

  /// Optional trailing action (settings gear, back button, etc.). Aligned to
  /// the top so it doesn't stretch with a multiline title.
  final Widget? trailing;

  /// Optional slot rendered below the title row (e.g. [AppDateNavigator]).
  final Widget? bottom;

  /// Horizontal padding; defaults to the standard screen margin.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headlineLarge,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
          if (bottom != null) ...[
            const SizedBox(height: AppSpacing.sm),
            bottom!,
          ],
        ],
      ),
    );
  }
}
