import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:macro_tracker/core/widgets/app_empty_state.dart';
import 'package:macro_tracker/core/widgets/app_list_row.dart';
import 'package:macro_tracker/core/widgets/app_screen_header.dart';
import 'package:macro_tracker/core/widgets/app_section_header.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppScreenHeader', () {
    testWidgets('renders title, subtitle, trailing, and bottom slots',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          AppScreenHeader(
            title: 'Good afternoon',
            subtitle: 'Tuesday, Aug 3',
            trailing: const Icon(Icons.settings_outlined),
            bottom: const Text('date navigator'),
          ),
        ),
      );

      expect(find.text('Good afternoon'), findsOneWidget);
      expect(find.text('Tuesday, Aug 3'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.text('date navigator'), findsOneWidget);
    });
  });

  group('AppEmptyState', () {
    testWidgets('renders icon, title, hint, and CTA', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppEmptyState(
            icon: Icons.search_off_outlined,
            title: 'No results',
            hint: 'Try a different spelling.',
            actionLabel: 'Search foods',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off_outlined), findsOneWidget);
      expect(find.text('No results'), findsOneWidget);
      expect(find.text('Try a different spelling.'), findsOneWidget);

      await tester.tap(find.text('Search foods'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('hides CTA when no action is provided', (tester) async {
      await tester.pumpWidget(
        wrap(AppEmptyState(title: 'Nothing logged yet')),
      );
      expect(find.text('Nothing logged yet'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('supports quiet mode without icon and with a title style',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          AppEmptyState(
            showIcon: false,
            title: 'Nothing logged yet',
            titleStyle: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      );

      expect(find.byType(Icon), findsNothing);
      expect(find.text('Nothing logged yet'), findsOneWidget);
    });
  });

  group('AppListRow', () {
    testWidgets('renders glyph, title, subtitle, trailing, and dots',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          AppListRow(
            title: 'Chicken Breast (cooked)',
            subtitle: '8:30 AM',
            trailing: const AppListRowTrailing(
              value: '330',
              dots: [Color(0xFF3D8BFD)],
            ),
          ),
        ),
      );

      expect(find.text('Chicken Breast (cooked)'), findsOneWidget);
      expect(find.text('8:30 AM'), findsOneWidget);
      expect(find.text('330'), findsOneWidget);
    });

    testWidgets('fires onTap and shows delete button when provided',
        (tester) async {
      var tapped = false;
      var deleted = false;
      await tester.pumpWidget(
        wrap(
          AppListRow(
            title: 'Oats (rolled)',
            onTap: () => tapped = true,
            onDelete: () => deleted = true,
          ),
        ),
      );

      await tester.tap(find.text('Oats (rolled)'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);

      await tester.tap(find.byKey(const Key('delete-log-entry')));
      await tester.pumpAndSettle();
      expect(deleted, isTrue);
    });

    testWidgets('AppSectionHeader renders trailing action', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppSectionHeader(
            label: 'Recent Meals',
            trailing: const Text('View all'),
          ),
        ),
      );

      expect(find.text('RECENT MEALS'), findsOneWidget);
      expect(find.text('View all'), findsOneWidget);
    });
  });
}
