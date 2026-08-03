// Path: widgets\streak_card.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_ring.dart';

/// Streak card showing current streak, longest streak, flame icon,
/// circular progress ring, weekly activity dots, milestone badge,
/// and subtle pulse + glow animation.
///
/// Nothing OS style: high information density, red accent, dot matrix numbers.
/// Interactive: tapping navigates to the analytics page for detailed history.
class StreakCard extends StatefulWidget {
  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.weeklyGoalDays = const [true, true, true, true, false, true, false],
    this.onTap,
  });

  final int currentStreak;
  final int longestStreak;
  final List<bool> weeklyGoalDays;
  final VoidCallback? onTap;

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Returns the next milestone threshold above the current streak.
  int _nextMilestone(int current) {
    if (current < 7) return 7;
    if (current < 14) return 14;
    if (current < 30) return 30;
    if (current < 60) return 60;
    if (current < 100) return 100;
    return 365;
  }

  /// Returns a label for the current milestone.
  String _milestoneLabel(int streak) {
    if (streak >= 100) return 'Century Club';
    if (streak >= 60) return 'Two Months';
    if (streak >= 30) return 'Monthly Master';
    if (streak >= 14) return 'Fortnight';
    if (streak >= 7) return 'Week Warrior';
    return 'Getting Started';
  }

  @override
  Widget build(BuildContext context) {
    final streakProgress = widget.longestStreak > 0
        ? (widget.currentStreak / widget.longestStreak).clamp(0.0, 1.0)
        : 0.0;

    final nextMilestone = _nextMilestone(widget.currentStreak);
    final daysToNext = (nextMilestone - widget.currentStreak).clamp(0, nextMilestone);
    final milestoneLabel = _milestoneLabel(widget.currentStreak);
    final completedDays = widget.weeklyGoalDays.where((d) => d).length;

    return AppCard(
      onTap: widget.onTap,
      accentColor: AppColors.primary,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: label + milestone badge + flame icon with glow
            Row(
              children: [
                Text('STREAK', style: AppTextStyles.tinyMedium),
                const Spacer(),
                // Milestone badge
                if (widget.currentStreak >= 7)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                    child: Text(
                      milestoneLabel,
                      style: AppTextStyles.tiny.copyWith(
                        color: AppColors.goal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: AppSpacing.sm),
                // Flame icon with animated glow
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary
                              .withValues(alpha: _glowAnimation.value),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Icon(
                          Icons.local_fire_department,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Progress ring with number inside
            Center(
              child: SizedBox(
                width: 72,
                height: 72,
                child: AppProgressRing(
                  progress: streakProgress,
                  size: 72,
                  strokeWidth: 5,
                  color: AppColors.primary,
                  child: Center(
                    child: Text(
                      '${widget.currentStreak}',
                      style: const TextStyle(
                        fontFamily: kNothingFont,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onPrimary,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Longest streak label
            Center(
              child: Text(
                'Longest: ${widget.longestStreak} days',
                style: AppTextStyles.tiny,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Weekly activity dots
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.weeklyGoalDays.length, (i) {
                  final isCompleted = widget.weeklyGoalDays[i];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.goal
                          : AppColors.textDisabled.withValues(alpha: 0.3),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // Weekly summary text
            Center(
              child: Text(
                '$completedDays/7 days this week',
                style: AppTextStyles.tiny.copyWith(
                  color: completedDays >= 5
                      ? AppColors.success
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Next milestone progress
            if (widget.currentStreak < nextMilestone) ...[
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: widget.currentStreak / nextMilestone,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.goal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Center(
                child: Text(
                  '$daysToNext days to $milestoneLabel',
                  style: AppTextStyles.tiny.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      padding: EdgeInsets.zero,
      borderRadius: AppBorderRadius.md,
      level: 1,
      clip: false,
    );
  }
}
