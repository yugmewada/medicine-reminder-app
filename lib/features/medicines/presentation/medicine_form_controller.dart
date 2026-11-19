import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/utils/utils.dart';
import '../domain/medicine.dart';
import 'medicines_controller.dart';

part 'medicine_form_controller.freezed.dart';

/// Immutable state of the add/edit medicine form (MVI "model").
@freezed
abstract class MedicineFormState with _$MedicineFormState {
  const MedicineFormState._();

  const factory MedicineFormState({
    /// The medicine being edited; null when adding.
    Medicine? initial,
    required String name,
    required String quantity,
    required MedicineType type,
    required StockUnit unit,

    /// Once the user picks a unit, changing the type no longer changes it.
    @Default(false) bool unitChosen,
    required ScheduleFrequency frequency,
    required int weekday,
    required int dayOfMonth,
    required List<ScheduleTime> times,
    PickedImage? photo,
    @Default(false) bool pickingPhoto,
  }) = _MedicineFormState;

  /// Pristine state for adding (null) or editing [medicine]. New medicines
  /// start without schedule times: the app never suggests when to take one.
  factory MedicineFormState.from(Medicine? medicine) => MedicineFormState(
    initial: medicine,
    name: medicine?.name ?? '',
    quantity: medicine?.stockQuantity.toString() ?? '',
    type: medicine?.type ?? MedicineType.tablet,
    unit: medicine?.stockUnit ?? MedicineType.tablet.defaultUnit,
    unitChosen: medicine != null,
    frequency: medicine?.frequency ?? ScheduleFrequency.daily,
    weekday: medicine?.weekday ?? DateTime.monday,
    dayOfMonth: medicine?.dayOfMonth ?? 1,
    times: medicine?.times ?? const [],
    photo: medicine?.photo,
  );

  bool get isEditing => initial != null;

  /// The first problem to report, in on-screen order (name, schedule
  /// times, quantity), or null when the form can be saved. The view shows
  /// it in a snackbar; fields never show inline errors.
  MedicineFormIssue? get firstIssue {
    switch (Validators.text(name, maxLength: Medicine.maxNameLength)) {
      case ValidationIssue.empty:
        return MedicineFormIssue.nameMissing;
      case ValidationIssue.tooLong:
        return MedicineFormIssue.nameTooLong;
      case _:
    }
    if (times.isEmpty) return MedicineFormIssue.timesMissing;
    return switch (Validators.wholeNumber(
      quantity,
      min: 0,
      max: Medicine.maxStock,
    )) {
      null => null,
      ValidationIssue.empty => MedicineFormIssue.quantityMissing,
      ValidationIssue.notWholeNumber => MedicineFormIssue.quantityNotWhole,
      _ => MedicineFormIssue.quantityOutOfRange,
    };
  }

  bool get isValid => firstIssue == null;

  bool get canAddTime => times.length < Medicine.maxTimes;

  /// True when the user changed anything worth confirming before leaving.
  bool get isDirty {
    final pristine = MedicineFormState.from(initial);
    return name.trim() != pristine.name ||
        quantity.trim() != pristine.quantity ||
        type != pristine.type ||
        unit != pristine.unit ||
        frequency != pristine.frequency ||
        weekday != pristine.weekday ||
        dayOfMonth != pristine.dayOfMonth ||
        !listEquals(times, pristine.times) ||
        photo != pristine.photo;
  }
}

enum AddTimeResult { added, duplicate, limitReached }

/// Why the form cannot be saved. Mapped to a localized snackbar message.
enum MedicineFormIssue {
  nameMissing,
  nameTooLong,
  timesMissing,
  quantityMissing,
  quantityNotWhole,
  quantityOutOfRange,
}

/// Form state per medicine id (null = add). Disposed when the form closes.
final medicineFormProvider = NotifierProvider.autoDispose
    .family<MedicineFormController, MedicineFormState, String?>(
      MedicineFormController.new,
    );

/// MVI state holder for the medicine form. Each public method is one user
/// intent; results that need UI feedback are returned to the caller.
class MedicineFormController extends Notifier<MedicineFormState> {
  MedicineFormController(this.medicineId);

  final String? medicineId;

  @override
  MedicineFormState build() {
    final id = medicineId;
    return MedicineFormState.from(
      id == null ? null : ref.read(medicineByIdProvider(id)),
    );
  }

  void setName(String value) => state = state.copyWith(name: value);

  void setQuantity(String value) => state = state.copyWith(quantity: value);

  void selectType(MedicineType type) => state = state.copyWith(
    type: type,
    unit: state.unitChosen ? state.unit : type.defaultUnit,
  );

  void selectUnit(StockUnit unit) =>
      state = state.copyWith(unit: unit, unitChosen: true);

  void selectFrequency(ScheduleFrequency frequency) =>
      state = state.copyWith(frequency: frequency);

  void selectWeekday(int weekday) => state = state.copyWith(weekday: weekday);

  void selectDayOfMonth(int day) => state = state.copyWith(dayOfMonth: day);

  AddTimeResult addTime(ScheduleTime time) {
    if (!state.canAddTime) return AddTimeResult.limitReached;
    if (state.times.contains(time)) return AddTimeResult.duplicate;
    state = state.copyWith(times: [...state.times, time]..sort());
    return AddTimeResult.added;
  }

  void removeTime(ScheduleTime time) =>
      state = state.copyWith(times: [...state.times]..remove(time));

  /// Opens the system photo picker. The result is returned so the view can
  /// report failures; a picked image is stored in state.
  Future<MediaPickResult> pickPhoto() async {
    if (state.pickingPhoto) return const MediaPickCancelled();
    state = state.copyWith(pickingPhoto: true);
    final result = await ref.read(mediaPickerProvider).pickImage();
    if (!ref.mounted) return result;
    state = state.copyWith(
      pickingPhoto: false,
      photo: result is MediaPicked ? result.image : state.photo,
    );
    return result;
  }

  void removePhoto() => state = state.copyWith(photo: null);

  /// Saves to the session inventory and returns the saved medicine, or
  /// null when invalid (the view then reports [MedicineFormState.firstIssue]).
  Medicine? submit() {
    if (!state.isValid) return null;
    final inventory = ref.read(medicinesProvider.notifier);
    final initial = state.initial;
    final medicine = Medicine(
      id: initial?.id ?? inventory.newId(),
      name: state.name.trim(),
      type: state.type,
      frequency: state.frequency,
      weekday: state.weekday,
      dayOfMonth: state.dayOfMonth,
      times: state.times,
      stockQuantity: int.parse(state.quantity.trim()),
      stockUnit: state.unit,
      startDate: initial?.startDate ?? ref.read(clockProvider)(),
      photo: state.photo,
    ).normalized();
    inventory.save(medicine);
    return medicine;
  }
}
