// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get uid; String get email; String get displayName; String? get photoUrl; bool get isAdmin;// ignore: invalid_annotation_target
@JsonKey(fromJson: TimestampConverter.fromTimestamp, toJson: TimestampConverter.toTimestamp) DateTime get joinedAt; List<String> get friends;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&const DeepCollectionEquality().equals(other.friends, friends));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,photoUrl,isAdmin,joinedAt,const DeepCollectionEquality().hash(friends));

@override
String toString() {
  return 'AppUser(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, isAdmin: $isAdmin, joinedAt: $joinedAt, friends: $friends)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String displayName, String? photoUrl, bool isAdmin,@JsonKey(fromJson: TimestampConverter.fromTimestamp, toJson: TimestampConverter.toTimestamp) DateTime joinedAt, List<String> friends
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? photoUrl = freezed,Object? isAdmin = null,Object? joinedAt = null,Object? friends = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,friends: null == friends ? _self.friends : friends // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({required this.uid, required this.email, required this.displayName, this.photoUrl, this.isAdmin = false, @JsonKey(fromJson: TimestampConverter.fromTimestamp, toJson: TimestampConverter.toTimestamp) required this.joinedAt, final  List<String> friends = const []}): _friends = friends;
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String displayName;
@override final  String? photoUrl;
@override@JsonKey() final  bool isAdmin;
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: TimestampConverter.fromTimestamp, toJson: TimestampConverter.toTimestamp) final  DateTime joinedAt;
 final  List<String> _friends;
@override@JsonKey() List<String> get friends {
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friends);
}


/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&const DeepCollectionEquality().equals(other._friends, _friends));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,photoUrl,isAdmin,joinedAt,const DeepCollectionEquality().hash(_friends));

@override
String toString() {
  return 'AppUser(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, isAdmin: $isAdmin, joinedAt: $joinedAt, friends: $friends)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String displayName, String? photoUrl, bool isAdmin,@JsonKey(fromJson: TimestampConverter.fromTimestamp, toJson: TimestampConverter.toTimestamp) DateTime joinedAt, List<String> friends
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? photoUrl = freezed,Object? isAdmin = null,Object? joinedAt = null,Object? friends = null,}) {
  return _then(_AppUser(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
