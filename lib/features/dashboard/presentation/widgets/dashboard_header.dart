// Path: features/dashboard/presentation/widgets/dashboard_header.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_date_navigator.dart';
import '../../../../core/widgets/app_screen_header.dart';

/// Dashboard page header: greeting + settings gear, with a date navigator
/// (◀ today ▶) underneath so the whole dashboard can be viewed for past days.
///
/// Reference: Blueprint §3.1 — Page Header (date + greeting, settings-gear shortcut)
/// Composes the shared [AppScreenHeader] chrome.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    required this.greeting,
    required this.date,
    required this.onPreviousDay,
    required this.onNextDay,
    this.onToday,
    super.key,
  });

  final String greeting;

  /// The day currently being viewed (shared with the Log page).
  final DateTime date;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback? onToday;

  @override
  Widget build(BuildContext context) {
    return AppScreenHeader(
      // The dashboard page already applies the screen margin via
      // SliverPadding, so the header must not re-add horizontal padding.
      padding: EdgeInsets.zero,
      title: greeting,
      // Settings gear — 48px touch target (Blueprint Rule 16), pushed on
      // the root navigator so it covers the shell (no bottom nav).
      trailing: Semantics(
        label: 'Open settings',
        child: AppButton(
          onPressed: () => context.push(AppRoutes.settings),
          icon: Icons.settings_outlined,
          variant: AppButtonVariant.icon,
        ),
      ),
      bottom: AppDateNavigator(
        date: date,
        onPrevious: onPreviousDay,
        onNext: onNextDay,
        onToday: onToday,
      ),
    );
  }
}
