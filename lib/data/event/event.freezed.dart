// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {

 String get name; DateTime get time; String get calendarId; List<String>? get atendees;@ColorConverter() Color get color; BoxShape get shape;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.name, name) || other.name == name)&&(identical(other.time, time) || other.time == time)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&const DeepCollectionEquality().equals(other.atendees, atendees)&&(identical(other.color, color) || other.color == color)&&(identical(other.shape, shape) || other.shape == shape));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,time,calendarId,const DeepCollectionEquality().hash(atendees),color,shape);

@override
String toString() {
  return 'Event(name: $name, time: $time, calendarId: $calendarId, atendees: $atendees, color: $color, shape: $shape)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String name, DateTime time, String calendarId, List<String>? atendees,@ColorConverter() Color color, BoxShape shape
});




}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? time = null,Object? calendarId = null,Object? atendees = freezed,Object? color = null,Object? shape = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,atendees: freezed == atendees ? _self.atendees : atendees // ignore: cast_nullable_to_non_nullable
as List<String>?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BoxShape,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Event implements Event {
   _Event({required this.name, required this.time, required this.calendarId, final  List<String>? atendees, @ColorConverter() this.color = Colors.black, this.shape = BoxShape.circle}): _atendees = atendees;
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  String name;
@override final  DateTime time;
@override final  String calendarId;
 final  List<String>? _atendees;
@override List<String>? get atendees {
  final value = _atendees;
  if (value == null) return null;
  if (_atendees is EqualUnmodifiableListView) return _atendees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey()@ColorConverter() final  Color color;
@override@JsonKey() final  BoxShape shape;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.name, name) || other.name == name)&&(identical(other.time, time) || other.time == time)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&const DeepCollectionEquality().equals(other._atendees, _atendees)&&(identical(other.color, color) || other.color == color)&&(identical(other.shape, shape) || other.shape == shape));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,time,calendarId,const DeepCollectionEquality().hash(_atendees),color,shape);

@override
String toString() {
  return 'Event(name: $name, time: $time, calendarId: $calendarId, atendees: $atendees, color: $color, shape: $shape)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 String name, DateTime time, String calendarId, List<String>? atendees,@ColorConverter() Color color, BoxShape shape
});




}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? time = null,Object? calendarId = null,Object? atendees = freezed,Object? color = null,Object? shape = null,}) {
  return _then(_Event(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,atendees: freezed == atendees ? _self._atendees : atendees // ignore: cast_nullable_to_non_nullable
as List<String>?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BoxShape,
  ));
}


}

// dart format on
