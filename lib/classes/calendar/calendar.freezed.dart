// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Calendar {

 String get name; Map<DateTime, List<Event>> get events;
/// Create a copy of Calendar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarCopyWith<Calendar> get copyWith => _$CalendarCopyWithImpl<Calendar>(this as Calendar, _$identity);

  /// Serializes this Calendar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Calendar&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.events, events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'Calendar(name: $name, events: $events)';
}


}

/// @nodoc
abstract mixin class $CalendarCopyWith<$Res>  {
  factory $CalendarCopyWith(Calendar value, $Res Function(Calendar) _then) = _$CalendarCopyWithImpl;
@useResult
$Res call({
 String name, Map<DateTime, List<Event>> events
});




}
/// @nodoc
class _$CalendarCopyWithImpl<$Res>
    implements $CalendarCopyWith<$Res> {
  _$CalendarCopyWithImpl(this._self, this._then);

  final Calendar _self;
  final $Res Function(Calendar) _then;

/// Create a copy of Calendar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? events = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as Map<DateTime, List<Event>>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Calendar implements Calendar {
   _Calendar({required this.name, required final  Map<DateTime, List<Event>> events}): _events = events;
  factory _Calendar.fromJson(Map<String, dynamic> json) => _$CalendarFromJson(json);

@override final  String name;
 final  Map<DateTime, List<Event>> _events;
@override Map<DateTime, List<Event>> get events {
  if (_events is EqualUnmodifiableMapView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_events);
}


/// Create a copy of Calendar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarCopyWith<_Calendar> get copyWith => __$CalendarCopyWithImpl<_Calendar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Calendar&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_events));

@override
String toString() {
  return 'Calendar(name: $name, events: $events)';
}


}

/// @nodoc
abstract mixin class _$CalendarCopyWith<$Res> implements $CalendarCopyWith<$Res> {
  factory _$CalendarCopyWith(_Calendar value, $Res Function(_Calendar) _then) = __$CalendarCopyWithImpl;
@override @useResult
$Res call({
 String name, Map<DateTime, List<Event>> events
});




}
/// @nodoc
class __$CalendarCopyWithImpl<$Res>
    implements _$CalendarCopyWith<$Res> {
  __$CalendarCopyWithImpl(this._self, this._then);

  final _Calendar _self;
  final $Res Function(_Calendar) _then;

/// Create a copy of Calendar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? events = null,}) {
  return _then(_Calendar(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as Map<DateTime, List<Event>>,
  ));
}


}

// dart format on
