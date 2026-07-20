// Path: pages\home_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';

/// Home page - Main entry point of the application.
/// 
/// This page serves as the primary navigation hub, directing users to
/// dashboard, meal tracking, settings, and analytics features.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo / Title Area
              Icon(
                Icons.fitness_center_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              
              Text(
                'Macro Tracker',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              
              Text(
                'Track your nutrition with precision',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.quadXl),
              
              // Quick Navigation Cards
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    children: [
                      _NavigationCard(
                        icon: Icons.dashboard_outlined,
                        title: 'Dashboard',
                        subtitle: 'View your daily progress',
                        onTap: () => context.go('/dashboard'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _NavigationCard(
                        icon: Icons.restaurant_outlined,
                        title: 'Meal Tracking',
                        subtitle: 'Log your meals quickly',
                        onTap: () => context.go('/meal-tracking'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _NavigationCard(
                        icon: Icons.analytics_outlined,
                        title: 'Analytics',
                        subtitle: 'Insights and trends',
                        onTap: () => context.go('/analytics'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _NavigationCard(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'Customize your experience',
                        onTap: () => context.go('/settings'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.xxl),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
