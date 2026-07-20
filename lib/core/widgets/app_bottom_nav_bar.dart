// Path: widgets\app_bottom_nav_bar.dart
import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

/// A floating pill-shaped bottom navigation bar with a raised FAB.
///
/// Reference: Blueprint §2.5 — Bottom Navigation Bar & FAB
/// 
/// Four slots: Home / Log (FAB) / Analytics / Profile
/// - Log is replaced by a raised circular FAB breaking the top edge of the bar
/// - Active tab gets accent.signal icon + label on a surface.02 pill behind it
/// - Cross-fade animation on tab switch, 150ms
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Home
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                ),
                // Spacer for FAB
                const SizedBox(width: 64),
                // Analytics
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart,
                    label: 'Analytics',
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                ),
                // Profile
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
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

/// A single navigation bar item
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: AppDurations.springCurve,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceElevated : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.iconDefault,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating Action Button for the Log action.
/// 
/// Reference: Blueprint §2.5 — breaks the top edge of the bottom nav bar
class AppNavFab extends StatelessWidget {
  const AppNavFab({
    super.key,
    this.onTap,
    this.onLongPress,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 64,
        height: 64,
        margin: const EdgeInsets.only(bottom: 32),
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.textOnPrimary,
          size: 28,
        ),
      ),
    );
  }
}