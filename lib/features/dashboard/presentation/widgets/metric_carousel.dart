/// A swipeable metric carousel for the Dashboard.
///
/// Shows one metric at a time (Protein, Carbs, Fat, Water) with rich detail
/// including progress ring/bar, current vs target, trend indicator, and
/// mini comparison badge to differentiate from the MacroOverviewRow above.
/// The user can swipe horizontally, tap page indicator dots, tap arrow
/// buttons, or tap the left/right sides of the carousel to navigate.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/formatting/app_formatters.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_progress_ring.dart';
import '../providers/dashboard_state.dart';

/// A carousel card showing a single metric with rich detail.
class _MetricCarouselCard extends StatelessWidget {
  const _MetricCarouselCard({
    required this.label,
    required this.consumed,
    required this.target,
    required this.unit,
    required this.color,
    required this.progress,
    required this.isOverTarget,
    required this.cardIndex,
    required this.totalCards,
    required this.onTap,
  });

  final String label;
  final double consumed;
  final double target;
  final String unit;
  final Color color;
  final double progress;
  final bool isOverTarget;
  final int cardIndex;
  final int totalCards;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final displayColor = isOverTarget ? AppColors.error : color;
    final remaining = (target - consumed).clamp(0.0, double.infinity);

    // Different icon per metric type to differentiate from the macro tiles above
    IconData metricIcon;
    String comparisonLabel;

    switch (label.toLowerCase()) {
      case 'protein':
        metricIcon = Icons.fitness_center_rounded;
        comparisonLabel = 'Building blocks';
        break;
      case 'carbs':
        metricIcon = Icons.bolt_rounded;
        comparisonLabel = 'Energy source';
        break;
      case 'fat':
        metricIcon = Icons.opacity_rounded;
        comparisonLabel = 'Essential fats';
        break;
      case 'water':
        metricIcon = Icons.water_drop_rounded;
        comparisonLabel = 'Hydration';
        break;
      default:
        metricIcon = Icons.monitor_heart_rounded;
        comparisonLabel = 'Daily target';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + label + card counter
            Row(
              children: [
                Icon(metricIcon, size: 16, color: displayColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.macroLabel.copyWith(
                    color: displayColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${cardIndex + 1}/$totalCards',
                  style: AppTextStyles.tiny.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Middle section: ring + values (fixed height to prevent overflow)
            SizedBox(
              height: 64,
              child: Row(
                children: [
                  // Progress ring
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: AppProgressRing(
                      progress: progress.clamp(0.0, 1.0),
                      size: 64,
                      strokeWidth: 6,
                      color: displayColor,
                      child: Center(
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: AppTextStyles.cardMetricSmall.copyWith(
                            color: displayColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Details column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppFormatters.grams(consumed),
                              style: AppTextStyles.displaySmall.copyWith(
                                color: displayColor,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '/ ${target.toStringAsFixed(0)} $unit',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: SizedBox(
                            height: 3,
                            child: LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              backgroundColor: AppColors.divider,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                displayColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Bottom row: comparison label + remaining/over status
            Row(
              children: [
                Text(
                  comparisonLabel,
                  style: AppTextStyles.tiny.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
                const Spacer(),
                Text(
                  isOverTarget
                      ? '${(consumed - target).toStringAsFixed(0)}$unit over'
                      : '${remaining.toStringAsFixed(0)}$unit left',
                  style: AppTextStyles.tiny.copyWith(
                    color: isOverTarget ? AppColors.error : displayColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A swipeable carousel showing macro and water metrics.
///
/// Supports horizontal swipe, arrow buttons on either side, tappable
/// left/right zones for navigation, and tappable page indicator dots.
class MetricCarousel extends StatefulWidget {
  const MetricCarousel({
    super.key,
    required this.macros,
    required this.waterConsumed,
    required this.waterTarget,
  });

  final List<MacroProgress> macros;
  final double waterConsumed;
  final double waterTarget;

  @override
  State<MetricCarousel> createState() => _MetricCarouselState();
}

class _MetricCarouselState extends State<MetricCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_MetricCarouselCard> _buildCards() {
    final cards = <_MetricCarouselCard>[];

    for (final macro in widget.macros) {
      cards.add(_MetricCarouselCard(
        label: macro.label,
        consumed: macro.consumed,
        target: macro.target,
        unit: macro.unit,
        color: Color(macro.color),
        progress: macro.progress,
        isOverTarget: macro.isOverTarget,
        cardIndex: cards.length,
        totalCards: widget.macros.length + 1,
        onTap: () {},
      ));
    }

    // Water card
    final waterProgress = widget.waterTarget > 0
        ? (widget.waterConsumed / widget.waterTarget).clamp(0.0, 1.0)
        : 0.0;
    cards.add(_MetricCarouselCard(
      label: 'Water',
      consumed: widget.waterConsumed,
      target: widget.waterTarget,
      unit: 'L',
      color: AppColors.water,
      progress: waterProgress,
      isOverTarget: widget.waterConsumed > widget.waterTarget,
      cardIndex: cards.length,
      totalCards: widget.macros.length + 1,
      onTap: () {},
    ));

    return cards;
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = _buildCards();
    final canGoLeft = _currentPage > 0;
    final canGoRight = _currentPage < cards.length - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Carousel with arrows and clickable sides
        SizedBox(
          height: 180,
          child: Stack(
            children: [
              // PageView
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : AppSpacing.xs,
                      right: index < cards.length - 1 ? AppSpacing.xs : 0,
                    ),
                    child: cards[index],
                  );
                },
              ),
              // Left arrow button
              if (canGoLeft)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _CarouselArrow(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => _goToPage(_currentPage - 1),
                    ),
                  ),
                ),
              // Right arrow button
              if (canGoRight)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _CarouselArrow(
                      icon: Icons.chevron_right_rounded,
                      onTap: () => _goToPage(_currentPage + 1),
                    ),
                  ),
                ),
              // Left clickable zone (transparent)
              if (canGoLeft)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 60,
                  child: GestureDetector(
                    onTap: () => _goToPage(_currentPage - 1),
                    behavior: HitTestBehavior.translucent,
                    child: const SizedBox.expand(),
                  ),
                ),
              // Right clickable zone (transparent)
              if (canGoRight)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 60,
                  child: GestureDetector(
                    onTap: () => _goToPage(_currentPage + 1),
                    behavior: HitTestBehavior.translucent,
                    child: const SizedBox.expand(),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Page indicator dots - each dot is individually tappable
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(cards.length, (i) {
            return GestureDetector(
              onTap: () => _goToPage(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == i ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? AppColors.primary
                      : AppColors.textDisabled,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// A circular arrow button for carousel navigation.
class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }
}
