// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ownership_transfer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnershipTransferRequest {

 String get id;@JsonKey(name: 'calendar') String get calendarId; String get calendarName;@JsonKey(name: 'fromUser') String get fromUid;@JsonKey(name: 'toUser') String get toUid; TransferStatus get status;@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime get createdAt;// Denormalized fields for display (populated by backend)
 String? get fromDisplayName; String? get fromEmail; String? get toDisplayName; String? get toEmail;
/// Create a copy of OwnershipTransferRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnershipTransferRequestCopyWith<OwnershipTransferRequest> get copyWith => _$OwnershipTransferRequestCopyWithImpl<OwnershipTransferRequest>(this as OwnershipTransferRequest, _$identity);

  /// Serializes this OwnershipTransferRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnershipTransferRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.calendarName, calendarName) || other.calendarName == calendarName)&&(identical(other.fromUid, fromUid) || other.fromUid == fromUid)&&(identical(other.toUid, toUid) || other.toUid == toUid)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fromDisplayName, fromDisplayName) || other.fromDisplayName == fromDisplayName)&&(identical(other.fromEmail, fromEmail) || other.fromEmail == fromEmail)&&(identical(other.toDisplayName, toDisplayName) || other.toDisplayName == toDisplayName)&&(identical(other.toEmail, toEmail) || other.toEmail == toEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,calendarId,calendarName,fromUid,toUid,status,createdAt,fromDisplayName,fromEmail,toDisplayName,toEmail);

@override
String toString() {
  return 'OwnershipTransferRequest(id: $id, calendarId: $calendarId, calendarName: $calendarName, fromUid: $fromUid, toUid: $toUid, status: $status, createdAt: $createdAt, fromDisplayName: $fromDisplayName, fromEmail: $fromEmail, toDisplayName: $toDisplayName, toEmail: $toEmail)';
}


}

/// @nodoc
abstract mixin class $OwnershipTransferRequestCopyWith<$Res>  {
  factory $OwnershipTransferRequestCopyWith(OwnershipTransferRequest value, $Res Function(OwnershipTransferRequest) _then) = _$OwnershipTransferRequestCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'calendar') String calendarId, String calendarName,@JsonKey(name: 'fromUser') String fromUid,@JsonKey(name: 'toUser') String toUid, TransferStatus status,@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime createdAt, String? fromDisplayName, String? fromEmail, String? toDisplayName, String? toEmail
});




}
/// @nodoc
class _$OwnershipTransferRequestCopyWithImpl<$Res>
    implements $OwnershipTransferRequestCopyWith<$Res> {
  _$OwnershipTransferRequestCopyWithImpl(this._self, this._then);

  final OwnershipTransferRequest _self;
  final $Res Function(OwnershipTransferRequest) _then;

/// Create a copy of OwnershipTransferRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? calendarId = null,Object? calendarName = null,Object? fromUid = null,Object? toUid = null,Object? status = null,Object? createdAt = null,Object? fromDisplayName = freezed,Object? fromEmail = freezed,Object? toDisplayName = freezed,Object? toEmail = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,calendarName: null == calendarName ? _self.calendarName : calendarName // ignore: cast_nullable_to_non_nullable
as String,fromUid: null == fromUid ? _self.fromUid : fromUid // ignore: cast_nullable_to_non_nullable
as String,toUid: null == toUid ? _self.toUid : toUid // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromDisplayName: freezed == fromDisplayName ? _self.fromDisplayName : fromDisplayName // ignore: cast_nullable_to_non_nullable
as String?,fromEmail: freezed == fromEmail ? _self.fromEmail : fromEmail // ignore: cast_nullable_to_non_nullable
as String?,toDisplayName: freezed == toDisplayName ? _self.toDisplayName : toDisplayName // ignore: cast_nullable_to_non_nullable
as String?,toEmail: freezed == toEmail ? _self.toEmail : toEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnershipTransferRequest].
extension OwnershipTransferRequestPatterns on OwnershipTransferRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnershipTransferRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnershipTransferRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnershipTransferRequest value)  $default,){
final _that = this;
switch (_that) {
case _OwnershipTransferRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnershipTransferRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OwnershipTransferRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'calendar')  String calendarId,  String calendarName, @JsonKey(name: 'fromUser')  String fromUid, @JsonKey(name: 'toUser')  String toUid,  TransferStatus status, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime createdAt,  String? fromDisplayName,  String? fromEmail,  String? toDisplayName,  String? toEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnershipTransferRequest() when $default != null:
return $default(_that.id,_that.calendarId,_that.calendarName,_that.fromUid,_that.toUid,_that.status,_that.createdAt,_that.fromDisplayName,_that.fromEmail,_that.toDisplayName,_that.toEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'calendar')  String calendarId,  String calendarName, @JsonKey(name: 'fromUser')  String fromUid, @JsonKey(name: 'toUser')  String toUid,  TransferStatus status, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime createdAt,  String? fromDisplayName,  String? fromEmail,  String? toDisplayName,  String? toEmail)  $default,) {final _that = this;
switch (_that) {
case _OwnershipTransferRequest():
return $default(_that.id,_that.calendarId,_that.calendarName,_that.fromUid,_that.toUid,_that.status,_that.createdAt,_that.fromDisplayName,_that.fromEmail,_that.toDisplayName,_that.toEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'calendar')  String calendarId,  String calendarName, @JsonKey(name: 'fromUser')  String fromUid, @JsonKey(name: 'toUser')  String toUid,  TransferStatus status, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime createdAt,  String? fromDisplayName,  String? fromEmail,  String? toDisplayName,  String? toEmail)?  $default,) {final _that = this;
switch (_that) {
case _OwnershipTransferRequest() when $default != null:
return $default(_that.id,_that.calendarId,_that.calendarName,_that.fromUid,_that.toUid,_that.status,_that.createdAt,_that.fromDisplayName,_that.fromEmail,_that.toDisplayName,_that.toEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnershipTransferRequest extends OwnershipTransferRequest {
  const _OwnershipTransferRequest({required this.id, @JsonKey(name: 'calendar') required this.calendarId, required this.calendarName, @JsonKey(name: 'fromUser') required this.fromUid, @JsonKey(name: 'toUser') required this.toUid, this.status = TransferStatus.pending, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) required this.createdAt, this.fromDisplayName, this.fromEmail, this.toDisplayName, this.toEmail}): super._();
  factory _OwnershipTransferRequest.fromJson(Map<String, dynamic> json) => _$OwnershipTransferRequestFromJson(json);

@override final  String id;
@override@JsonKey(name: 'calendar') final  String calendarId;
@override final  String calendarName;
@override@JsonKey(name: 'fromUser') final  String fromUid;
@override@JsonKey(name: 'toUser') final  String toUid;
@override@JsonKey() final  TransferStatus status;
@override@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) final  DateTime createdAt;
// Denormalized fields for display (populated by backend)
@override final  String? fromDisplayName;
@override final  String? fromEmail;
@override final  String? toDisplayName;
@override final  String? toEmail;

/// Create a copy of OwnershipTransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnershipTransferRequestCopyWith<_OwnershipTransferRequest> get copyWith => __$OwnershipTransferRequestCopyWithImpl<_OwnershipTransferRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnershipTransferRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnershipTransferRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.calendarName, calendarName) || other.calendarName == calendarName)&&(identical(other.fromUid, fromUid) || other.fromUid == fromUid)&&(identical(other.toUid, toUid) || other.toUid == toUid)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fromDisplayName, fromDisplayName) || other.fromDisplayName == fromDisplayName)&&(identical(other.fromEmail, fromEmail) || other.fromEmail == fromEmail)&&(identical(other.toDisplayName, toDisplayName) || other.toDisplayName == toDisplayName)&&(identical(other.toEmail, toEmail) || other.toEmail == toEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,calendarId,calendarName,fromUid,toUid,status,createdAt,fromDisplayName,fromEmail,toDisplayName,toEmail);

@override
String toString() {
  return 'OwnershipTransferRequest(id: $id, calendarId: $calendarId, calendarName: $calendarName, fromUid: $fromUid, toUid: $toUid, status: $status, createdAt: $createdAt, fromDisplayName: $fromDisplayName, fromEmail: $fromEmail, toDisplayName: $toDisplayName, toEmail: $toEmail)';
}


}

/// @nodoc
abstract mixin class _$OwnershipTransferRequestCopyWith<$Res> implements $OwnershipTransferRequestCopyWith<$Res> {
  factory _$OwnershipTransferRequestCopyWith(_OwnershipTransferRequest value, $Res Function(_OwnershipTransferRequest) _then) = __$OwnershipTransferRequestCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'calendar') String calendarId, String calendarName,@JsonKey(name: 'fromUser') String fromUid,@JsonKey(name: 'toUser') String toUid, TransferStatus status,@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime createdAt, String? fromDisplayName, String? fromEmail, String? toDisplayName, String? toEmail
});




}
/// @nodoc
class __$OwnershipTransferRequestCopyWithImpl<$Res>
    implements _$OwnershipTransferRequestCopyWith<$Res> {
  __$OwnershipTransferRequestCopyWithImpl(this._self, this._then);

  final _OwnershipTransferRequest _self;
  final $Res Function(_OwnershipTransferRequest) _then;

/// Create a copy of OwnershipTransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? calendarId = null,Object? calendarName = null,Object? fromUid = null,Object? toUid = null,Object? status = null,Object? createdAt = null,Object? fromDisplayName = freezed,Object? fromEmail = freezed,Object? toDisplayName = freezed,Object? toEmail = freezed,}) {
  return _then(_OwnershipTransferRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,calendarName: null == calendarName ? _self.calendarName : calendarName // ignore: cast_nullable_to_non_nullable
as String,fromUid: null == fromUid ? _self.fromUid : fromUid // ignore: cast_nullable_to_non_nullable
as String,toUid: null == toUid ? _self.toUid : toUid // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromDisplayName: freezed == fromDisplayName ? _self.fromDisplayName : fromDisplayName // ignore: cast_nullable_to_non_nullable
as String?,fromEmail: freezed == fromEmail ? _self.fromEmail : fromEmail // ignore: cast_nullable_to_non_nullable
as String?,toDisplayName: freezed == toDisplayName ? _self.toDisplayName : toDisplayName // ignore: cast_nullable_to_non_nullable
as String?,toEmail: freezed == toEmail ? _self.toEmail : toEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
