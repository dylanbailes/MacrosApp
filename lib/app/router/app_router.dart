// Path: router\app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/coach/presentation/pages/coach_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/home/presentation/pages/error_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/log/presentation/pages/food_search_page.dart';
import '../../features/log/presentation/pages/log_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

/// Application route paths
class AppRoutes {
  AppRoutes._();

  static const String dashboard = '/dashboard';
  static const String log = '/log';

  /// Full-screen food search (pushed over the shell, no bottom nav).
  static const String foodSearch = '/log/search';
  static const String analytics = '/analytics';
  static const String coach = '/coach';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// Application router configuration using GoRouter.
///
/// Implements a feature-first navigation structure using StatefulShellRoute
/// to preserve state across main tabs.
final class AppRouter {
  AppRouter._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final dashboardNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'dashboard');
  static final logNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'log');
  static final analyticsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'analytics');
  static final profileNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'profile');

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            navigatorKey: dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardPage(),
                ),
              ),
            ],
          ),

          // Branch 1: Log (Meal Tracking)
          StatefulShellBranch(
            navigatorKey: logNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.log,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: LogPage(),
                ),
              ),
            ],
          ),

          // Branch 2: Analytics
          StatefulShellBranch(
            navigatorKey: analyticsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.analytics,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AnalyticsPage(),
                ),
              ),
            ],
          ),

          // Branch 3: Profile & Settings
          StatefulShellBranch(
            navigatorKey: profileNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfilePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'coach', // -> /profile/coach
                    builder: (context, state) => const CoachPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Full-screen food search — pushed on the root navigator so it covers
      // the shell (Blueprint: pushed/modal screens hide the bottom nav).
      GoRoute(
        path: AppRoutes.foodSearch,
        pageBuilder: (context, state) => const MaterialPage(
          child: FoodSearchPage(),
        ),
      ),

      // Full-screen settings — pushed on the root navigator so it covers the
      // shell and hides the bottom nav (Blueprint: never show the nav on a
      // pushed screen; the back arrow is the sole retreat).
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => const MaterialPage(
          child: SettingsPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(routePath: state.uri.path),
  );
}
