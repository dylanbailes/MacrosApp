import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:macro_tracker/core/theme/app_theme.dart';
import 'package:macro_tracker/core/widgets/app_list_row.dart';
import 'package:macro_tracker/features/profile/presentation/pages/profile_page.dart';
import 'package:macro_tracker/features/settings/presentation/pages/settings_page.dart';
import 'package:macro_tracker/features/settings/presentation/providers/settings_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Tall viewport so long pages render fully without scrolling.
  void useTallViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<ProviderContainer> pumpApp(WidgetTester tester, Widget home) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.darkTheme, home: home),
      ),
    );
    return container;
  }

  Future<ProviderContainer> pumpRouter(
    WidgetTester tester,
    GoRouter router,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.darkTheme,
          routerConfig: router,
        ),
      ),
    );
    return container;
  }

  group('SettingsPage', () {
    testWidgets('renders the chrome-kit header, groups, and sign out',
        (tester) async {
      useTallViewport(tester);
      await pumpApp(tester, const SettingsPage());

      // Kit header with back affordance.
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Section labels (uppercased by AppSectionHeader).
      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.text('DATA'), findsOneWidget);
      expect(find.text('ABOUT'), findsOneWidget);

      // Setting tiles + real destinations.
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Goals'), findsOneWidget);
      expect(find.text('Units'), findsOneWidget);
      expect(find.text('Metric'), findsOneWidget); // current unit value
      expect(find.text('Meal Reminders'), findsOneWidget);
      expect(find.text('Daily Summary'), findsOneWidget);
      expect(find.text('Export Data'), findsOneWidget);
      expect(find.text('About App'), findsOneWidget);
      expect(find.text('Open Source'), findsOneWidget);

      // Isolated destructive sign-out action.
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('back button pops the pushed settings route', (tester) async {
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('root'))),
          ),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
        ],
      );
      await pumpRouter(tester, router);

      // Fire-and-forget: GoRouter's push Future only resolves once the
      // pushed route is popped.
      unawaited(router.push('/settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      // warnIfMissed: the Icon inside AppButton is not itself a hit-test
      // target; the tap lands on the button's opaque GestureDetector.
      await tester.tap(find.byIcon(Icons.arrow_back), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('root'), findsOneWidget);
    });

    testWidgets('units picker sheet switches the unit system', (tester) async {
      useTallViewport(tester);
      final container = await pumpApp(tester, const SettingsPage());
      expect(find.text('Metric'), findsOneWidget);

      // Open the picker and choose Imperial.
      await tester.tap(find.text('Units'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Imperial'), findsOneWidget);

      await tester.tap(find.text('Imperial'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Sheet closed, tile shows the new value, and state committed.
      expect(find.text('Imperial'), findsOneWidget);
      expect(container.read(settingsProvider).unitSystem, UnitSystem.imperial);
    });

    testWidgets('notification toggle rows flip their switches', (tester) async {
      useTallViewport(tester);
      final container = await pumpApp(tester, const SettingsPage());

      final mealSwitch = find.descendant(
        of: find.ancestor(
          of: find.text('Meal Reminders'),
          matching: find.byType(AppListRow),
        ),
        matching: find.byType(Switch),
      );
      expect(tester.widget<Switch>(mealSwitch).value, isTrue);

      // Tapping the row toggles the switch (whole-row target per blueprint).
      await tester.tap(find.text('Meal Reminders'), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<Switch>(mealSwitch).value, isFalse);
      expect(container.read(settingsProvider).mealReminders, isFalse);

      // The switch itself also toggles directly.
      await tester.tap(mealSwitch, warnIfMissed: false);
      await tester.pump();
      expect(container.read(settingsProvider).mealReminders, isTrue);
    });

    testWidgets('goals editor saves adjusted targets', (tester) async {
      useTallViewport(tester);
      final container = await pumpApp(tester, const SettingsPage());

      await tester.tap(find.text('Goals'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Daily Goals'), findsOneWidget);

      // Bump calories by one step (2200 → 2250) and save.
      await tester.tap(find.byKey(const Key('goal-calories-increase')),
          warnIfMissed: false);
      await tester.pump();
      await tester.tap(find.text('Save goals'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(container.read(settingsProvider).calorieTarget, 2250);
      expect(find.text('Daily Goals'), findsNothing);
    });

    testWidgets('about sheet shows app identity', (tester) async {
      useTallViewport(tester);
      await pumpApp(tester, const SettingsPage());

      await tester.tap(find.text('About App'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Macro Tracker'), findsOneWidget);
      expect(find.textContaining('premium macro and nutrition tracker'),
          findsOneWidget);
    });
  });

  group('ProfilePage', () {
    testWidgets('renders identity, goals card, and settings rows',
        (tester) async {
      useTallViewport(tester);
      await pumpApp(tester, const ProfilePage());

      // Header + gear.
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // Identity block.
      expect(find.text('Your Profile'), findsOneWidget);
      expect(find.text('Manage your account, goals, and preferences'),
          findsOneWidget);

      // Goals Summary card (default shared targets).
      expect(find.text('DAILY GOALS'), findsOneWidget);
      expect(find.text('2,200'), findsOneWidget);
      expect(find.text('kcal'), findsOneWidget);
      expect(find.text('PROTEIN'), findsOneWidget);
      expect(find.text('165 g'), findsOneWidget);
      expect(find.text('CARBS'), findsOneWidget);
      expect(find.text('220 g'), findsOneWidget);
      expect(find.text('FAT'), findsOneWidget);
      expect(find.text('73 g'), findsOneWidget);

      // Settings entry rows.
      expect(find.text('SETTINGS'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Units'), findsOneWidget);
    });

    testWidgets('goals card reflects edited settings targets', (tester) async {
      useTallViewport(tester);
      final container = await pumpApp(tester, const ProfilePage());

      // Change the calorie target through the provider (as the settings
      // goals editor does) and confirm the card re-renders.
      container.read(settingsProvider.notifier).setGoals(
            calorieTarget: 2500,
            proteinTarget: 170,
            carbsTarget: 220,
            fatTarget: 73,
          );
      await tester.pump();
      expect(find.text('2,500'), findsOneWidget);
      expect(find.text('170 g'), findsOneWidget);
    });

    testWidgets('gear opens the full-screen settings route', (tester) async {
      useTallViewport(tester);
      final router = GoRouter(
        initialLocation: '/profile',
        routes: [
          GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
        ],
      );
      await pumpRouter(tester, router);
      await tester.pumpAndSettle();

      expect(find.text('Your Profile'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.settings_outlined),
          warnIfMissed: false);
      await tester.pumpAndSettle();

      // Settings screen is now on top with its back affordance.
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
