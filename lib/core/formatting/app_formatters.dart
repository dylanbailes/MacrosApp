// Path: core/formatting/app_formatters.dart

/// Strict data-formatting helpers (UI Polish Spec §5 — Number Formatting).
///
/// All helpers return strings that render well with tabular figures: comma-
/// grouped thousands, at most one decimal for grams, explicit signs on
/// percent deltas, and a consistent 12-hour time.
class AppFormatters {
  AppFormatters._();

  /// Comma-groups an integer: `2050` → `'2,050'`.
  static String comma(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// Whole calories, comma-grouped: `2140` → `'2,140'`.
  static String calories(int value) => comma(value);

  /// Grams with at most one decimal; a trailing `.0` is dropped so whole
  /// grams render as integers: `27` → `'27'`, `31.5` → `'31.5'`,
  /// `31.55` → `'31.6'`.
  static String grams(double value) {
    final rounded = (value * 10).roundToDouble() / 10;
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(1);
  }

  /// Percent delta with an explicit sign: `8.4` → `'+8%'`, `-3` → `'-3%'`,
  /// `0` → `'0%'`.
  static String signedPercent(double value) {
    final rounded = value.round();
    if (rounded > 0) return '+$rounded%';
    if (rounded < 0) return '$rounded%';
    return '0%';
  }

  /// 12-hour time with a two-digit minute: `8:30` → `'8:30 AM'`,
  /// `23:45` → `'11:45 PM'`, `12:00` → `'12:00 PM'`.
  static String timeOfDay(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
