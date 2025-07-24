// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 String get id; String get owner;@SetConverter() Set<String> get sharedWith; String get name;// ignore: invalid_annotation_target
@EventMapLoader() Map<DateTime, List<Event>> get events;
/// Create a copy of Calendar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarCopyWith<Calendar> get copyWith => _$CalendarCopyWithImpl<Calendar>(this as Calendar, _$identity);

  /// Serializes this Calendar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Calendar&&(identical(other.id, id) || other.id == id)&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other.sharedWith, sharedWith)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.events, events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,owner,const DeepCollectionEquality().hash(sharedWith),name,const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'Calendar(id: $id, owner: $owner, sharedWith: $sharedWith, name: $name, events: $events)';
}


}

/// @nodoc
abstract mixin class $CalendarCopyWith<$Res>  {
  factory $CalendarCopyWith(Calendar value, $Res Function(Calendar) _then) = _$CalendarCopyWithImpl;
@useResult
$Res call({
 String id, String owner,@SetConverter() Set<String> sharedWith, String name,@EventMapLoader() Map<DateTime, List<Event>> events
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? owner = null,Object? sharedWith = null,Object? name = null,Object? events = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,sharedWith: null == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as Set<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as Map<DateTime, List<Event>>,
  ));
}

}


/// Adds pattern-matching-related methods to [Calendar].
extension CalendarPatterns on Calendar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Calendar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Calendar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Calendar value)  $default,){
final _that = this;
switch (_that) {
case _Calendar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Calendar value)?  $default,){
final _that = this;
switch (_that) {
case _Calendar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String owner, @SetConverter()  Set<String> sharedWith,  String name, @EventMapLoader()  Map<DateTime, List<Event>> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Calendar() when $default != null:
return $default(_that.id,_that.owner,_that.sharedWith,_that.name,_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String owner, @SetConverter()  Set<String> sharedWith,  String name, @EventMapLoader()  Map<DateTime, List<Event>> events)  $default,) {final _that = this;
switch (_that) {
case _Calendar():
return $default(_that.id,_that.owner,_that.sharedWith,_that.name,_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String owner, @SetConverter()  Set<String> sharedWith,  String name, @EventMapLoader()  Map<DateTime, List<Event>> events)?  $default,) {final _that = this;
switch (_that) {
case _Calendar() when $default != null:
return $default(_that.id,_that.owner,_that.sharedWith,_that.name,_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Calendar implements Calendar {
   _Calendar({required this.id, required this.owner, @SetConverter() final  Set<String> sharedWith = const {}, required this.name, @EventMapLoader() final  Map<DateTime, List<Event>> events = const {}}): _sharedWith = sharedWith,_events = events;
  factory _Calendar.fromJson(Map<String, dynamic> json) => _$CalendarFromJson(json);

@override final  String id;
@override final  String owner;
 final  Set<String> _sharedWith;
@override@JsonKey()@SetConverter() Set<String> get sharedWith {
  if (_sharedWith is EqualUnmodifiableSetView) return _sharedWith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_sharedWith);
}

@override final  String name;
// ignore: invalid_annotation_target
 final  Map<DateTime, List<Event>> _events;
// ignore: invalid_annotation_target
@override@JsonKey()@EventMapLoader() Map<DateTime, List<Event>> get events {
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Calendar&&(identical(other.id, id) || other.id == id)&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other._sharedWith, _sharedWith)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,owner,const DeepCollectionEquality().hash(_sharedWith),name,const DeepCollectionEquality().hash(_events));

@override
String toString() {
  return 'Calendar(id: $id, owner: $owner, sharedWith: $sharedWith, name: $name, events: $events)';
}


}

/// @nodoc
abstract mixin class _$CalendarCopyWith<$Res> implements $CalendarCopyWith<$Res> {
  factory _$CalendarCopyWith(_Calendar value, $Res Function(_Calendar) _then) = __$CalendarCopyWithImpl;
@override @useResult
$Res call({
 String id, String owner,@SetConverter() Set<String> sharedWith, String name,@EventMapLoader() Map<DateTime, List<Event>> events
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? owner = null,Object? sharedWith = null,Object? name = null,Object? events = null,}) {
  return _then(_Calendar(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,sharedWith: null == sharedWith ? _self._sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as Set<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as Map<DateTime, List<Event>>,
  ));
}


}

// dart format on
