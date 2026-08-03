import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/core/theme/app_theme.dart';
import 'package:macro_tracker/core/widgets/app_segmented_control.dart';
import 'package:macro_tracker/core/widgets/app_stat_display.dart';

enum _Range { week1, month1, month3 }

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  const options = [
    AppSegmentedOption(value: _Range.week1, label: '1W'),
    AppSegmentedOption(value: _Range.month1, label: '1M'),
    AppSegmentedOption(value: _Range.month3, label: '3M'),
  ];

  group('AppSegmentedControl', () {
    testWidgets('renders every option label', (tester) async {
      await tester.pumpWidget(
        wrap(AppSegmentedControl<_Range>(
          options: options,
          value: _Range.month1,
          onChanged: (_) {},
        )),
      );

      expect(find.text('1W'), findsOneWidget);
      expect(find.text('1M'), findsOneWidget);
      expect(find.text('3M'), findsOneWidget);
    });

    testWidgets('tapping an option reports its value', (tester) async {
      _Range? picked;
      await tester.pumpWidget(
        wrap(AppSegmentedControl<_Range>(
          options: options,
          value: _Range.month1,
          onChanged: (value) => picked = value,
        )),
      );

      await tester.tap(find.text('3M'));
      expect(picked, _Range.month3);
    });

    testWidgets('six range tabs do not overflow a narrow screen',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const sixOptions = [
        AppSegmentedOption(value: _Range.week1, label: '1W'),
        AppSegmentedOption(value: _Range.month1, label: '1M'),
        AppSegmentedOption(value: _Range.month3, label: '3M'),
        AppSegmentedOption(value: _Range.week1, label: '6M'),
        AppSegmentedOption(value: _Range.month1, label: '1Y'),
        AppSegmentedOption(value: _Range.month3, label: 'ALL'),
      ];

      await tester.pumpWidget(
        wrap(AppSegmentedControl<_Range>(
          options: sixOptions,
          value: _Range.week1,
          onChanged: (_) {},
        )),
      );

      // The track scrolls instead of overflowing the 320px viewport.
      expect(tester.takeException(), isNull);
    });

    testWidgets('the active pill slides to the selected option',
        (tester) async {
      await tester.pumpWidget(
        wrap(AppSegmentedControl<_Range>(
          options: options,
          value: _Range.week1,
          onChanged: (_) {},
        )),
      );
      final firstPill =
          tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned));

      await tester.pumpWidget(
        wrap(AppSegmentedControl<_Range>(
          options: options,
          value: _Range.month3,
          onChanged: (_) {},
        )),
      );
      final lastPill =
          tester.widget<AnimatedPositioned>(find.byType(AnimatedPositioned));

      // Selecting the last option moves the pill right.
      expect(lastPill.left!, greaterThan(firstPill.left!));
    });
  });

  group('AppStatDisplay', () {
    testWidgets('renders uppercase label, value, and unit suffix',
        (tester) async {
      await tester.pumpWidget(
        wrap(const AppStatDisplay(
          label: 'Avg Calories',
          value: '2,050',
          unit: 'kcal',
        )),
      );

      expect(find.text('AVG CALORIES'), findsOneWidget);
      expect(find.text('2,050'), findsOneWidget);
      expect(find.text('kcal'), findsOneWidget);
    });
  });
}
