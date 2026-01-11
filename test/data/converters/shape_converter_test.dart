// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/converters/shape_converter.dart';

void main() {
  const converter = ShapeConverter();

  group('ShapeConverter', () {
    test('fromJson converts "circle" to BoxShape.circle', () {
      final shape = converter.fromJson('circle');
      expect(shape, BoxShape.circle);
    });

    test('fromJson converts "rectangle" to BoxShape.rectangle', () {
      final shape = converter.fromJson('rectangle');
      expect(shape, BoxShape.rectangle);
    });

    test('fromJson converts unknown string to BoxShape.rectangle', () {
      final shape = converter.fromJson('unknown');
      expect(shape, BoxShape.rectangle);
    });

    test('fromJson converts empty string to BoxShape.rectangle', () {
      final shape = converter.fromJson('');
      expect(shape, BoxShape.rectangle);
    });

    test('toJson converts BoxShape.circle to "circle"', () {
      final json = converter.toJson(BoxShape.circle);
      expect(json, 'circle');
    });

    test('toJson converts BoxShape.rectangle to "rectangle"', () {
      final json = converter.toJson(BoxShape.rectangle);
      expect(json, 'rectangle');
    });

    test('roundtrip preserves circle', () {
      const original = BoxShape.circle;
      final json = converter.toJson(original);
      final restored = converter.fromJson(json);
      expect(restored, original);
    });

    test('roundtrip preserves rectangle', () {
      const original = BoxShape.rectangle;
      final json = converter.toJson(original);
      final restored = converter.fromJson(json);
      expect(restored, original);
    });
  });
}
