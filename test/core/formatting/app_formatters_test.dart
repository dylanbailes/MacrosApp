import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/core/formatting/app_formatters.dart';

void main() {
  group('AppFormatters.comma', () {
    test('groups thousands with commas', () {
      expect(AppFormatters.comma(0), '0');
      expect(AppFormatters.comma(9), '9');
      expect(AppFormatters.comma(999), '999');
      expect(AppFormatters.comma(1000), '1,000');
      expect(AppFormatters.comma(2050), '2,050');
      expect(AppFormatters.comma(1234567), '1,234,567');
    });
  });

  group('AppFormatters.calories', () {
    test('comma-groups whole calorie totals', () {
      expect(AppFormatters.calories(165), '165');
      expect(AppFormatters.calories(2140), '2,140');
      expect(AppFormatters.calories(0), '0');
    });
  });

  group('AppFormatters.grams', () {
    test('drops trailing .0 so whole grams render as integers', () {
      expect(AppFormatters.grams(27), '27');
      expect(AppFormatters.grams(27.0), '27');
      expect(AppFormatters.grams(0), '0');
      expect(AppFormatters.grams(100.0), '100');
    });

    test('caps decimals at one place', () {
      expect(AppFormatters.grams(31.5), '31.5');
      expect(AppFormatters.grams(2.4), '2.4');
      expect(AppFormatters.grams(31.55), '31.6');
      expect(AppFormatters.grams(0.04), '0');
    });
  });

  group('AppFormatters.signedPercent', () {
    test('shows explicit sign on deltas', () {
      expect(AppFormatters.signedPercent(8.4), '+8%');
      expect(AppFormatters.signedPercent(100), '+100%');
      expect(AppFormatters.signedPercent(-3.2), '-3%');
      expect(AppFormatters.signedPercent(0), '0%');
      expect(AppFormatters.signedPercent(0.4), '0%');
    });
  });

  group('AppFormatters.timeOfDay', () {
    test('formats 12-hour time with minutes and period', () {
      expect(AppFormatters.timeOfDay(DateTime(2026, 8, 3, 8, 30)), '8:30 AM');
      expect(AppFormatters.timeOfDay(DateTime(2026, 8, 3, 14, 5)), '2:05 PM');
      expect(AppFormatters.timeOfDay(DateTime(2026, 8, 3, 0, 5)), '12:05 AM');
      expect(AppFormatters.timeOfDay(DateTime(2026, 8, 3, 12, 0)), '12:00 PM');
      expect(AppFormatters.timeOfDay(DateTime(2026, 8, 3, 23, 45)), '11:45 PM');
    });
  });
}
