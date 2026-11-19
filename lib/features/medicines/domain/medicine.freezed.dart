// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleTime {

 int get hour; int get minute;
/// Create a copy of ScheduleTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleTimeCopyWith<ScheduleTime> get copyWith => _$ScheduleTimeCopyWithImpl<ScheduleTime>(this as ScheduleTime, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScheduleTime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleTime&&(identical(other.hour, _this.hour) || other.hour == _this.hour)&&(identical(other.minute, _this.minute) || other.minute == _this.minute));
}


@override
int get hashCode {
  final _this = this as ScheduleTime;
  return Object.hash(runtimeType,_this.hour,_this.minute);
}

@override
String toString() {
  final _this = this as ScheduleTime;
  return 'ScheduleTime(hour: ${_this.hour}, minute: ${_this.minute})';
}


}

/// @nodoc
abstract mixin class $ScheduleTimeCopyWith<$Res>  {
  factory $ScheduleTimeCopyWith(ScheduleTime value, $Res Function(ScheduleTime) _then) = _$ScheduleTimeCopyWithImpl;
@useResult
$Res call({
 int hour, int minute
});




}
/// @nodoc
class _$ScheduleTimeCopyWithImpl<$Res>
    implements $ScheduleTimeCopyWith<$Res> {
  _$ScheduleTimeCopyWithImpl(this._self, this._then);

  final ScheduleTime _self;
  final $Res Function(ScheduleTime) _then;

/// Create a copy of ScheduleTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? minute = null,}) {
  return _then(ScheduleTime(
null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleTime].
extension ScheduleTimePatterns on ScheduleTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleTime value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleTime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleTime value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int minute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleTime() when $default != null:
return $default(_that.hour,_that.minute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int minute)  $default,) {final _that = this;
switch (_that) {
case _ScheduleTime():
return $default(_that.hour,_that.minute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int minute)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleTime() when $default != null:
return $default(_that.hour,_that.minute);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleTime extends ScheduleTime {
  const _ScheduleTime(this.hour, this.minute): assert(hour >= 0 && hour < 24),assert(minute >= 0 && minute < 60),super._();
  

@override final  int hour;
@override final  int minute;

/// Create a copy of ScheduleTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleTimeCopyWith<_ScheduleTime> get copyWith => __$ScheduleTimeCopyWithImpl<_ScheduleTime>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hour,minute);
}

@override
String toString() {
    return 'ScheduleTime(hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class _$ScheduleTimeCopyWith<$Res> implements $ScheduleTimeCopyWith<$Res> {
  factory _$ScheduleTimeCopyWith(_ScheduleTime value, $Res Function(_ScheduleTime) _then) = __$ScheduleTimeCopyWithImpl;
@override @useResult
$Res call({
 int hour, int minute
});




}
/// @nodoc
class __$ScheduleTimeCopyWithImpl<$Res>
    implements _$ScheduleTimeCopyWith<$Res> {
  __$ScheduleTimeCopyWithImpl(this._self, this._then);

  final _ScheduleTime _self;
  final $Res Function(_ScheduleTime) _then;

/// Create a copy of ScheduleTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? minute = null,}) {
  return _then(_ScheduleTime(
null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Medicine {

 String get id; String get name; MedicineType get type; ScheduleFrequency get frequency;/// Used when [frequency] is weekly ([DateTime.monday]..[DateTime.sunday]).
 int get weekday;/// Used when [frequency] is monthly (1..[maxDayOfMonth]).
 int get dayOfMonth;/// Demo schedule times, sorted ascending.
 List<ScheduleTime> get times; int get stockQuantity; StockUnit get stockUnit;/// First day the medicine appears on the schedule.
 DateTime get startDate; PickedImage? get photo;
/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineCopyWith<Medicine> get copyWith => _$MedicineCopyWithImpl<Medicine>(this as Medicine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Medicine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medicine&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.dayOfMonth, _this.dayOfMonth) || other.dayOfMonth == _this.dayOfMonth)&&const DeepCollectionEquality().equals(other.times, _this.times)&&(identical(other.stockQuantity, _this.stockQuantity) || other.stockQuantity == _this.stockQuantity)&&(identical(other.stockUnit, _this.stockUnit) || other.stockUnit == _this.stockUnit)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.photo, _this.photo) || other.photo == _this.photo));
}


@override
int get hashCode {
  final _this = this as Medicine;
  return Object.hash(runtimeType,_this.id,_this.name,_this.type,_this.frequency,_this.weekday,_this.dayOfMonth,const DeepCollectionEquality().hash(_this.times),_this.stockQuantity,_this.stockUnit,_this.startDate,_this.photo);
}

@override
String toString() {
  final _this = this as Medicine;
  return 'Medicine(id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, frequency: ${_this.frequency}, weekday: ${_this.weekday}, dayOfMonth: ${_this.dayOfMonth}, times: ${_this.times}, stockQuantity: ${_this.stockQuantity}, stockUnit: ${_this.stockUnit}, startDate: ${_this.startDate}, photo: ${_this.photo})';
}


}

/// @nodoc
abstract mixin class $MedicineCopyWith<$Res>  {
  factory $MedicineCopyWith(Medicine value, $Res Function(Medicine) _then) = _$MedicineCopyWithImpl;
@useResult
$Res call({
 String id, String name, MedicineType type, ScheduleFrequency frequency, int weekday, int dayOfMonth, List<ScheduleTime> times, int stockQuantity, StockUnit stockUnit, DateTime startDate, PickedImage? photo
});




}
/// @nodoc
class _$MedicineCopyWithImpl<$Res>
    implements $MedicineCopyWith<$Res> {
  _$MedicineCopyWithImpl(this._self, this._then);

  final Medicine _self;
  final $Res Function(Medicine) _then;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? frequency = null,Object? weekday = null,Object? dayOfMonth = null,Object? times = null,Object? stockQuantity = null,Object? stockUnit = null,Object? startDate = null,Object? photo = freezed,}) {
  return _then(Medicine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MedicineType,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as ScheduleFrequency,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<ScheduleTime>,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,stockUnit: null == stockUnit ? _self.stockUnit : stockUnit // ignore: cast_nullable_to_non_nullable
as StockUnit,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as PickedImage?,
  ));
}

}


/// Adds pattern-matching-related methods to [Medicine].
extension MedicinePatterns on Medicine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medicine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medicine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medicine value)  $default,){
final _that = this;
switch (_that) {
case _Medicine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medicine value)?  $default,){
final _that = this;
switch (_that) {
case _Medicine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  MedicineType type,  ScheduleFrequency frequency,  int weekday,  int dayOfMonth,  List<ScheduleTime> times,  int stockQuantity,  StockUnit stockUnit,  DateTime startDate,  PickedImage? photo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.frequency,_that.weekday,_that.dayOfMonth,_that.times,_that.stockQuantity,_that.stockUnit,_that.startDate,_that.photo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  MedicineType type,  ScheduleFrequency frequency,  int weekday,  int dayOfMonth,  List<ScheduleTime> times,  int stockQuantity,  StockUnit stockUnit,  DateTime startDate,  PickedImage? photo)  $default,) {final _that = this;
switch (_that) {
case _Medicine():
return $default(_that.id,_that.name,_that.type,_that.frequency,_that.weekday,_that.dayOfMonth,_that.times,_that.stockQuantity,_that.stockUnit,_that.startDate,_that.photo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  MedicineType type,  ScheduleFrequency frequency,  int weekday,  int dayOfMonth,  List<ScheduleTime> times,  int stockQuantity,  StockUnit stockUnit,  DateTime startDate,  PickedImage? photo)?  $default,) {final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.frequency,_that.weekday,_that.dayOfMonth,_that.times,_that.stockQuantity,_that.stockUnit,_that.startDate,_that.photo);case _:
  return null;

}
}

}

/// @nodoc


class _Medicine extends Medicine {
  const _Medicine({required this.id, required this.name, required this.type, required this.frequency, this.weekday = DateTime.monday, this.dayOfMonth = 1, required  List<ScheduleTime> times, required this.stockQuantity, required this.stockUnit, required this.startDate, this.photo}): assert(times.length > 0, 'A medicine needs at least one schedule time'),assert(weekday >= 1 && weekday <= 7),assert(dayOfMonth >= 1 && dayOfMonth <= 28),_times = times,super._();
  

@override final  String id;
@override final  String name;
@override final  MedicineType type;
@override final  ScheduleFrequency frequency;
/// Used when [frequency] is weekly ([DateTime.monday]..[DateTime.sunday]).
@override@JsonKey() final  int weekday;
/// Used when [frequency] is monthly (1..[maxDayOfMonth]).
@override@JsonKey() final  int dayOfMonth;
/// Demo schedule times, sorted ascending.
 final  List<ScheduleTime> _times;
/// Demo schedule times, sorted ascending.
@override List<ScheduleTime> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

@override final  int stockQuantity;
@override final  StockUnit stockUnit;
/// First day the medicine appears on the schedule.
@override final  DateTime startDate;
@override final  PickedImage? photo;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineCopyWith<_Medicine> get copyWith => __$MedicineCopyWithImpl<_Medicine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medicine&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&const DeepCollectionEquality().equals(other.times, _times)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.stockUnit, stockUnit) || other.stockUnit == stockUnit)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.photo, photo) || other.photo == photo));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,type,frequency,weekday,dayOfMonth,const DeepCollectionEquality().hash(_times),stockQuantity,stockUnit,startDate,photo);
}

@override
String toString() {
    return 'Medicine(id: $id, name: $name, type: $type, frequency: $frequency, weekday: $weekday, dayOfMonth: $dayOfMonth, times: $times, stockQuantity: $stockQuantity, stockUnit: $stockUnit, startDate: $startDate, photo: $photo)';
}


}

/// @nodoc
abstract mixin class _$MedicineCopyWith<$Res> implements $MedicineCopyWith<$Res> {
  factory _$MedicineCopyWith(_Medicine value, $Res Function(_Medicine) _then) = __$MedicineCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, MedicineType type, ScheduleFrequency frequency, int weekday, int dayOfMonth, List<ScheduleTime> times, int stockQuantity, StockUnit stockUnit, DateTime startDate, PickedImage? photo
});




}
/// @nodoc
class __$MedicineCopyWithImpl<$Res>
    implements _$MedicineCopyWith<$Res> {
  __$MedicineCopyWithImpl(this._self, this._then);

  final _Medicine _self;
  final $Res Function(_Medicine) _then;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? frequency = null,Object? weekday = null,Object? dayOfMonth = null,Object? times = null,Object? stockQuantity = null,Object? stockUnit = null,Object? startDate = null,Object? photo = freezed,}) {
  return _then(_Medicine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MedicineType,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as ScheduleFrequency,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<ScheduleTime>,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,stockUnit: null == stockUnit ? _self.stockUnit : stockUnit // ignore: cast_nullable_to_non_nullable
as StockUnit,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as PickedImage?,
  ));
}


}

// dart format on
