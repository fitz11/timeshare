// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/converters/color_converter.dart';

void main() {
  const converter = ColorConverter();

  group('ColorConverter', () {
    test('fromJson converts int to Color', () {
      const blueValue = 0xFF0000FF;
      final color = converter.fromJson(blueValue);
      expect(color.value, blueValue);
    });

    test('toJson converts Color to int', () {
      const color = Colors.red;
      final intValue = converter.toJson(color);
      expect(intValue, color.toARGB32());
    });

    test('roundtrip preserves color', () {
      const originalColor = Colors.green;
      final json = converter.toJson(originalColor);
      final restoredColor = converter.fromJson(json);
      expect(restoredColor.value, originalColor.value);
    });

    test('handles transparent colors', () {
      const transparentRed = Color(0x80FF0000);
      final json = converter.toJson(transparentRed);
      final restored = converter.fromJson(json);
      expect(restored.alpha, transparentRed.alpha);
      expect(restored.red, transparentRed.red);
    });

    test('handles black color', () {
      const black = Colors.black;
      final json = converter.toJson(black);
      final restored = converter.fromJson(json);
      expect(restored, black);
    });

    test('handles white color', () {
      const white = Colors.white;
      final json = converter.toJson(white);
      final restored = converter.fromJson(json);
      expect(restored, white);
    });
  });
}
