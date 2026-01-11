import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/data/converters/set_converter.dart';

void main() {
  const converter = SetConverter();

  group('SetConverter', () {
    test('fromJson converts List to Set', () {
      final list = ['a', 'b', 'c'];
      final set = converter.fromJson(list);
      expect(set, {'a', 'b', 'c'});
    });

    test('fromJson handles empty list', () {
      final list = <String>[];
      final set = converter.fromJson(list);
      expect(set, <String>{});
    });

    test('fromJson removes duplicates', () {
      final list = ['a', 'b', 'a', 'c', 'b'];
      final set = converter.fromJson(list);
      expect(set, {'a', 'b', 'c'});
      expect(set.length, 3);
    });

    test('fromJson handles non-list input by returning empty set', () {
      final set = converter.fromJson(null);
      expect(set, <String>{});
    });

    test('toJson converts Set to List', () {
      final set = {'x', 'y', 'z'};
      final list = converter.toJson(set);
      expect(list.toSet(), {'x', 'y', 'z'});
    });

    test('toJson handles empty set', () {
      final set = <String>{};
      final list = converter.toJson(set);
      expect(list, <String>[]);
    });

    test('roundtrip preserves set', () {
      final original = {'user1', 'user2', 'user3'};
      final json = converter.toJson(original);
      final restored = converter.fromJson(json);
      expect(restored, original);
    });

    test('fromJson handles dynamic list with strings', () {
      final dynamicList = <dynamic>['item1', 'item2'];
      final set = converter.fromJson(dynamicList);
      expect(set, {'item1', 'item2'});
    });
  });
}
