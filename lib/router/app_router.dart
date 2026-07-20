import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/log/presentation/pages/log_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/coach/presentation/pages/coach_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// App-wide router configuration using GoRouter.
///
/// Implements a shell route for the main navigation layout (BottomNav/NavRail)
/// and defines routes for all primary features.
final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomePage(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/log',
            name: 'log',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LogPage(),
            ),
          ),
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalyticsPage(),
            ),
          ),
          GoRoute(
            path: '/coach',
            name: 'coach',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CoachPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
    ],
  );
}
