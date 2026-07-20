// Path: pages\dashboard_page.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

/// Dashboard page — Main overview of daily macros and progress.
///
/// Reference: Blueprint §3.1 — Dashboard (Home)
/// 
/// Screen hierarchy:
/// 1. Page Header (greeting + date)
/// 2. Calorie Hero (ring + numeral)
/// 3. Macro Overview (3-tile row: Protein / Carbs / Fat)
/// 4. Quick Stats row
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,  // 20px screen margin
            AppSpacing.lg,  // 16px top
            AppSpacing.xl,  // 20px screen margin
            AppSpacing.quadXl * 2, // Extra bottom padding for nav
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Page Header
              const _PageHeader(),

              const SizedBox(height: AppSpacing.xxxl),

              // 2. Calorie Hero
              const _CalorieHero(),

              const SizedBox(height: AppSpacing.xxxl),

              // 3. Macro Overview
              _buildSectionLabel(context, "TODAY'S MACROS"),
              const SizedBox(height: AppSpacing.md),
              const _MacroOverview(),

              const SizedBox(height: AppSpacing.xxxl),

              // 4. Quick Stats
              _buildSectionLabel(context, 'QUICK STATS'),
              const SizedBox(height: AppSpacing.md),
              const _QuickStatsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: AppTextStyles.labelLarge,
    );
  }
}

/// Section 1: Page header with greeting and date
class _PageHeader extends StatelessWidget {
  const _PageHeader();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: AppTextStyles.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _getFormattedDate(),
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}

/// Section 2: Calorie Hero — progress ring + Ndot numeral
class _CalorieHero extends StatelessWidget {
  const _CalorieHero();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          // Calorie ring (visual circle placeholder)
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.divider,
                width: 8,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '0',
                    style: AppTextStyles.displayLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'of 2,400 kcal',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section 3: Macro Overview — 3-tile row (Protein / Carbs / Fat)
class _MacroOverview extends StatelessWidget {
  const _MacroOverview();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _MacroTile(
          label: 'PROTEIN',
          value: '0',
          target: '180g',
          macroColor: AppColors.protein,
          progress: 0.0,
        )),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _MacroTile(
          label: 'CARBS',
          value: '0',
          target: '250g',
          macroColor: AppColors.carbs,
          progress: 0.0,
        )),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _MacroTile(
          label: 'FAT',
          value: '0',
          target: '65g',
          macroColor: AppColors.fat,
          progress: 0.0,
        )),
      ],
    );
  }
}

/// A single macro tile in the 3-tile row
///
/// Reference: Blueprint §2.3 — Macro Tile
class _MacroTile extends StatelessWidget {
  const _MacroTile({
    required this.label,
    required this.value,
    required this.target,
    required this.macroColor,
    required this.progress,
  });

  final String label;
  final String value;
  final String target;
  final Color macroColor;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.standard,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: AppTextStyles.macroLabel,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Value + Target
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.macroValue.copyWith(color: macroColor),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  '/ $target',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(macroColor.withValues(alpha: 0.8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section 4: Quick Stats row
class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatTile(label: 'MEALS', value: '0')),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _StatTile(label: 'STREAK', value: '0')),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _StatTile(label: 'GOAL', value: '0%')),
      ],
    );
  }
}

/// A single stat tile for the quick stats row
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.standard,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.macroLabel,
          ),
        ],
      ),
    );
  }
}