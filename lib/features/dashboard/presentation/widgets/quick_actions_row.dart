// Path: widgets\quick_actions_row.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

/// Horizontal scroll of quick-action pills for fast logging.
///
/// Reference: Blueprint §3.1 — Quick Actions (small pill buttons, Secondary
/// style). Keeps fast food logging one tap away without leaving the screen.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    required this.actions,
  });

  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            AppButton(
              label: actions[i].label,
              icon: actions[i].icon,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              onPressed: actions[i].onTap,
            ),
            if (i < actions.length - 1)
              const SizedBox(width: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class QuickAction {
  const QuickAction({
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
}