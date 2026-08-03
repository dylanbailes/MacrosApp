// Guards the typography consolidation (UI Polish Spec §4):
//  1. The unresolved `Inter` font must never be referenced (it isn't bundled).
//  2. The dot-matrix `Nothing` font must only ever be used through
//     AppTextStyles (via the `kNothingFont` constant) — never as a raw
//     `fontFamily: 'Nothing'` string in a widget.
//  3. Every Ndot style in `app_text_styles.dart` must be at the ≥24px
//     legibility floor — below that the dot matrix disintegrates.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final libDir = Directory('lib');
  final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('no unresolved Inter font family anywhere in lib', () {
    for (final file in dartFiles) {
      final content = file.readAsStringSync();
      expect(
        content.contains("fontFamily: 'Inter'"),
        isFalse,
        reason: '${file.path} reintroduced the unresolved Inter font — '
            'use kGeistFont instead',
      );
    }
  });

  test('dot-matrix font is never hardcoded outside AppTextStyles', () {
    for (final file in dartFiles) {
      if (file.path.endsWith('app_text_styles.dart')) continue;
      final content = file.readAsStringSync();
      expect(
        content.contains("fontFamily: 'Nothing'"),
        isFalse,
        reason: '${file.path} hardcodes the Nothing font — '
            'use an AppTextStyles style instead',
      );
    }
  });

  test('every Ndot style in AppTextStyles is at the 24px floor or larger', () {
    final styles =
        File('lib/core/theme/app_text_styles.dart').readAsStringSync();
    // Match kNothingFont paired with a fontSize in EITHER named-arg order
    // (Dart named arguments are order-independent), within the same compact
    // style block.
    final pattern = RegExp(
      r'(kNothingFont[\s\S]{0,140}?fontSize:\s*([\d.]+))'
      r'|(fontSize:\s*([\d.]+)[\s\S]{0,140}?kNothingFont)',
    );
    final matches = pattern.allMatches(styles).toList();
    expect(
      matches,
      isNotEmpty,
      reason: 'expected to find Ndot (kNothingFont) styles to guard',
    );
    for (final match in matches) {
      // Group 2: fontSize after kNothingFont; group 4: fontSize before it.
      final size = double.parse(match.group(2) ?? match.group(4)!);
      expect(
        size >= 24,
        isTrue,
        reason: 'Ndot style at ${size}px is below the 24px legibility floor',
      );
    }
  });
}
