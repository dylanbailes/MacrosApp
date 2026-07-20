// Path: app\macro_tracker_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/router/app_router.dart';
import '../core/theme/app_theme.dart';

/// Main application widget.
/// 
/// This is the root of the application tree and sets up:
/// - Riverpod ProviderScope for state management
/// - Material app with custom theme
/// - GoRouter for navigation
class MacroTrackerApp extends ConsumerWidget {
  const MacroTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'Macro Tracker',
        debugShowCheckedModeBanner: false,
        
        // Theme Configuration - Dark mode only
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        
        // Router Configuration
        routerConfig: AppRouter.router,
        
        // Builder for global overlays (if needed in future)
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0), // Optional: Disable system font scaling
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
