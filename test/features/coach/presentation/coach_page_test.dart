import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:macro_tracker/core/theme/app_theme.dart';
import 'package:macro_tracker/core/widgets/app_button.dart';
import 'package:macro_tracker/core/widgets/app_skeleton.dart';
import 'package:macro_tracker/core/widgets/app_text_field.dart';
import 'package:macro_tracker/features/coach/presentation/pages/coach_page.dart';
import 'package:macro_tracker/features/coach/presentation/providers/coach_providers.dart';
import 'package:macro_tracker/features/coach/presentation/widgets/coach_composer.dart';
import 'package:macro_tracker/features/coach/presentation/widgets/message_bubble.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpCoach(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const CoachPage(),
        ),
      ),
    );
    return container;
  }

  /// Pushes the CoachPage over a host page so back-navigation can be tested.
  Future<ProviderContainer> pumpCoachPushed(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.darkTheme,
          routerConfig: GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => Builder(
                  builder: (context) => Scaffold(
                    body: Center(
                      child: TextButton(
                        onPressed: () => context.push('/coach'),
                        child: const Text('open coach'),
                      ),
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: '/coach',
                builder: (_, __) => const CoachPage(),
              ),
            ],
          ),
        ),
      ),
    );
    return container;
  }

  /// The number of [MessageBubble]s currently rendered.
  int bubbleCount(WidgetTester tester) =>
      tester.widgetList(find.byType(MessageBubble)).length;

  group('CoachPage', () {
    testWidgets('renders header, insight card, welcome bubble, and composer',
        (tester) async {
      await pumpCoach(tester);

      expect(find.text('Coach'), findsOneWidget);
      expect(find.byKey(const Key('coach-back')), findsOneWidget);

      // Insight card shows the full shared insight + refresh action.
      expect(find.text("TODAY'S INSIGHT"), findsOneWidget);
      expect(find.text(defaultCoachInsight), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Seeded welcome message renders as a left-aligned coach bubble.
      expect(bubbleCount(tester), 1);
      expect(find.byType(CoachComposer), findsOneWidget);
      expect(find.byKey(const Key('coach-send')), findsOneWidget);
      expect(find.byKey(const Key('coach-composer-field')), findsOneWidget);
    });

    testWidgets('send button is disabled while the input is empty',
        (tester) async {
      await pumpCoach(tester);

      // The send key is on the AppButton itself — read it directly. With no
      // text the button's onPressed is null, which AppButton treats as
      // effectively disabled.
      final sendButton = tester.widget<AppButton>(
        find.byKey(const Key('coach-send')),
      );
      expect(find.text(defaultCoachInsight), findsOneWidget);
      expect(sendButton.onPressed, isNull);
    });

    testWidgets('sending a message appends a user bubble and a coach reply',
        (tester) async {
      await pumpCoach(tester);
      final before = bubbleCount(tester);

      await tester.enterText(
        find.byKey(const Key('coach-composer-field')),
        'How much protein do I need?',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('coach-send')));
      await tester.pump();

      // User message appended immediately; coach is "typing".
      expect(bubbleCount(tester), before + 1);
      expect(find.text('How much protein do I need?'), findsOneWidget);

      // Typing indicator appears while the reply is composing.
      expect(find.byType(AppSkeleton), findsWidgets);

      // Fire the reply timer and let the new bubble build.
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
      expect(bubbleCount(tester), before + 2);

      // The canned protein reply is present and the input cleared.
      expect(find.textContaining('165g target'), findsOneWidget);
      expect(
        tester
            .widget<AppTextField>(
              find.byKey(const Key('coach-composer-field')),
            )
            .controller!
            .text,
        isEmpty,
      );
    });

    testWidgets('back button pops the pushed coach page', (tester) async {
      await pumpCoachPushed(tester);

      await tester.tap(find.text('open coach'));
      await tester.pumpAndSettle();
      expect(find.text('Coach'), findsOneWidget);

      await tester.tap(find.byKey(const Key('coach-back')));
      await tester.pumpAndSettle();

      expect(find.text('Coach'), findsNothing);
      expect(find.text('open coach'), findsOneWidget);
    });

    testWidgets('refresh cycles to the next insight', (tester) async {
      await pumpCoach(tester);

      expect(find.text(defaultCoachInsight), findsOneWidget);
      await tester.tap(find.byKey(const Key('coach-refresh')));
      await tester.pump();

      // The first insight is cycled out in favor of the next in the pool.
      expect(find.text(defaultCoachInsight), findsNothing);
      expect(find.textContaining('calorie target 4 of the last 7 days'),
          findsOneWidget);
    });
  });
}
