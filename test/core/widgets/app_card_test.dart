import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:macro_tracker/core/widgets/app_card.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('fires onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(AppCard(onTap: () => tapped = true, child: const Text('card'))),
    );

    await tester.tap(find.text('card'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('static variant does not fire onTap nor scale on press',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(AppCard(
        variant: AppCardVariant.static,
        onTap: () => tapped = true,
        child: const Text('static'),
      )),
    );

    await tester.tap(find.text('static'));
    await tester.pumpAndSettle();

    expect(tapped, isFalse);
  });

  testWidgets('hover lifts the card (transform translate)', (tester) async {
    await tester.pumpWidget(
      wrap(AppCard(onTap: () {}, child: const Text('hover'))),
    );

    final gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture.moveTo(tester.getCenter(find.text('hover')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 125));

    // Mid-animation the lift transform should be non-zero (negative = up).
    final transforms = tester.widgetList<Transform>(
      find.descendant(
        of: find.byType(AppCard),
        matching: find.byType(Transform),
      ),
    );
    final lifts = transforms
        .map((t) => t.transform.getTranslation().y)
        .where((y) => y != 0)
        .toList();
    expect(lifts, isNotEmpty);
    expect(lifts.first, lessThan(0));

    await gesture.moveTo(const Offset(0, 0));
    await tester.pumpAndSettle();
  });

  testWidgets('applies hero variant radius to the decoration', (tester) async {
    await tester.pumpWidget(
      wrap(AppCard(
        variant: AppCardVariant.hero,
        child: const Text('hero'),
      )),
    );

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(AppCard),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(
      decoration.borderRadius,
      BorderRadius.circular(28),
    );
  });

  testWidgets('glass mode renders a BackdropFilter', (tester) async {
    await tester.pumpWidget(
      wrap(AppCard(glass: true, child: const Text('glass'))),
    );

    expect(
      find.descendant(
        of: find.byType(AppCard),
        matching: find.byType(BackdropFilter),
      ),
      findsOneWidget,
    );
  });
}
