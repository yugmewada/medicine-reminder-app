// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DemoProfile {

 String get firstName; String get lastName; String get email;
/// Create a copy of DemoProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DemoProfileCopyWith<DemoProfile> get copyWith => _$DemoProfileCopyWithImpl<DemoProfile>(this as DemoProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DemoProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DemoProfile&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.email, _this.email) || other.email == _this.email));
}


@override
int get hashCode {
  final _this = this as DemoProfile;
  return Object.hash(runtimeType,_this.firstName,_this.lastName,_this.email);
}

@override
String toString() {
  final _this = this as DemoProfile;
  return 'DemoProfile(firstName: ${_this.firstName}, lastName: ${_this.lastName}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $DemoProfileCopyWith<$Res>  {
  factory $DemoProfileCopyWith(DemoProfile value, $Res Function(DemoProfile) _then) = _$DemoProfileCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String email
});




}
/// @nodoc
class _$DemoProfileCopyWithImpl<$Res>
    implements $DemoProfileCopyWith<$Res> {
  _$DemoProfileCopyWithImpl(this._self, this._then);

  final DemoProfile _self;
  final $Res Function(DemoProfile) _then;

/// Create a copy of DemoProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,}) {
  return _then(DemoProfile(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DemoProfile].
extension DemoProfilePatterns on DemoProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DemoProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DemoProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DemoProfile value)  $default,){
final _that = this;
switch (_that) {
case _DemoProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DemoProfile value)?  $default,){
final _that = this;
switch (_that) {
case _DemoProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DemoProfile() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String email)  $default,) {final _that = this;
switch (_that) {
case _DemoProfile():
return $default(_that.firstName,_that.lastName,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String email)?  $default,) {final _that = this;
switch (_that) {
case _DemoProfile() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email);case _:
  return null;

}
}

}

/// @nodoc


class _DemoProfile extends DemoProfile {
  const _DemoProfile({required this.firstName, required this.lastName, required this.email}): super._();
  

@override final  String firstName;
@override final  String lastName;
@override final  String email;

/// Create a copy of DemoProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemoProfileCopyWith<_DemoProfile> get copyWith => __$DemoProfileCopyWithImpl<_DemoProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoProfile&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,firstName,lastName,email);
}

@override
String toString() {
    return 'DemoProfile(firstName: $firstName, lastName: $lastName, email: $email)';
}


}

/// @nodoc
abstract mixin class _$DemoProfileCopyWith<$Res> implements $DemoProfileCopyWith<$Res> {
  factory _$DemoProfileCopyWith(_DemoProfile value, $Res Function(_DemoProfile) _then) = __$DemoProfileCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String email
});




}
/// @nodoc
class __$DemoProfileCopyWithImpl<$Res>
    implements _$DemoProfileCopyWith<$Res> {
  __$DemoProfileCopyWithImpl(this._self, this._then);

  final _DemoProfile _self;
  final $Res Function(_DemoProfile) _then;

/// Create a copy of DemoProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,}) {
  return _then(_DemoProfile(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SessionState {

 AppStage get stage; DemoProfile? get profile; SignInMethod? get method;/// Kept for the app run so logging out lands on Welcome, not onboarding.
 bool get hasSeenOnboarding;
/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStateCopyWith<SessionState> get copyWith => _$SessionStateCopyWithImpl<SessionState>(this as SessionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.hasSeenOnboarding, _this.hasSeenOnboarding) || other.hasSeenOnboarding == _this.hasSeenOnboarding));
}


@override
int get hashCode {
  final _this = this as SessionState;
  return Object.hash(runtimeType,_this.stage,_this.profile,_this.method,_this.hasSeenOnboarding);
}

@override
String toString() {
  final _this = this as SessionState;
  return 'SessionState(stage: ${_this.stage}, profile: ${_this.profile}, method: ${_this.method}, hasSeenOnboarding: ${_this.hasSeenOnboarding})';
}


}

/// @nodoc
abstract mixin class $SessionStateCopyWith<$Res>  {
  factory $SessionStateCopyWith(SessionState value, $Res Function(SessionState) _then) = _$SessionStateCopyWithImpl;
@useResult
$Res call({
 AppStage stage, DemoProfile? profile, SignInMethod? method, bool hasSeenOnboarding
});


$DemoProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$SessionStateCopyWithImpl<$Res>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._self, this._then);

  final SessionState _self;
  final $Res Function(SessionState) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? profile = freezed,Object? method = freezed,Object? hasSeenOnboarding = null,}) {
  return _then(SessionState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as AppStage,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as DemoProfile?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as SignInMethod?,hasSeenOnboarding: null == hasSeenOnboarding ? _self.hasSeenOnboarding : hasSeenOnboarding // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DemoProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $DemoProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionState value)  $default,){
final _that = this;
switch (_that) {
case _SessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionState value)?  $default,){
final _that = this;
switch (_that) {
case _SessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppStage stage,  DemoProfile? profile,  SignInMethod? method,  bool hasSeenOnboarding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionState() when $default != null:
return $default(_that.stage,_that.profile,_that.method,_that.hasSeenOnboarding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppStage stage,  DemoProfile? profile,  SignInMethod? method,  bool hasSeenOnboarding)  $default,) {final _that = this;
switch (_that) {
case _SessionState():
return $default(_that.stage,_that.profile,_that.method,_that.hasSeenOnboarding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppStage stage,  DemoProfile? profile,  SignInMethod? method,  bool hasSeenOnboarding)?  $default,) {final _that = this;
switch (_that) {
case _SessionState() when $default != null:
return $default(_that.stage,_that.profile,_that.method,_that.hasSeenOnboarding);case _:
  return null;

}
}

}

/// @nodoc


class _SessionState extends SessionState {
  const _SessionState({required this.stage, this.profile, this.method, this.hasSeenOnboarding = false}): super._();
  

@override final  AppStage stage;
@override final  DemoProfile? profile;
@override final  SignInMethod? method;
/// Kept for the app run so logging out lands on Welcome, not onboarding.
@override@JsonKey() final  bool hasSeenOnboarding;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStateCopyWith<_SessionState> get copyWith => __$SessionStateCopyWithImpl<_SessionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.method, method) || other.method == method)&&(identical(other.hasSeenOnboarding, hasSeenOnboarding) || other.hasSeenOnboarding == hasSeenOnboarding));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stage,profile,method,hasSeenOnboarding);
}

@override
String toString() {
    return 'SessionState(stage: $stage, profile: $profile, method: $method, hasSeenOnboarding: $hasSeenOnboarding)';
}


}

/// @nodoc
abstract mixin class _$SessionStateCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$SessionStateCopyWith(_SessionState value, $Res Function(_SessionState) _then) = __$SessionStateCopyWithImpl;
@override @useResult
$Res call({
 AppStage stage, DemoProfile? profile, SignInMethod? method, bool hasSeenOnboarding
});


@override $DemoProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$SessionStateCopyWithImpl<$Res>
    implements _$SessionStateCopyWith<$Res> {
  __$SessionStateCopyWithImpl(this._self, this._then);

  final _SessionState _self;
  final $Res Function(_SessionState) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? profile = freezed,Object? method = freezed,Object? hasSeenOnboarding = null,}) {
  return _then(_SessionState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as AppStage,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as DemoProfile?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as SignInMethod?,hasSeenOnboarding: null == hasSeenOnboarding ? _self.hasSeenOnboarding : hasSeenOnboarding // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DemoProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $DemoProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
