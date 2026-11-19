// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DayPlan {

 DateTime get date; DateTime get today; List<DoseOccasion> get occasions; Map<String, DoseStatus> get logs; DayProgress get progress;
/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayPlanCopyWith<DayPlan> get copyWith => _$DayPlanCopyWithImpl<DayPlan>(this as DayPlan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DayPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayPlan&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.today, _this.today) || other.today == _this.today)&&const DeepCollectionEquality().equals(other.occasions, _this.occasions)&&const DeepCollectionEquality().equals(other.logs, _this.logs)&&(identical(other.progress, _this.progress) || other.progress == _this.progress));
}


@override
int get hashCode {
  final _this = this as DayPlan;
  return Object.hash(runtimeType,_this.date,_this.today,const DeepCollectionEquality().hash(_this.occasions),const DeepCollectionEquality().hash(_this.logs),_this.progress);
}

@override
String toString() {
  final _this = this as DayPlan;
  return 'DayPlan(date: ${_this.date}, today: ${_this.today}, occasions: ${_this.occasions}, logs: ${_this.logs}, progress: ${_this.progress})';
}


}

/// @nodoc
abstract mixin class $DayPlanCopyWith<$Res>  {
  factory $DayPlanCopyWith(DayPlan value, $Res Function(DayPlan) _then) = _$DayPlanCopyWithImpl;
@useResult
$Res call({
 DateTime date, DateTime today, List<DoseOccasion> occasions, Map<String, DoseStatus> logs, DayProgress progress
});


$DayProgressCopyWith<$Res> get progress;

}
/// @nodoc
class _$DayPlanCopyWithImpl<$Res>
    implements $DayPlanCopyWith<$Res> {
  _$DayPlanCopyWithImpl(this._self, this._then);

  final DayPlan _self;
  final $Res Function(DayPlan) _then;

/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? today = null,Object? occasions = null,Object? logs = null,Object? progress = null,}) {
  return _then(DayPlan(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,occasions: null == occasions ? _self.occasions : occasions // ignore: cast_nullable_to_non_nullable
as List<DoseOccasion>,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as Map<String, DoseStatus>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as DayProgress,
  ));
}
/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayProgressCopyWith<$Res> get progress {
  
  return $DayProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [DayPlan].
extension DayPlanPatterns on DayPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayPlan value)  $default,){
final _that = this;
switch (_that) {
case _DayPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayPlan value)?  $default,){
final _that = this;
switch (_that) {
case _DayPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  DateTime today,  List<DoseOccasion> occasions,  Map<String, DoseStatus> logs,  DayProgress progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayPlan() when $default != null:
return $default(_that.date,_that.today,_that.occasions,_that.logs,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  DateTime today,  List<DoseOccasion> occasions,  Map<String, DoseStatus> logs,  DayProgress progress)  $default,) {final _that = this;
switch (_that) {
case _DayPlan():
return $default(_that.date,_that.today,_that.occasions,_that.logs,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  DateTime today,  List<DoseOccasion> occasions,  Map<String, DoseStatus> logs,  DayProgress progress)?  $default,) {final _that = this;
switch (_that) {
case _DayPlan() when $default != null:
return $default(_that.date,_that.today,_that.occasions,_that.logs,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _DayPlan extends DayPlan {
  const _DayPlan({required this.date, required this.today, required  List<DoseOccasion> occasions, required  Map<String, DoseStatus> logs, required this.progress}): _occasions = occasions,_logs = logs,super._();
  

@override final  DateTime date;
@override final  DateTime today;
 final  List<DoseOccasion> _occasions;
@override List<DoseOccasion> get occasions {
  if (_occasions is EqualUnmodifiableListView) return _occasions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_occasions);
}

 final  Map<String, DoseStatus> _logs;
@override Map<String, DoseStatus> get logs {
  if (_logs is EqualUnmodifiableMapView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_logs);
}

@override final  DayProgress progress;

/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayPlanCopyWith<_DayPlan> get copyWith => __$DayPlanCopyWithImpl<_DayPlan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayPlan&&(identical(other.date, date) || other.date == date)&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other.occasions, _occasions)&&const DeepCollectionEquality().equals(other.logs, _logs)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,today,const DeepCollectionEquality().hash(_occasions),const DeepCollectionEquality().hash(_logs),progress);
}

@override
String toString() {
    return 'DayPlan(date: $date, today: $today, occasions: $occasions, logs: $logs, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$DayPlanCopyWith<$Res> implements $DayPlanCopyWith<$Res> {
  factory _$DayPlanCopyWith(_DayPlan value, $Res Function(_DayPlan) _then) = __$DayPlanCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, DateTime today, List<DoseOccasion> occasions, Map<String, DoseStatus> logs, DayProgress progress
});


@override $DayProgressCopyWith<$Res> get progress;

}
/// @nodoc
class __$DayPlanCopyWithImpl<$Res>
    implements _$DayPlanCopyWith<$Res> {
  __$DayPlanCopyWithImpl(this._self, this._then);

  final _DayPlan _self;
  final $Res Function(_DayPlan) _then;

/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? today = null,Object? occasions = null,Object? logs = null,Object? progress = null,}) {
  return _then(_DayPlan(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,occasions: null == occasions ? _self._occasions : occasions // ignore: cast_nullable_to_non_nullable
as List<DoseOccasion>,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as Map<String, DoseStatus>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as DayProgress,
  ));
}

/// Create a copy of DayPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayProgressCopyWith<$Res> get progress {
  
  return $DayProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
