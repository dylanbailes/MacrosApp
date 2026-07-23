// Path: widgets\ai_coach_entry_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

/// Persistent AI Coach entry card shown at the top of the Dashboard.
///
/// Reference: Blueprint §3.1 — AI Coach Entry Card (screen-unique)
/// Hero-radius card, accent-tinted sparkle icon, one truncated insight line,
/// trailing chevron. Full-card tap → AI Coach screen.
class AiCoachEntryCard extends StatelessWidget {
  const AiCoachEntryCard({
    super.key,
    required this.insight,
  });

  final String insight;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.hero,
      onTap: () => context.push('/profile/coach'),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          // Accent-tinted sparkle icon
          Container(
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppBorderRadius.xs),
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              size: AppSpacing.iconLg,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Insight line (truncated, single line by spec)
          Expanded(
            child: Text(
              insight,
              style: AppTextStyles.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            Icons.chevron_right,
            size: AppSpacing.iconMd,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}