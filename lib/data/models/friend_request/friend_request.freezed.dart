// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendRequest {

 String get id; String get fromUid; String get toUid; FriendRequestStatus get status;@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime get createdAt;@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime get expiresAt;// Denormalized fields for display (populated by backend)
 String? get fromDisplayName; String? get fromEmail; String? get fromPhotoUrl; String? get toDisplayName; String? get toEmail; String? get toPhotoUrl;
/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendRequestCopyWith<FriendRequest> get copyWith => _$FriendRequestCopyWithImpl<FriendRequest>(this as FriendRequest, _$identity);

  /// Serializes this FriendRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUid, fromUid) || other.fromUid == fromUid)&&(identical(other.toUid, toUid) || other.toUid == toUid)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.fromDisplayName, fromDisplayName) || other.fromDisplayName == fromDisplayName)&&(identical(other.fromEmail, fromEmail) || other.fromEmail == fromEmail)&&(identical(other.fromPhotoUrl, fromPhotoUrl) || other.fromPhotoUrl == fromPhotoUrl)&&(identical(other.toDisplayName, toDisplayName) || other.toDisplayName == toDisplayName)&&(identical(other.toEmail, toEmail) || other.toEmail == toEmail)&&(identical(other.toPhotoUrl, toPhotoUrl) || other.toPhotoUrl == toPhotoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUid,toUid,status,createdAt,expiresAt,fromDisplayName,fromEmail,fromPhotoUrl,toDisplayName,toEmail,toPhotoUrl);

@override
String toString() {
  return 'FriendRequest(id: $id, fromUid: $fromUid, toUid: $toUid, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, fromDisplayName: $fromDisplayName, fromEmail: $fromEmail, fromPhotoUrl: $fromPhotoUrl, toDisplayName: $toDisplayName, toEmail: $toEmail, toPhotoUrl: $toPhotoUrl)';
}


}

/// @nodoc
abstract mixin class $FriendRequestCopyWith<$Res>  {
  factory $FriendRequestCopyWith(FriendRequest value, $Res Function(FriendRequest) _then) = _$FriendRequestCopyWithImpl;
@useResult
$Res call({
 String id, String fromUid, String toUid, FriendRequestStatus status,@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime createdAt,@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime expiresAt, String? fromDisplayName, String? fromEmail, String? fromPhotoUrl, String? toDisplayName, String? toEmail, String? toPhotoUrl
});




}
/// @nodoc
class _$FriendRequestCopyWithImpl<$Res>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._self, this._then);

  final FriendRequest _self;
  final $Res Function(FriendRequest) _then;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromUid = null,Object? toUid = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? fromDisplayName = freezed,Object? fromEmail = freezed,Object? fromPhotoUrl = freezed,Object? toDisplayName = freezed,Object? toEmail = freezed,Object? toPhotoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUid: null == fromUid ? _self.fromUid : fromUid // ignore: cast_nullable_to_non_nullable
as String,toUid: null == toUid ? _self.toUid : toUid // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FriendRequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromDisplayName: freezed == fromDisplayName ? _self.fromDisplayName : fromDisplayName // ignore: cast_nullable_to_non_nullable
as String?,fromEmail: freezed == fromEmail ? _self.fromEmail : fromEmail // ignore: cast_nullable_to_non_nullable
as String?,fromPhotoUrl: freezed == fromPhotoUrl ? _self.fromPhotoUrl : fromPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,toDisplayName: freezed == toDisplayName ? _self.toDisplayName : toDisplayName // ignore: cast_nullable_to_non_nullable
as String?,toEmail: freezed == toEmail ? _self.toEmail : toEmail // ignore: cast_nullable_to_non_nullable
as String?,toPhotoUrl: freezed == toPhotoUrl ? _self.toPhotoUrl : toPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendRequest].
extension FriendRequestPatterns on FriendRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendRequest value)  $default,){
final _that = this;
switch (_that) {
case _FriendRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fromUid,  String toUid,  FriendRequestStatus status, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime createdAt, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime expiresAt,  String? fromDisplayName,  String? fromEmail,  String? fromPhotoUrl,  String? toDisplayName,  String? toEmail,  String? toPhotoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that.id,_that.fromUid,_that.toUid,_that.status,_that.createdAt,_that.expiresAt,_that.fromDisplayName,_that.fromEmail,_that.fromPhotoUrl,_that.toDisplayName,_that.toEmail,_that.toPhotoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fromUid,  String toUid,  FriendRequestStatus status, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime createdAt, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime expiresAt,  String? fromDisplayName,  String? fromEmail,  String? fromPhotoUrl,  String? toDisplayName,  String? toEmail,  String? toPhotoUrl)  $default,) {final _that = this;
switch (_that) {
case _FriendRequest():
return $default(_that.id,_that.fromUid,_that.toUid,_that.status,_that.createdAt,_that.expiresAt,_that.fromDisplayName,_that.fromEmail,_that.fromPhotoUrl,_that.toDisplayName,_that.toEmail,_that.toPhotoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fromUid,  String toUid,  FriendRequestStatus status, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime createdAt, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp)  DateTime expiresAt,  String? fromDisplayName,  String? fromEmail,  String? fromPhotoUrl,  String? toDisplayName,  String? toEmail,  String? toPhotoUrl)?  $default,) {final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that.id,_that.fromUid,_that.toUid,_that.status,_that.createdAt,_that.expiresAt,_that.fromDisplayName,_that.fromEmail,_that.fromPhotoUrl,_that.toDisplayName,_that.toEmail,_that.toPhotoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendRequest extends FriendRequest {
  const _FriendRequest({required this.id, required this.fromUid, required this.toUid, this.status = FriendRequestStatus.pending, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) required this.createdAt, @JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) required this.expiresAt, this.fromDisplayName, this.fromEmail, this.fromPhotoUrl, this.toDisplayName, this.toEmail, this.toPhotoUrl}): super._();
  factory _FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);

@override final  String id;
@override final  String fromUid;
@override final  String toUid;
@override@JsonKey() final  FriendRequestStatus status;
@override@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) final  DateTime createdAt;
@override@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) final  DateTime expiresAt;
// Denormalized fields for display (populated by backend)
@override final  String? fromDisplayName;
@override final  String? fromEmail;
@override final  String? fromPhotoUrl;
@override final  String? toDisplayName;
@override final  String? toEmail;
@override final  String? toPhotoUrl;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendRequestCopyWith<_FriendRequest> get copyWith => __$FriendRequestCopyWithImpl<_FriendRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUid, fromUid) || other.fromUid == fromUid)&&(identical(other.toUid, toUid) || other.toUid == toUid)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.fromDisplayName, fromDisplayName) || other.fromDisplayName == fromDisplayName)&&(identical(other.fromEmail, fromEmail) || other.fromEmail == fromEmail)&&(identical(other.fromPhotoUrl, fromPhotoUrl) || other.fromPhotoUrl == fromPhotoUrl)&&(identical(other.toDisplayName, toDisplayName) || other.toDisplayName == toDisplayName)&&(identical(other.toEmail, toEmail) || other.toEmail == toEmail)&&(identical(other.toPhotoUrl, toPhotoUrl) || other.toPhotoUrl == toPhotoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUid,toUid,status,createdAt,expiresAt,fromDisplayName,fromEmail,fromPhotoUrl,toDisplayName,toEmail,toPhotoUrl);

@override
String toString() {
  return 'FriendRequest(id: $id, fromUid: $fromUid, toUid: $toUid, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, fromDisplayName: $fromDisplayName, fromEmail: $fromEmail, fromPhotoUrl: $fromPhotoUrl, toDisplayName: $toDisplayName, toEmail: $toEmail, toPhotoUrl: $toPhotoUrl)';
}


}

/// @nodoc
abstract mixin class _$FriendRequestCopyWith<$Res> implements $FriendRequestCopyWith<$Res> {
  factory _$FriendRequestCopyWith(_FriendRequest value, $Res Function(_FriendRequest) _then) = __$FriendRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromUid, String toUid, FriendRequestStatus status,@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime createdAt,@JsonKey(fromJson: fromTimestamp, toJson: toTimestamp) DateTime expiresAt, String? fromDisplayName, String? fromEmail, String? fromPhotoUrl, String? toDisplayName, String? toEmail, String? toPhotoUrl
});




}
/// @nodoc
class __$FriendRequestCopyWithImpl<$Res>
    implements _$FriendRequestCopyWith<$Res> {
  __$FriendRequestCopyWithImpl(this._self, this._then);

  final _FriendRequest _self;
  final $Res Function(_FriendRequest) _then;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromUid = null,Object? toUid = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? fromDisplayName = freezed,Object? fromEmail = freezed,Object? fromPhotoUrl = freezed,Object? toDisplayName = freezed,Object? toEmail = freezed,Object? toPhotoUrl = freezed,}) {
  return _then(_FriendRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUid: null == fromUid ? _self.fromUid : fromUid // ignore: cast_nullable_to_non_nullable
as String,toUid: null == toUid ? _self.toUid : toUid // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FriendRequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromDisplayName: freezed == fromDisplayName ? _self.fromDisplayName : fromDisplayName // ignore: cast_nullable_to_non_nullable
as String?,fromEmail: freezed == fromEmail ? _self.fromEmail : fromEmail // ignore: cast_nullable_to_non_nullable
as String?,fromPhotoUrl: freezed == fromPhotoUrl ? _self.fromPhotoUrl : fromPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,toDisplayName: freezed == toDisplayName ? _self.toDisplayName : toDisplayName // ignore: cast_nullable_to_non_nullable
as String?,toEmail: freezed == toEmail ? _self.toEmail : toEmail // ignore: cast_nullable_to_non_nullable
as String?,toPhotoUrl: freezed == toPhotoUrl ? _self.toPhotoUrl : toPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
