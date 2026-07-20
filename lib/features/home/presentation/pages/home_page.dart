// Path: pages\home_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

/// The main navigation shell of the application.
/// 
/// Reference: Blueprint §2.5 — uses floating pill bottom nav with FAB
/// Uses StatefulShellRoute to preserve state across tabs.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Main content
          navigationShell,
          
          // Floating bottom nav bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _goBranch,
            ),
          ),
          
          // FAB — positioned between Home and Analytics tabs
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: GestureDetector(
                  onTap: () {
                    // TODO: Open Food Search (full-screen push)
                  },
                  onLongPress: () {
                    // TODO: Open Quick Add (bottom sheet)
                  },
                  child: Container(
                    width: 64,
                    height: 64,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}