// Path: features/dashboard/presentation/widgets/streak_card.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_interactive_card.dart';
import '../../../../core/widgets/app_progress_ring.dart';

/// Streak card showing current streak, longest streak, flame icon,
/// circular progress ring, and subtle pulse animation.
///
/// Nothing OS style: high information density, red accent, dot matrix numbers.
class StreakCard extends StatefulWidget {
  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streakProgress = widget.longestStreak > 0
        ? (widget.currentStreak / widget.longestStreak).clamp(0.0, 1.0)
        : 0.0;

    // Child content wrapped in AppInteractiveCard for hover/scale/glow
    return AppInteractiveCard(
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
            // Top row: label + flame icon
            Row(
              children: [
                Text('STREAK', style: AppTextStyles.tinyMedium),
                const Spacer(),
                AnimatedBuilder(
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
                        fontFamily: 'Nothing',
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onPrimary,
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
          ],
        ),
      ),
      padding: EdgeInsets.zero,
      borderRadius: AppBorderRadius.md,
      level: 1,
      accentColor: AppColors.primary,
      clip: false,
    );
  }
}