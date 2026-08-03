// Path: pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_toast.dart';
import '../providers/settings_providers.dart';
import '../widgets/settings_sheets.dart';

/// Settings — account, preferences, data, and app-level settings.
///
/// Reference: Blueprint §3.10 — Settings
///
/// A full-screen push (root navigator, no bottom nav) with a back arrow in
/// the shared [AppScreenHeader]. Setting rows reuse the shared [AppListRow]:
/// Units opens a picker sheet, Notifications are inline toggles, Goals opens
/// the goals editor, and About/Open Source show real content. Rows that need
/// a backend (account, data export/import, sign out) keep a light
/// "coming soon" toast until those systems exist. Sign Out is isolated at
/// the bottom as a destructive action.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _comingSoon(BuildContext context, String feature) {
    showAppToast(context, message: '$feature coming soon');
  }

  Future<void> _pickUnits(BuildContext context, WidgetRef ref) async {
    final selected = await showAppBottomSheet<UnitSystem>(
      context,
      child: UnitPickerSheet(current: ref.read(settingsProvider).unitSystem),
    );
    if (selected != null) {
      ref.read(settingsProvider.notifier).setUnitSystem(selected);
    }
  }

  Future<void> _editGoals(BuildContext context) {
    return showAppBottomSheet<void>(
      context,
      child: const GoalsEditorSheet(),
    );
  }

  Future<void> _showAbout(BuildContext context) {
    return showAppBottomSheet<void>(context, child: const AboutSheet());
  }

  Future<void> _showOpenSource(BuildContext context) {
    return showAppBottomSheet<void>(context, child: const OpenSourceSheet());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppScreenHeader(
              title: 'Settings',
              leading: AppButton(
                onPressed: () => context.pop(),
                icon: Icons.arrow_back,
                variant: AppButtonVariant.icon,
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xs,
                  AppSpacing.xl,
                  AppSpacing.quadXl,
                ),
                children: [
                  _SettingsSection(
                    title: 'Account',
                    children: [
                      _SettingTile(
                        icon: Icons.person_outline,
                        title: 'Account',
                        subtitle: 'Manage your profile',
                        onTap: () => _comingSoon(context, 'Account'),
                      ),
                      _SettingTile(
                        icon: Icons.fitness_center_outlined,
                        title: 'Goals',
                        subtitle: 'Calorie & macro targets',
                        onTap: () => _editGoals(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  _SettingsSection(
                    title: 'Preferences',
                    children: [
                      // Units — trailing value + chevron → picker sheet.
                      _SettingTile(
                        icon: Icons.straighten_outlined,
                        title: 'Units',
                        subtitle: settings.unitSystem.subtitle,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              settings.unitSystem.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Icons.chevron_right,
                              size: AppSpacing.iconMd,
                              color: AppColors.textTertiary,
                            ),
                          ],
                        ),
                        onTap: () => _pickUnits(context, ref),
                      ),
                      // Inline notification toggles (whole row toggles).
                      _SettingTile(
                        icon: Icons.notifications_outlined,
                        title: 'Meal Reminders',
                        subtitle: 'Remind me at each meal',
                        trailing: _AppSwitch(
                          value: settings.mealReminders,
                          onChanged: (value) => ref
                              .read(settingsProvider.notifier)
                              .setMealReminders(value),
                        ),
                        onTap: () => ref
                            .read(settingsProvider.notifier)
                            .setMealReminders(!settings.mealReminders),
                      ),
                      _SettingTile(
                        icon: Icons.summarize_outlined,
                        title: 'Daily Summary',
                        subtitle: 'Evening progress recap',
                        trailing: _AppSwitch(
                          value: settings.dailySummary,
                          onChanged: (value) => ref
                              .read(settingsProvider.notifier)
                              .setDailySummary(value),
                        ),
                        onTap: () => ref
                            .read(settingsProvider.notifier)
                            .setDailySummary(!settings.dailySummary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  _SettingsSection(
                    title: 'Data',
                    children: [
                      _SettingTile(
                        icon: Icons.download_outlined,
                        title: 'Export Data',
                        subtitle: 'Download your data',
                        onTap: () => _comingSoon(context, 'Export'),
                      ),
                      _SettingTile(
                        icon: Icons.upload_outlined,
                        title: 'Import Data',
                        subtitle: 'Restore from backup',
                        onTap: () => _comingSoon(context, 'Import'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  _SettingsSection(
                    title: 'About',
                    children: [
                      _SettingTile(
                        icon: Icons.info_outline,
                        title: 'About App',
                        subtitle: 'Version 1.0.0',
                        onTap: () => _showAbout(context),
                      ),
                      _SettingTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () => _comingSoon(context, 'Privacy Policy'),
                      ),
                      _SettingTile(
                        icon: Icons.code_outlined,
                        title: 'Open Source',
                        subtitle: 'Libraries & licenses',
                        onTap: () => _showOpenSource(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.quadXl),
                  // Sign Out — destructive, isolated at the bottom.
                  AppButton(
                    label: 'Sign Out',
                    icon: Icons.logout,
                    variant: AppButtonVariant.destructive,
                    isFullWidth: true,
                    onPressed: () => _comingSoon(context, 'Sign out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A labeled group of setting rows: uppercase section label + tight row stack.
class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(label: title),
        const SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          children[i],
        ],
      ],
    );
  }
}

/// A single setting row via the shared [AppListRow]. [trailing] defaults to a
/// chevron; pass a Switch or a value+chevron for setting-specific rows.
class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppListRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            size: AppSpacing.iconMd,
            color: AppColors.textTertiary,
          ),
      onTap: onTap,
    );
  }
}

/// The app's switch — Nothing-palette pill: signal-red track when on, muted
/// surface when off (Blueprint §3.10 — Toggle/Switch).
class _AppSwitch extends StatelessWidget {
  const _AppSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.primary,
      activeColor: AppColors.onPrimary,
      inactiveTrackColor: AppColors.surfaceElevated,
      inactiveThumbColor: AppColors.textTertiary,
    );
  }
}
