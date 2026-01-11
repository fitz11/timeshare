import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/converters/color_converter.dart';

void main() {
  const converter = ColorConverter();

  group('ColorConverter', () {
    test('fromJson converts int to Color', () {
      const blueValue = 0xFF0000FF;
      final color = converter.fromJson(blueValue);
      expect(color.toARGB32(), blueValue);
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
      expect(restoredColor.toARGB32(), originalColor.toARGB32());
    });

    test('handles transparent colors', () {
      const transparentRed = Color(0x80FF0000);
      final json = converter.toJson(transparentRed);
      final restored = converter.fromJson(json);
      expect(restored.a, transparentRed.a);
      expect(restored.r, transparentRed.r);
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
