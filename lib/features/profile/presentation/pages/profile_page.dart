// Path: pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/formatting/app_formatters.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../features/settings/presentation/providers/settings_providers.dart';
import '../../../../features/settings/presentation/widgets/settings_sheets.dart';

/// Profile — a personal summary hub (Blueprint §3.9).
///
/// Identity block (the app's only centered text), a Goals Summary card fed
/// the shared [settingsProvider] targets (tap to edit), and Settings entry
/// rows. Everything composes the shared chrome kit: [AppScreenHeader],
/// [AppCard], [AppListRow], [AppSectionHeader].
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppScreenHeader(
              title: 'Profile',
              // Settings gear — the primary action on this screen.
              trailing: Semantics(
                label: 'Open settings',
                child: AppButton(
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: Icons.settings_outlined,
                  variant: AppButtonVariant.icon,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.none,
              ),
            ),

            // ── Identity block (the app's one centered text block) ───────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Column(
                children: [
                  Container(
                    width: AppSpacing.avatarXl,
                    height: AppSpacing.avatarXl,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: AppSpacing.iconXl,
                      color: AppColors.iconDefault,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Your Profile',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Manage your account, goals, and preferences',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // ── Goals Summary card ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: AppCard(
                accentColor: AppColors.goal,
                onTap: () => showAppBottomSheet<void>(
                  context,
                  child: const GoalsEditorSheet(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: AppSectionHeader(label: 'Daily Goals'),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: AppSpacing.iconMd,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Calorie target — card metric numeral (Ndot ≥24px).
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          AppFormatters.comma(goals.calorieTarget),
                          style: AppTextStyles.cardMetric,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('kcal', style: AppTextStyles.numericUnit),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        _GoalMacro(
                          label: 'Protein',
                          value: '${goals.proteinTarget} g',
                          color: AppColors.protein,
                        ),
                        _GoalMacro(
                          label: 'Carbs',
                          value: '${goals.carbsTarget} g',
                          color: AppColors.carbs,
                        ),
                        _GoalMacro(
                          label: 'Fat',
                          value: '${goals.fatTarget} g',
                          color: AppColors.fat,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Settings entry rows ──────────────────────────────────────
            const SizedBox(height: AppSpacing.xxxl),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: AppSectionHeader(label: 'Settings'),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  _SettingsEntry(
                    icon: Icons.person_outline,
                    title: 'Account',
                    subtitle: 'Manage your profile',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _SettingsEntry(
                    icon: Icons.fitness_center_outlined,
                    title: 'Goals',
                    subtitle: 'Edit macro targets',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _SettingsEntry(
                    icon: Icons.straighten_outlined,
                    title: 'Units',
                    subtitle: 'Metric / Imperial',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _SettingsEntry(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Reminder settings',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.quadXl),
          ],
        ),
      ),
    );
  }
}

/// One macro target column inside the Goals Summary card.
class _GoalMacro extends StatelessWidget {
  const _GoalMacro({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.macroLabel),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// A Profile → Settings entry row; opens the Settings screen for now.
class _SettingsEntry extends StatelessWidget {
  const _SettingsEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return AppListRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Icon(
        Icons.chevron_right,
        size: AppSpacing.iconMd,
        color: AppColors.textTertiary,
      ),
      onTap: () => context.push(AppRoutes.settings),
    );
  }
}
