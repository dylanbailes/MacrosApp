// Path: widgets\calorie_hero_card.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_animated_counter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_ring.dart';

/// The single most important number on the Dashboard: calories consumed vs target.
///
/// Reference: Blueprint §2.4 — Calorie Hero (ring + Ndot Display XL numeral)
/// Uses the ONE permitted ring on this screen. Tap opens a breakdown bottom sheet.
class CalorieHeroCard extends StatelessWidget {
  const CalorieHeroCard({
    super.key,
    required this.consumed,
    required this.target,
    this.onTap,
  });

  final int consumed;
  final int target;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = (target <= 0) ? 0.0 : (consumed / target).clamp(0.0, 1.0);
    final isOver = consumed > target;
    final remaining = (target - consumed).clamp(0, target);

    final Color ringColor = isOver ? AppColors.error : AppColors.energyNeutral;

    return AppCard(
      variant: AppCardVariant.hero,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: AppProgressRing(
              progress: progress,
              size: 180,
              strokeWidth: 12,
              color: ringColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ndot Display XL numeral (whitelisted hero case)
                    AppAnimatedCounter(
                      value: consumed,
                      style: AppTextStyles.displayLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'of ${target.toString()} kcal',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Remaining calories — the priority metric
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodyLarge,
              children: [
                TextSpan(
                  text: isOver
                      ? 'Over by '
                      : '${remaining.toString()} kcal remaining',
                  style: TextStyle(
                    color: isOver ? AppColors.error : AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isOver)
                  TextSpan(
                    text: '${(consumed - target).toString()} kcal',
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}