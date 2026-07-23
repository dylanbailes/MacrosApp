// Path: widgets\water_card.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_interactive_card.dart';

/// Water intake card with vertical dot fill gauge, progress %, drink count,
/// projected completion, cyan accent, and ambient glow.
///
/// Nothing OS style: dot matrix for numbers, Geist for labels, cyan accent.
class WaterCard extends StatefulWidget {
  const WaterCard({
    super.key,
    required this.consumed,
    required this.goal,
    required this.drinkCount,
    required this.projected,
  });

  final double consumed;
  final double goal;
  final int drinkCount;
  final double projected;

  @override
  State<WaterCard> createState() => _WaterCardState();
}

class _WaterCardState extends State<WaterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(WaterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.consumed != widget.consumed) {
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
    final progress = widget.goal > 0
        ? (widget.consumed / widget.goal).clamp(0.0, 1.0)
        : 0.0;
    const totalDots = 10;

    return AppInteractiveCard(
      padding: EdgeInsets.zero,
      borderRadius: AppBorderRadius.md,
      level: 2,
      accentColor: AppColors.water,
      clip: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('WATER', style: AppTextStyles.tinyMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _fillAnimation,
                    builder: (context, child) {
                      final animatedFilled = (_fillAnimation.value * totalDots).round();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(totalDots, (i) {
                          final isFilled = i < animatedFilled;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isFilled ? AppColors.water : AppColors.divider,
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.consumed.toStringAsFixed(1)}L',
                          style: AppTextStyles.cardMetric.copyWith(color: AppColors.water),
                        ),
                        const SizedBox(height: 2),
                        Text('of ${widget.goal.toStringAsFixed(1)}L', style: AppTextStyles.caption),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${(progress * 100).round()}% complete',
                          style: AppTextStyles.tiny.copyWith(color: AppColors.water),
                        ),
                        const SizedBox(height: 2),
                        Text('${widget.drinkCount} drinks today', style: AppTextStyles.tiny),
                        const SizedBox(height: 2),
                        Text('Est. ${widget.projected.toStringAsFixed(1)}L by 11pm', style: AppTextStyles.tiny),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}