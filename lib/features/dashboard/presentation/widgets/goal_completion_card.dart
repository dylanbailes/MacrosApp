// Path: features/dashboard/presentation/widgets/goal_completion_card.dart
import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

/// Goal completion card with radial progress indicator, percentage,
/// weekly mini calendar with days highlighted in red.
///
/// Nothing OS style: minimal, clean geometric spacing, red accent.
class GoalCompletionCard extends StatefulWidget {
  const GoalCompletionCard({
    required this.percentage, required this.daysCompleted, required this.daysTotal, required this.weeklyGoalDays, super.key,
  });

  final double percentage;
  final int daysCompleted;
  final int daysTotal;
  final List<bool> weeklyGoalDays;

  @override
  State<GoalCompletionCard> createState() => _GoalCompletionCardState();
}

class _GoalCompletionCardState extends State<GoalCompletionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fillAnimation = Tween<double>(begin: 0.0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(GoalCompletionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _fillAnimation = Tween<double>(begin: 0.0, end: widget.percentage).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: AppBorderRadius.md,
      level: 1,
      accentColor: AppColors.primary,
      clip: false,
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
            // Label
            Text('GOALS', style: AppTextStyles.tinyMedium),
            const SizedBox(height: AppSpacing.sm),
            // Radial progress + percentage
            Center(
              child: AnimatedBuilder(
                animation: _fillAnimation,
                builder: (context, child) => _RadialGoalProgress(
                  progress: _fillAnimation.value,
                  size: 72,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Days string
            Center(
              child: Text(
                '${widget.daysCompleted}/${widget.daysTotal} days',
                style: AppTextStyles.tiny,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Weekly mini calendar: row of 7 dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.weeklyGoalDays.length, (i) {
                final isHit = widget.weeklyGoalDays[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isHit ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadialGoalProgress extends StatelessWidget {
  const _RadialGoalProgress({
    required this.progress,
    required this.size,
  });

  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadialProgressPainter(
          progress: progress.clamp(0.0, 1.0),
          color: AppColors.primary,
          trackColor: AppColors.divider,
          strokeWidth: 5,
        ),
        child: Center(
          child: Text(
            '${(progress * 100).round()}%',
            style: AppTextStyles.titleSmall.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialProgressPainter extends CustomPainter {
  _RadialProgressPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Fill
    if (progress > 0) {
      final fillPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RadialProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}