// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dose_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoseOccasion {

 Medicine get medicine; DateTime get date; ScheduleTime get time;
/// Create a copy of DoseOccasion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseOccasionCopyWith<DoseOccasion> get copyWith => _$DoseOccasionCopyWithImpl<DoseOccasion>(this as DoseOccasion, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DoseOccasion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseOccasion&&(identical(other.medicine, _this.medicine) || other.medicine == _this.medicine)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.time, _this.time) || other.time == _this.time));
}


@override
int get hashCode {
  final _this = this as DoseOccasion;
  return Object.hash(runtimeType,_this.medicine,_this.date,_this.time);
}

@override
String toString() {
  final _this = this as DoseOccasion;
  return 'DoseOccasion(medicine: ${_this.medicine}, date: ${_this.date}, time: ${_this.time})';
}


}

/// @nodoc
abstract mixin class $DoseOccasionCopyWith<$Res>  {
  factory $DoseOccasionCopyWith(DoseOccasion value, $Res Function(DoseOccasion) _then) = _$DoseOccasionCopyWithImpl;
@useResult
$Res call({
 Medicine medicine, DateTime date, ScheduleTime time
});


$MedicineCopyWith<$Res> get medicine;$ScheduleTimeCopyWith<$Res> get time;

}
/// @nodoc
class _$DoseOccasionCopyWithImpl<$Res>
    implements $DoseOccasionCopyWith<$Res> {
  _$DoseOccasionCopyWithImpl(this._self, this._then);

  final DoseOccasion _self;
  final $Res Function(DoseOccasion) _then;

/// Create a copy of DoseOccasion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicine = null,Object? date = null,Object? time = null,}) {
  return _then(DoseOccasion(
medicine: null == medicine ? _self.medicine : medicine // ignore: cast_nullable_to_non_nullable
as Medicine,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as ScheduleTime,
  ));
}
/// Create a copy of DoseOccasion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCopyWith<$Res> get medicine {
  
  return $MedicineCopyWith<$Res>(_self.medicine, (value) {
    return _then(_self.copyWith(medicine: value));
  });
}/// Create a copy of DoseOccasion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleTimeCopyWith<$Res> get time {
  
  return $ScheduleTimeCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}
}


/// Adds pattern-matching-related methods to [DoseOccasion].
extension DoseOccasionPatterns on DoseOccasion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoseOccasion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoseOccasion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoseOccasion value)  $default,){
final _that = this;
switch (_that) {
case _DoseOccasion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoseOccasion value)?  $default,){
final _that = this;
switch (_that) {
case _DoseOccasion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Medicine medicine,  DateTime date,  ScheduleTime time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoseOccasion() when $default != null:
return $default(_that.medicine,_that.date,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Medicine medicine,  DateTime date,  ScheduleTime time)  $default,) {final _that = this;
switch (_that) {
case _DoseOccasion():
return $default(_that.medicine,_that.date,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Medicine medicine,  DateTime date,  ScheduleTime time)?  $default,) {final _that = this;
switch (_that) {
case _DoseOccasion() when $default != null:
return $default(_that.medicine,_that.date,_that.time);case _:
  return null;

}
}

}

/// @nodoc


class _DoseOccasion extends DoseOccasion {
  const _DoseOccasion({required this.medicine, required this.date, required this.time}): super._();
  

@override final  Medicine medicine;
@override final  DateTime date;
@override final  ScheduleTime time;

/// Create a copy of DoseOccasion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoseOccasionCopyWith<_DoseOccasion> get copyWith => __$DoseOccasionCopyWithImpl<_DoseOccasion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoseOccasion&&(identical(other.medicine, medicine) || other.medicine == medicine)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode {
    return Object.hash(runtimeType,medicine,date,time);
}

@override
String toString() {
    return 'DoseOccasion(medicine: $medicine, date: $date, time: $time)';
}


}

/// @nodoc
abstract mixin class _$DoseOccasionCopyWith<$Res> implements $DoseOccasionCopyWith<$Res> {
  factory _$DoseOccasionCopyWith(_DoseOccasion value, $Res Function(_DoseOccasion) _then) = __$DoseOccasionCopyWithImpl;
@override @useResult
$Res call({
 Medicine medicine, DateTime date, ScheduleTime time
});


@override $MedicineCopyWith<$Res> get medicine;@override $ScheduleTimeCopyWith<$Res> get time;

}
/// @nodoc
class __$DoseOccasionCopyWithImpl<$Res>
    implements _$DoseOccasionCopyWith<$Res> {
  __$DoseOccasionCopyWithImpl(this._self, this._then);

  final _DoseOccasion _self;
  final $Res Function(_DoseOccasion) _then;

/// Create a copy of DoseOccasion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicine = null,Object? date = null,Object? time = null,}) {
  return _then(_DoseOccasion(
medicine: null == medicine ? _self.medicine : medicine // ignore: cast_nullable_to_non_nullable
as Medicine,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as ScheduleTime,
  ));
}

/// Create a copy of DoseOccasion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCopyWith<$Res> get medicine {
  
  return $MedicineCopyWith<$Res>(_self.medicine, (value) {
    return _then(_self.copyWith(medicine: value));
  });
}/// Create a copy of DoseOccasion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleTimeCopyWith<$Res> get time {
  
  return $ScheduleTimeCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}
}

/// @nodoc
mixin _$DayProgress {

 int get taken; int get skipped; int get total;
/// Create a copy of DayProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayProgressCopyWith<DayProgress> get copyWith => _$DayProgressCopyWithImpl<DayProgress>(this as DayProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DayProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayProgress&&(identical(other.taken, _this.taken) || other.taken == _this.taken)&&(identical(other.skipped, _this.skipped) || other.skipped == _this.skipped)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as DayProgress;
  return Object.hash(runtimeType,_this.taken,_this.skipped,_this.total);
}

@override
String toString() {
  final _this = this as DayProgress;
  return 'DayProgress(taken: ${_this.taken}, skipped: ${_this.skipped}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $DayProgressCopyWith<$Res>  {
  factory $DayProgressCopyWith(DayProgress value, $Res Function(DayProgress) _then) = _$DayProgressCopyWithImpl;
@useResult
$Res call({
 int taken, int skipped, int total
});




}
/// @nodoc
class _$DayProgressCopyWithImpl<$Res>
    implements $DayProgressCopyWith<$Res> {
  _$DayProgressCopyWithImpl(this._self, this._then);

  final DayProgress _self;
  final $Res Function(DayProgress) _then;

/// Create a copy of DayProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taken = null,Object? skipped = null,Object? total = null,}) {
  return _then(DayProgress(
taken: null == taken ? _self.taken : taken // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DayProgress].
extension DayProgressPatterns on DayProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayProgress value)  $default,){
final _that = this;
switch (_that) {
case _DayProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayProgress value)?  $default,){
final _that = this;
switch (_that) {
case _DayProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int taken,  int skipped,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayProgress() when $default != null:
return $default(_that.taken,_that.skipped,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int taken,  int skipped,  int total)  $default,) {final _that = this;
switch (_that) {
case _DayProgress():
return $default(_that.taken,_that.skipped,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int taken,  int skipped,  int total)?  $default,) {final _that = this;
switch (_that) {
case _DayProgress() when $default != null:
return $default(_that.taken,_that.skipped,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _DayProgress extends DayProgress {
  const _DayProgress({required this.taken, required this.skipped, required this.total}): super._();
  

@override final  int taken;
@override final  int skipped;
@override final  int total;

/// Create a copy of DayProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayProgressCopyWith<_DayProgress> get copyWith => __$DayProgressCopyWithImpl<_DayProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayProgress&&(identical(other.taken, taken) || other.taken == taken)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,taken,skipped,total);
}

@override
String toString() {
    return 'DayProgress(taken: $taken, skipped: $skipped, total: $total)';
}


}

/// @nodoc
abstract mixin class _$DayProgressCopyWith<$Res> implements $DayProgressCopyWith<$Res> {
  factory _$DayProgressCopyWith(_DayProgress value, $Res Function(_DayProgress) _then) = __$DayProgressCopyWithImpl;
@override @useResult
$Res call({
 int taken, int skipped, int total
});




}
/// @nodoc
class __$DayProgressCopyWithImpl<$Res>
    implements _$DayProgressCopyWith<$Res> {
  __$DayProgressCopyWithImpl(this._self, this._then);

  final _DayProgress _self;
  final $Res Function(_DayProgress) _then;

/// Create a copy of DayProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taken = null,Object? skipped = null,Object? total = null,}) {
  return _then(_DayProgress(
taken: null == taken ? _self.taken : taken // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
