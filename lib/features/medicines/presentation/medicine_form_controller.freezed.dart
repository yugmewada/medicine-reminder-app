// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicineFormState implements DiagnosticableTreeMixin {

/// The medicine being edited; null when adding.
 Medicine? get initial; String get name; String get quantity; MedicineType get type; StockUnit get unit;/// Once the user picks a unit, changing the type no longer changes it.
 bool get unitChosen; ScheduleFrequency get frequency; int get weekday; int get dayOfMonth; List<ScheduleTime> get times; PickedImage? get photo; bool get pickingPhoto;
/// Create a copy of MedicineFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineFormStateCopyWith<MedicineFormState> get copyWith => _$MedicineFormStateCopyWithImpl<MedicineFormState>(this as MedicineFormState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as MedicineFormState;
  properties
    ..add(DiagnosticsProperty('type', 'MedicineFormState'))
    ..add(DiagnosticsProperty('initial', _this.initial))..add(DiagnosticsProperty('name', _this.name))..add(DiagnosticsProperty('quantity', _this.quantity))..add(DiagnosticsProperty('type', _this.type))..add(DiagnosticsProperty('unit', _this.unit))..add(DiagnosticsProperty('unitChosen', _this.unitChosen))..add(DiagnosticsProperty('frequency', _this.frequency))..add(DiagnosticsProperty('weekday', _this.weekday))..add(DiagnosticsProperty('dayOfMonth', _this.dayOfMonth))..add(DiagnosticsProperty('times', _this.times))..add(DiagnosticsProperty('photo', _this.photo))..add(DiagnosticsProperty('pickingPhoto', _this.pickingPhoto));
}

@override
bool operator ==(Object other) {
  final _this = this as MedicineFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicineFormState&&(identical(other.initial, _this.initial) || other.initial == _this.initial)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.unitChosen, _this.unitChosen) || other.unitChosen == _this.unitChosen)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.dayOfMonth, _this.dayOfMonth) || other.dayOfMonth == _this.dayOfMonth)&&const DeepCollectionEquality().equals(other.times, _this.times)&&(identical(other.photo, _this.photo) || other.photo == _this.photo)&&(identical(other.pickingPhoto, _this.pickingPhoto) || other.pickingPhoto == _this.pickingPhoto));
}


@override
int get hashCode {
  final _this = this as MedicineFormState;
  return Object.hash(runtimeType,_this.initial,_this.name,_this.quantity,_this.type,_this.unit,_this.unitChosen,_this.frequency,_this.weekday,_this.dayOfMonth,const DeepCollectionEquality().hash(_this.times),_this.photo,_this.pickingPhoto);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as MedicineFormState;
  return 'MedicineFormState(initial: ${_this.initial}, name: ${_this.name}, quantity: ${_this.quantity}, type: ${_this.type}, unit: ${_this.unit}, unitChosen: ${_this.unitChosen}, frequency: ${_this.frequency}, weekday: ${_this.weekday}, dayOfMonth: ${_this.dayOfMonth}, times: ${_this.times}, photo: ${_this.photo}, pickingPhoto: ${_this.pickingPhoto})';
}


}

/// @nodoc
abstract mixin class $MedicineFormStateCopyWith<$Res>  {
  factory $MedicineFormStateCopyWith(MedicineFormState value, $Res Function(MedicineFormState) _then) = _$MedicineFormStateCopyWithImpl;
@useResult
$Res call({
 Medicine? initial, String name, String quantity, MedicineType type, StockUnit unit, bool unitChosen, ScheduleFrequency frequency, int weekday, int dayOfMonth, List<ScheduleTime> times, PickedImage? photo, bool pickingPhoto
});


$MedicineCopyWith<$Res>? get initial;

}
/// @nodoc
class _$MedicineFormStateCopyWithImpl<$Res>
    implements $MedicineFormStateCopyWith<$Res> {
  _$MedicineFormStateCopyWithImpl(this._self, this._then);

  final MedicineFormState _self;
  final $Res Function(MedicineFormState) _then;

/// Create a copy of MedicineFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initial = freezed,Object? name = null,Object? quantity = null,Object? type = null,Object? unit = null,Object? unitChosen = null,Object? frequency = null,Object? weekday = null,Object? dayOfMonth = null,Object? times = null,Object? photo = freezed,Object? pickingPhoto = null,}) {
  return _then(MedicineFormState(
initial: freezed == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as Medicine?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MedicineType,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as StockUnit,unitChosen: null == unitChosen ? _self.unitChosen : unitChosen // ignore: cast_nullable_to_non_nullable
as bool,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as ScheduleFrequency,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<ScheduleTime>,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as PickedImage?,pickingPhoto: null == pickingPhoto ? _self.pickingPhoto : pickingPhoto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MedicineFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCopyWith<$Res>? get initial {
    if (_self.initial == null) {
    return null;
  }

  return $MedicineCopyWith<$Res>(_self.initial!, (value) {
    return _then(_self.copyWith(initial: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicineFormState].
extension MedicineFormStatePatterns on MedicineFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicineFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicineFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicineFormState value)  $default,){
final _that = this;
switch (_that) {
case _MedicineFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicineFormState value)?  $default,){
final _that = this;
switch (_that) {
case _MedicineFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Medicine? initial,  String name,  String quantity,  MedicineType type,  StockUnit unit,  bool unitChosen,  ScheduleFrequency frequency,  int weekday,  int dayOfMonth,  List<ScheduleTime> times,  PickedImage? photo,  bool pickingPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicineFormState() when $default != null:
return $default(_that.initial,_that.name,_that.quantity,_that.type,_that.unit,_that.unitChosen,_that.frequency,_that.weekday,_that.dayOfMonth,_that.times,_that.photo,_that.pickingPhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Medicine? initial,  String name,  String quantity,  MedicineType type,  StockUnit unit,  bool unitChosen,  ScheduleFrequency frequency,  int weekday,  int dayOfMonth,  List<ScheduleTime> times,  PickedImage? photo,  bool pickingPhoto)  $default,) {final _that = this;
switch (_that) {
case _MedicineFormState():
return $default(_that.initial,_that.name,_that.quantity,_that.type,_that.unit,_that.unitChosen,_that.frequency,_that.weekday,_that.dayOfMonth,_that.times,_that.photo,_that.pickingPhoto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Medicine? initial,  String name,  String quantity,  MedicineType type,  StockUnit unit,  bool unitChosen,  ScheduleFrequency frequency,  int weekday,  int dayOfMonth,  List<ScheduleTime> times,  PickedImage? photo,  bool pickingPhoto)?  $default,) {final _that = this;
switch (_that) {
case _MedicineFormState() when $default != null:
return $default(_that.initial,_that.name,_that.quantity,_that.type,_that.unit,_that.unitChosen,_that.frequency,_that.weekday,_that.dayOfMonth,_that.times,_that.photo,_that.pickingPhoto);case _:
  return null;

}
}

}

/// @nodoc


class _MedicineFormState extends MedicineFormState with DiagnosticableTreeMixin {
  const _MedicineFormState({this.initial, required this.name, required this.quantity, required this.type, required this.unit, this.unitChosen = false, required this.frequency, required this.weekday, required this.dayOfMonth, required  List<ScheduleTime> times, this.photo, this.pickingPhoto = false}): _times = times,super._();
  

/// The medicine being edited; null when adding.
@override final  Medicine? initial;
@override final  String name;
@override final  String quantity;
@override final  MedicineType type;
@override final  StockUnit unit;
/// Once the user picks a unit, changing the type no longer changes it.
@override@JsonKey() final  bool unitChosen;
@override final  ScheduleFrequency frequency;
@override final  int weekday;
@override final  int dayOfMonth;
 final  List<ScheduleTime> _times;
@override List<ScheduleTime> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

@override final  PickedImage? photo;
@override@JsonKey() final  bool pickingPhoto;

/// Create a copy of MedicineFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineFormStateCopyWith<_MedicineFormState> get copyWith => __$MedicineFormStateCopyWithImpl<_MedicineFormState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MedicineFormState'))
    ..add(DiagnosticsProperty('initial', initial))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('quantity', quantity))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('unit', unit))..add(DiagnosticsProperty('unitChosen', unitChosen))..add(DiagnosticsProperty('frequency', frequency))..add(DiagnosticsProperty('weekday', weekday))..add(DiagnosticsProperty('dayOfMonth', dayOfMonth))..add(DiagnosticsProperty('times', times))..add(DiagnosticsProperty('photo', photo))..add(DiagnosticsProperty('pickingPhoto', pickingPhoto));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicineFormState&&(identical(other.initial, initial) || other.initial == initial)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitChosen, unitChosen) || other.unitChosen == unitChosen)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&const DeepCollectionEquality().equals(other.times, _times)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.pickingPhoto, pickingPhoto) || other.pickingPhoto == pickingPhoto));
}


@override
int get hashCode {
    return Object.hash(runtimeType,initial,name,quantity,type,unit,unitChosen,frequency,weekday,dayOfMonth,const DeepCollectionEquality().hash(_times),photo,pickingPhoto);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MedicineFormState(initial: $initial, name: $name, quantity: $quantity, type: $type, unit: $unit, unitChosen: $unitChosen, frequency: $frequency, weekday: $weekday, dayOfMonth: $dayOfMonth, times: $times, photo: $photo, pickingPhoto: $pickingPhoto)';
}


}

/// @nodoc
abstract mixin class _$MedicineFormStateCopyWith<$Res> implements $MedicineFormStateCopyWith<$Res> {
  factory _$MedicineFormStateCopyWith(_MedicineFormState value, $Res Function(_MedicineFormState) _then) = __$MedicineFormStateCopyWithImpl;
@override @useResult
$Res call({
 Medicine? initial, String name, String quantity, MedicineType type, StockUnit unit, bool unitChosen, ScheduleFrequency frequency, int weekday, int dayOfMonth, List<ScheduleTime> times, PickedImage? photo, bool pickingPhoto
});


@override $MedicineCopyWith<$Res>? get initial;

}
/// @nodoc
class __$MedicineFormStateCopyWithImpl<$Res>
    implements _$MedicineFormStateCopyWith<$Res> {
  __$MedicineFormStateCopyWithImpl(this._self, this._then);

  final _MedicineFormState _self;
  final $Res Function(_MedicineFormState) _then;

/// Create a copy of MedicineFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initial = freezed,Object? name = null,Object? quantity = null,Object? type = null,Object? unit = null,Object? unitChosen = null,Object? frequency = null,Object? weekday = null,Object? dayOfMonth = null,Object? times = null,Object? photo = freezed,Object? pickingPhoto = null,}) {
  return _then(_MedicineFormState(
initial: freezed == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as Medicine?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MedicineType,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as StockUnit,unitChosen: null == unitChosen ? _self.unitChosen : unitChosen // ignore: cast_nullable_to_non_nullable
as bool,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as ScheduleFrequency,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<ScheduleTime>,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as PickedImage?,pickingPhoto: null == pickingPhoto ? _self.pickingPhoto : pickingPhoto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MedicineFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCopyWith<$Res>? get initial {
    if (_self.initial == null) {
    return null;
  }

  return $MedicineCopyWith<$Res>(_self.initial!, (value) {
    return _then(_self.copyWith(initial: value));
  });
}
}

// dart format on
