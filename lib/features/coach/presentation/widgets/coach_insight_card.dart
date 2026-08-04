// Path: widgets/coach_insight_card.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

/// The AI Coach's hero Insight Card.
///
/// Reference: Blueprint §3.8 — Insight Card (Hero-radius card)
///
/// This is the **expanded** version of the Dashboard's one-line teaser
/// ([AiCoachEntryCard]): the same insight from [coachInsightProvider], shown
/// in full with a sparkle glyph and a quiet refresh action so the user can
/// pull a fresh suggestion without leaving the screen.
class CoachInsightCard extends StatelessWidget {
  const CoachInsightCard({
    required this.insight,
    this.onRefresh,
    super.key,
  });

  /// The full insight text (source of truth: [coachInsightProvider]).
  final String insight;

  /// Optional refresh handler; renders a small ghost button when provided.
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.hero,
      accentColor: AppColors.primary,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row: accent-tinted sparkle + section label + refresh.
          Row(
            children: [
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
              const SizedBox(width: AppSpacing.md),
              Text(
                "TODAY'S INSIGHT",
                style: AppTextStyles.sectionHeader,
              ),
              const Spacer(),
              if (onRefresh != null)
                AppButton(
                  key: const Key('coach-refresh'),
                  onPressed: onRefresh,
                  icon: Icons.refresh,
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.small,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Full insight — never truncated here (the teaser is truncated).
          Text(
            insight,
            style: AppTextStyles.bodyLarge.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
