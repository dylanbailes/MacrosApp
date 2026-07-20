// Path: pages\settings_page.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';

/// Settings page - Application configuration and preferences.
/// 
/// This page will eventually include:
/// - User profile settings
/// - Macro goals configuration
/// - Unit preferences (metric/imperial)
/// - Notification settings
/// - Data export/import
/// - About the app
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Profile Section
            _SettingsSection(
              title: 'Profile',
              children: [
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Account',
                  subtitle: 'Manage your profile',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.fitness_center_outlined,
                  title: 'Goals',
                  subtitle: 'Set your macro targets',
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.xxxl),
            
            // Preferences Section
            _SettingsSection(
              title: 'Preferences',
              children: [
                _SettingsTile(
                  icon: Icons.straighten_outlined,
                  title: 'Units',
                  subtitle: 'Metric / Imperial',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Reminder settings',
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.xxxl),
            
            // Data Section
            _SettingsSection(
              title: 'Data',
              children: [
                _SettingsTile(
                  icon: Icons.download_outlined,
                  title: 'Export Data',
                  subtitle: 'Download your data',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.upload_outlined,
                  title: 'Import Data',
                  subtitle: 'Restore from backup',
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.xxxl),
            
            // About Section
            _SettingsSection(
              title: 'About',
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About App',
                  subtitle: 'Version 1.0.0',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.code_outlined,
                  title: 'Open Source',
                  subtitle: 'View on GitHub',
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.quadXl),
            
            // Sign Out Button (placeholder for future auth)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      onTap: onTap,
    );
  }
}
