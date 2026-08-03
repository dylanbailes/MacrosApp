import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:macro_tracker/core/widgets/app_bottom_sheet.dart';
import 'package:macro_tracker/core/widgets/app_dialog.dart';

void main() {
  Widget wrap(Widget home) => MaterialApp(home: home);

  group('AppDialog / showAppConfirmDialog', () {
    testWidgets('renders title, message, and action buttons', (tester) async {
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => showAppConfirmDialog(
                  context,
                  title: 'Delete Chicken Breast?',
                  message: 'This removes it from your Lunch log.',
                  confirmLabel: 'Delete',
                  destructive: true,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Chicken Breast?'), findsOneWidget);
      expect(find.text('This removes it from your Lunch log.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('resolves true on confirm', (tester) async {
      bool? result;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () async {
                  result = await showAppConfirmDialog(
                    context,
                    title: 'Delete?',
                    confirmLabel: 'Delete',
                    destructive: true,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('resolves false on cancel', (tester) async {
      bool? result;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () async {
                  result = await showAppConfirmDialog(
                    context,
                    title: 'Delete?',
                    confirmLabel: 'Delete',
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });
  });

  group('AppBottomSheet / showAppBottomSheet', () {
    testWidgets('renders the child with a drag handle', (tester) async {
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => showAppBottomSheet<void>(
                  context,
                  child: const Text('sheet content'),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('sheet content'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBottomSheet),
          matching: find.byType(BackdropFilter),
        ),
        findsNothing, // chrome is a plain surface, not glass
      );
    });

    testWidgets('resolves with the popped value', (tester) async {
      String? result;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () async {
                  result = await showAppBottomSheet<String>(
                    context,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop('chosen'),
                      child: const Text('pick'),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();

      expect(result, 'chosen');
    });

    testWidgets('hides the drag handle when requested', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppBottomSheet(
                showDragHandle: false,
                child: const Text('content'),
              ),
            ),
          ),
        ),
      );

      // Only the 40×4 handle strip is suppressed; content remains.
      expect(find.text('content'), findsOneWidget);
      final handles = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(AppBottomSheet),
          matching: find.byType(Container),
        ),
      );
      expect(
        handles.where((c) {
          final deco = c.decoration;
          return deco is BoxDecoration &&
              deco.borderRadius == BorderRadius.circular(999);
        }),
        isEmpty,
      );
    });
  });
}
