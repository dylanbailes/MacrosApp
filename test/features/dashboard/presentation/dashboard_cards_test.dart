import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/core/theme/app_theme.dart';
import 'package:macro_tracker/features/dashboard/presentation/providers/dashboard_state.dart';
import 'package:macro_tracker/features/dashboard/presentation/widgets/metric_carousel.dart';
import 'package:macro_tracker/features/dashboard/presentation/widgets/streak_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pump(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: child),
      ),
    );
  }

  group('StreakCard', () {
    testWidgets('renders current, longest, milestone, and weekly summary',
        (tester) async {
      await pump(
        tester,
        const StreakCard(
          currentStreak: 12,
          longestStreak: 30,
          weeklyGoalDays: [true, true, true, true, false, true, false],
        ),
      );

      expect(find.text('STREAK'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Longest: 30 days'), findsOneWidget);
      // 12 ≥ 7 → milestone badge shows the current-tier label ('Week Warrior');
      // 5/7 days this week.
      expect(find.text('Week Warrior'), findsOneWidget);
      expect(find.text('5/7 days this week'), findsOneWidget);
      // 12 < 14 → progress toward the next milestone (the line names the
      // current tier, 'Week Warrior', per the card's original copy).
      expect(find.text('2 days to Week Warrior'), findsOneWidget);
    });

    testWidgets('no milestone badge below 7 days (progress bar still shows)',
        (tester) async {
      await pump(
        tester,
        const StreakCard(currentStreak: 3, longestStreak: 30),
      );

      // Below 7 days the badge is hidden entirely ('Getting Started' only
      // appears inside the progress line, not as a standalone badge).
      expect(find.text('Getting Started'), findsNothing);
      expect(find.text('Week Warrior'), findsNothing);
      // 3 < 7 → still shows progress toward the first milestone.
      expect(find.text('4 days to Getting Started'), findsOneWidget);
    });

    testWidgets('fires onTap when the card is tapped', (tester) async {
      var tapped = false;
      await pump(
        tester,
        StreakCard(
          currentStreak: 12,
          longestStreak: 30,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(StreakCard));
      expect(tapped, isTrue);
    });
  });

  group('MetricCarousel', () {
    const macros = [
      MacroProgress(
        label: 'Protein',
        consumed: 96,
        target: 165,
        unit: 'g',
        color: 0xFF3D8BFD,
      ),
      MacroProgress(
        label: 'Carbs',
        consumed: 132,
        target: 220,
        unit: 'g',
        color: 0xFFFFB020,
      ),
      MacroProgress(
        label: 'Fat',
        consumed: 41,
        target: 73,
        unit: 'g',
        color: 0xFFFF6B5E,
      ),
    ];

    testWidgets('shows the first macro card with ring % and remaining',
        (tester) async {
      await pump(
        tester,
        const MetricCarousel(
          macros: macros,
          waterConsumed: 1.4,
          waterTarget: 2.5,
        ),
      );

      // First card: Protein (96/165 = 58%), 69g left.
      expect(find.text('PROTEIN'), findsOneWidget);
      expect(find.text('58%'), findsOneWidget);
      expect(find.text('69g left'), findsOneWidget);
      expect(find.text('1/4'), findsOneWidget);
    });

    testWidgets('swiping advances to the water card', (tester) async {
      await pump(
        tester,
        const MetricCarousel(
          macros: macros,
          waterConsumed: 1.4,
          waterTarget: 2.5,
        ),
      );

      // Swipe left 3 times to reach the water card (index 3).
      for (var i = 0; i < 3; i++) {
        await tester.drag(
          find.byType(PageView),
          const Offset(-600, 0),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();
      }

      expect(find.text('WATER'), findsOneWidget);
      expect(find.text('4/4'), findsOneWidget);
    });

    testWidgets('water card shows 56% and over/under status', (tester) async {
      await pump(
        tester,
        const MetricCarousel(
          macros: macros,
          waterConsumed: 1.4,
          waterTarget: 2.5,
        ),
      );

      for (var i = 0; i < 3; i++) {
        await tester.drag(
          find.byType(PageView),
          const Offset(-600, 0),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();
      }

      // 1.4 / 2.5 = 56%; remaining renders whole-number (1L left).
      expect(find.text('56%'), findsOneWidget);
      expect(find.text('1L left'), findsOneWidget);
    });
  });
}
