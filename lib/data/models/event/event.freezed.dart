// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 String get id; String get name; DateTime get time; List<String>? get attendees;@ColorConverter() Color get color;@ShapeConverter() BoxShape get shape; EventRecurrence get recurrence; DateTime? get recurrenceEndDate;// calendarId is populated at runtime from the subcollection path, not stored in backend
@JsonKey(includeToJson: false) String? get calendarId; int get version;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.attendees, attendees)&&(identical(other.color, color) || other.color == color)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.recurrenceEndDate, recurrenceEndDate) || other.recurrenceEndDate == recurrenceEndDate)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,time,const DeepCollectionEquality().hash(attendees),color,shape,recurrence,recurrenceEndDate,calendarId,version);

@override
String toString() {
  return 'Event(id: $id, name: $name, time: $time, attendees: $attendees, color: $color, shape: $shape, recurrence: $recurrence, recurrenceEndDate: $recurrenceEndDate, calendarId: $calendarId, version: $version)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime time, List<String>? attendees,@ColorConverter() Color color,@ShapeConverter() BoxShape shape, EventRecurrence recurrence, DateTime? recurrenceEndDate,@JsonKey(includeToJson: false) String? calendarId, int version
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? time = null,Object? attendees = freezed,Object? color = null,Object? shape = null,Object? recurrence = null,Object? recurrenceEndDate = freezed,Object? calendarId = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,attendees: freezed == attendees ? _self.attendees : attendees // ignore: cast_nullable_to_non_nullable
as List<String>?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BoxShape,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as EventRecurrence,recurrenceEndDate: freezed == recurrenceEndDate ? _self.recurrenceEndDate : recurrenceEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,calendarId: freezed == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime time,  List<String>? attendees, @ColorConverter()  Color color, @ShapeConverter()  BoxShape shape,  EventRecurrence recurrence,  DateTime? recurrenceEndDate, @JsonKey(includeToJson: false)  String? calendarId,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.time,_that.attendees,_that.color,_that.shape,_that.recurrence,_that.recurrenceEndDate,_that.calendarId,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime time,  List<String>? attendees, @ColorConverter()  Color color, @ShapeConverter()  BoxShape shape,  EventRecurrence recurrence,  DateTime? recurrenceEndDate, @JsonKey(includeToJson: false)  String? calendarId,  int version)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.name,_that.time,_that.attendees,_that.color,_that.shape,_that.recurrence,_that.recurrenceEndDate,_that.calendarId,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime time,  List<String>? attendees, @ColorConverter()  Color color, @ShapeConverter()  BoxShape shape,  EventRecurrence recurrence,  DateTime? recurrenceEndDate, @JsonKey(includeToJson: false)  String? calendarId,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.time,_that.attendees,_that.color,_that.shape,_that.recurrence,_that.recurrenceEndDate,_that.calendarId,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Event implements Event {
   _Event({required this.id, required this.name, required this.time, final  List<String>? attendees, @ColorConverter() this.color = Colors.black, @ShapeConverter() this.shape = BoxShape.circle, this.recurrence = EventRecurrence.none, this.recurrenceEndDate, @JsonKey(includeToJson: false) this.calendarId, this.version = 1}): _attendees = attendees;
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime time;
 final  List<String>? _attendees;
@override List<String>? get attendees {
  final value = _attendees;
  if (value == null) return null;
  if (_attendees is EqualUnmodifiableListView) return _attendees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey()@ColorConverter() final  Color color;
@override@JsonKey()@ShapeConverter() final  BoxShape shape;
@override@JsonKey() final  EventRecurrence recurrence;
@override final  DateTime? recurrenceEndDate;
// calendarId is populated at runtime from the subcollection path, not stored in backend
@override@JsonKey(includeToJson: false) final  String? calendarId;
@override@JsonKey() final  int version;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other._attendees, _attendees)&&(identical(other.color, color) || other.color == color)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.recurrenceEndDate, recurrenceEndDate) || other.recurrenceEndDate == recurrenceEndDate)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,time,const DeepCollectionEquality().hash(_attendees),color,shape,recurrence,recurrenceEndDate,calendarId,version);

@override
String toString() {
  return 'Event(id: $id, name: $name, time: $time, attendees: $attendees, color: $color, shape: $shape, recurrence: $recurrence, recurrenceEndDate: $recurrenceEndDate, calendarId: $calendarId, version: $version)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime time, List<String>? attendees,@ColorConverter() Color color,@ShapeConverter() BoxShape shape, EventRecurrence recurrence, DateTime? recurrenceEndDate,@JsonKey(includeToJson: false) String? calendarId, int version
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? time = null,Object? attendees = freezed,Object? color = null,Object? shape = null,Object? recurrence = null,Object? recurrenceEndDate = freezed,Object? calendarId = freezed,Object? version = null,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,attendees: freezed == attendees ? _self._attendees : attendees // ignore: cast_nullable_to_non_nullable
as List<String>?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BoxShape,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as EventRecurrence,recurrenceEndDate: freezed == recurrenceEndDate ? _self.recurrenceEndDate : recurrenceEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,calendarId: freezed == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
