// Path: pages\log_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/log_day_summary.dart';
import '../widgets/log_meal_section.dart';
import '../widgets/log_quick_input_bar.dart';

/// The Food Log screen — a chronological, editable record of everything
/// logged today, grouped by meal sections.
///
/// Blueprint §3.2: Food Log
/// Features:
/// - Sticky header with "Log" title and date
/// - Daily calorie summary bar
/// - Quick input row: Scan barcode / Take photo / Search
/// - Meal sections (Breakfast, Lunch, Dinner, Snacks) with fake data
class LogPage extends StatelessWidget {
  const LogPage({super.key});

  // ── Fake meal data ──────────────────────────────────────────────────────

  static const _targetCalories = 2400;

  static final _breakfastEntries = [
    FoodEntry(
      name: 'Oatmeal with Berries',
      servingInfo: '1 cup · 8:30 AM',
      calories: 310,
      proteinGrams: 12,
      carbsGrams: 54,
      fatGrams: 6,
      icon: Icons.breakfast_dining_outlined,
    ),
    FoodEntry(
      name: 'Black Coffee',
      servingInfo: '12 oz · 8:15 AM',
      calories: 5,
      proteinGrams: 0,
      carbsGrams: 0,
      fatGrams: 0,
      icon: Icons.coffee_outlined,
    ),
    FoodEntry(
      name: 'Banana',
      servingInfo: '1 medium · 9:00 AM',
      calories: 105,
      proteinGrams: 1,
      carbsGrams: 27,
      fatGrams: 0,
      icon: Icons.grass_outlined,
    ),
  ];

  static final _lunchEntries = [
    FoodEntry(
      name: 'Grilled Chicken Salad',
      servingInfo: '1 bowl · 12:30 PM',
      calories: 420,
      proteinGrams: 38,
      carbsGrams: 12,
      fatGrams: 24,
      icon: Icons.lunch_dining_outlined,
    ),
    FoodEntry(
      name: 'Sparkling Water',
      servingInfo: '16 oz · 12:15 PM',
      calories: 0,
      proteinGrams: 0,
      carbsGrams: 0,
      fatGrams: 0,
      icon: Icons.water_drop_outlined,
    ),
  ];

  static final _dinnerEntries = [
    FoodEntry(
      name: 'Pan-Seared Salmon',
      servingInfo: '6 oz fillet · 7:00 PM',
      calories: 420,
      proteinGrams: 40,
      carbsGrams: 0,
      fatGrams: 28,
      icon: Icons.set_meal_outlined,
    ),
    FoodEntry(
      name: 'Roasted Asparagus',
      servingInfo: '1 cup · 7:00 PM',
      calories: 40,
      proteinGrams: 4,
      carbsGrams: 4,
      fatGrams: 2,
      icon: Icons.eco_outlined,
    ),
    FoodEntry(
      name: 'Brown Rice',
      servingInfo: '1 cup cooked · 7:00 PM',
      calories: 260,
      proteinGrams: 6,
      carbsGrams: 54,
      fatGrams: 2,
      icon: Icons.grass_outlined,
    ),
  ];

  static final _snacksEntries = [
    FoodEntry(
      name: 'Greek Yogurt',
      servingInfo: '1 container · 3:30 PM',
      calories: 120,
      proteinGrams: 16,
      carbsGrams: 6,
      fatGrams: 3,
      icon: Icons.icecream_outlined,
    ),
    FoodEntry(
      name: 'Almonds',
      servingInfo: '1 oz · 4:00 PM',
      calories: 60,
      proteinGrams: 2,
      carbsGrams: 2,
      fatGrams: 5,
      icon: Icons.child_care_outlined,
    ),
  ];

  static const _breakfastCals = 420;
  static const _lunchCals = 420;
  static const _dinnerCals = 720;
  static const _snacksCals = 180;
  static int get _totalCals =>
      _breakfastCals + _lunchCals + _dinnerCals + _snacksCals;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateString =
        '${_monthAbbr(today.month)} ${today.day}, ${today.year}';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Sticky Header ────────────────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _LogHeaderDelegate(dateString: dateString),
            ),

            // ── Daily Summary ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: LogDaySummary(
                consumedCalories: _totalCals,
                targetCalories: _targetCalories,
                proteinGrams: 120,
                carbsGrams: 160,
                fatGrams: 70,
                proteinTarget: 180,
                carbsTarget: 250,
                fatTarget: 65,
              ),
            ),

            // ── Quick Input Row ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: LogQuickInputBar(
                onScanBarcode: () => _showComingSoon(context, 'Barcode Scan'),
                onTakePhoto: () => _showComingSoon(context, 'AI Photo Analysis'),
                onSearch: () => _showComingSoon(context, 'Food Search'),
              ),
            ),

            // ── Meal Sections ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  LogMealSection(
                    label: 'Breakfast',
                    totalCalories: _breakfastCals,
                    foodEntries: _breakfastEntries,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  LogMealSection(
                    label: 'Lunch',
                    totalCalories: _lunchCals,
                    foodEntries: _lunchEntries,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  LogMealSection(
                    label: 'Dinner',
                    totalCalories: _dinnerCals,
                    foodEntries: _dinnerEntries,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  LogMealSection(
                    label: 'Snacks',
                    totalCalories: _snacksCals,
                    foodEntries: _snacksEntries,
                  ),
                  const SizedBox(height: AppSpacing.quadXl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ComingSoonToast(feature: feature, onDismiss: () {
        entry.remove();
      }),
    );
    overlay.insert(entry);
  }

  static String _monthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }
}

// ── Sticky Header Delegate ─────────────────────────────────────────────

class _LogHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _LogHeaderDelegate({required this.dateString});

  final String dateString;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final opacity = (1.0 - (shrinkOffset / maxExtent).clamp(0.0, 1.0));

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: maxExtent, maxHeight: maxExtent),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: opacity,
                    child: Text(
                      dateString,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Food Log',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant _LogHeaderDelegate oldDelegate) {
    return dateString != oldDelegate.dateString;
  }
}

// ── Coming Soon Toast ─────────────────────────────────────────────────

class _ComingSoonToast extends StatefulWidget {
  const _ComingSoonToast({
    required this.feature,
    required this.onDismiss,
  });

  final String feature;
  final VoidCallback onDismiss;

  @override
  State<_ComingSoonToast> createState() => _ComingSoonToastState();
}

class _ComingSoonToastState extends State<_ComingSoonToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(AppBorderRadius.pill),
              border: Border.all(color: AppColors.dividerStrong, width: 1),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.sparkles,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '${widget.feature} — coming soon',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}