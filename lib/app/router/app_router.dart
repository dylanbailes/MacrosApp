import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/home/presentation/pages/error_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

/// Application route paths
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';
  static const String mealTracking = '/meal-tracking';
  static const String analytics = '/analytics';
}

/// Application router configuration using GoRouter.
/// 
/// Implements a feature-first navigation structure with smooth transitions.
final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Home Route - Main entry point
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          // Dashboard - Child of home
          GoRoute(
            path: 'dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              child: const DashboardPage(),
            ),
          ),

          // Settings - Child of home
          GoRoute(
            path: 'settings',
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              child: const SettingsPage(),
            ),
          ),

          // Meal Tracking - Placeholder route for future implementation
          GoRoute(
            path: 'meal-tracking',
            name: 'meal_tracking',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const Scaffold(
                body: Center(
                  child: Text('Meal Tracking - Coming Soon'),
                ),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          ),

          // Analytics - Placeholder route for future implementation
          GoRoute(
            path: 'analytics',
            name: 'analytics',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const Scaffold(
                body: Center(
                  child: Text('Analytics - Coming Soon'),
                ),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(routePath: state.uri.path),
  );
}
