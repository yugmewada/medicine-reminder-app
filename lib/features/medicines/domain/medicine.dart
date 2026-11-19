import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/utils.dart';

part 'medicine.freezed.dart';

/// Form of a medicine. Display names come from localization
/// (`AppLocalizations.medicineType`), never from this enum.
enum MedicineType {
  tablet,
  capsule,
  liquid,
  other;

  /// Sensible stock unit to preselect. The user can change it.
  StockUnit get defaultUnit => switch (this) {
    MedicineType.tablet => StockUnit.tablets,
    MedicineType.capsule => StockUnit.capsules,
    MedicineType.liquid => StockUnit.millilitres,
    MedicineType.other => StockUnit.units,
  };
}

/// How often the medicine appears on the schedule. Cadence, not course
/// duration.
enum ScheduleFrequency { daily, weekly, monthly }

/// Unit for the inventory count. Never a prescribed dose.
enum StockUnit { tablets, capsules, millilitres, units }

/// A time of day on the demo schedule, independent of any UI library.
@freezed
abstract class ScheduleTime
    with _$ScheduleTime
    implements Comparable<ScheduleTime> {
  const ScheduleTime._();

  @Assert('hour >= 0 && hour < 24')
  @Assert('minute >= 0 && minute < 60')
  const factory ScheduleTime(int hour, int minute) = _ScheduleTime;

  int get minutesOfDay => hour * 60 + minute;

  DateTime on(DateTime day) =>
      DateTime(day.year, day.month, day.day, hour, minute);

  /// Stable `HH:mm` key for ids and widget keys (not for display).
  String get key =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(ScheduleTime other) => minutesOfDay - other.minutesOfDay;
}

/// A medicine in the user's session inventory.
///
/// Invariants (enforced by `MedicinesController.save`): [times] is sorted
/// and non-empty, [startDate] is a date without time.
@freezed
abstract class Medicine with _$Medicine {
  const Medicine._();

  /// Monthly schedules stop at 28 so every month has the chosen day.
  static const int maxDayOfMonth = 28;
  static const int maxNameLength = 40;
  static const int maxTimes = 6;
  static const int maxStock = 99999;

  @Assert('times.length > 0', 'A medicine needs at least one schedule time')
  @Assert('weekday >= 1 && weekday <= 7')
  @Assert('dayOfMonth >= 1 && dayOfMonth <= 28')
  const factory Medicine({
    required String id,
    required String name,
    required MedicineType type,
    required ScheduleFrequency frequency,

    /// Used when [frequency] is weekly ([DateTime.monday]..[DateTime.sunday]).
    @Default(DateTime.monday) int weekday,

    /// Used when [frequency] is monthly (1..[maxDayOfMonth]).
    @Default(1) int dayOfMonth,

    /// Demo schedule times, sorted ascending.
    required List<ScheduleTime> times,
    required int stockQuantity,
    required StockUnit stockUnit,

    /// First day the medicine appears on the schedule.
    required DateTime startDate,
    PickedImage? photo,
  }) = _Medicine;

  /// Returns a copy that satisfies the invariants above.
  Medicine normalized() => copyWith(
    times: [...times]..sort(),
    startDate: DayUtils.dateOnly(startDate),
  );

  bool isScheduledOn(DateTime day) {
    if (DayUtils.daysBetween(startDate, day) < 0) return false;
    return switch (frequency) {
      ScheduleFrequency.daily => true,
      ScheduleFrequency.weekly => day.weekday == weekday,
      ScheduleFrequency.monthly => day.day == dayOfMonth,
    };
  }
}
