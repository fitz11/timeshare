import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeshare/data/converters/set_converter.dart';

part 'calendar.freezed.dart';
part 'calendar.g.dart';

@freezed
abstract class Calendar with _$Calendar {
  factory Calendar({
    required String id,
    required String owner,
    @SetConverter() @Default({}) Set<String> sharedWith,
    required String name,
  }) = _Calendar;

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);

  /// Helper function to generate DateTimes over a range.
  /// Useful for expanding recurring events.
  static List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}
