import 'package:freezed_annotation/freezed_annotation.dart';

class SetConverter implements JsonConverter<Set<String>, List<dynamic>> {
  const SetConverter();

  @override
  Set<String> fromJson(dynamic json) {
    if (json is List) {
      return json.map((e) => e as String).toSet();
    }
    return {};
  }

  @override
  List<String> toJson(Set<String> set) => set.toList();
}
