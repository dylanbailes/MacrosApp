// Path: widgets\dashboard_header.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Dashboard page header: greeting + date on the left, settings gear on the right.
///
/// Reference: Blueprint §3.1 — Page Header (date + greeting, settings-gear shortcut)
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.greeting,
    required this.dateLabel,
  });

  final String greeting;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                dateLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Settings gear — 48px touch target (Blueprint Rule 16)
        Semantics(
          label: 'Open settings',
          child: GestureDetector(
            onTap: () => context.push('/profile/settings'),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: AppSpacing.buttonHeight,
              height: AppSpacing.buttonHeight,
              alignment: Alignment.center,
              child: const Icon(
                Icons.settings_outlined,
                size: AppSpacing.iconLg,
                color: AppColors.iconDefault,
              ),
            ),
          ),
        ),
      ],
    );
  }
}