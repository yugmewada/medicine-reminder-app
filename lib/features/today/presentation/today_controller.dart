import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/utils/utils.dart';
import '../../medicines/presentation/medicines_controller.dart';
import '../domain/dose_schedule.dart';

part 'today_controller.freezed.dart';

/// Days shown either side of today in the date selector.
const int dateRangeRadius = 14;

final selectedDateProvider = NotifierProvider<SelectedDateController, DateTime>(
  SelectedDateController.new,
);

class SelectedDateController extends Notifier<DateTime> {
  @override
  DateTime build() => _today;

  DateTime get _today => DayUtils.dateOnly(ref.read(clockProvider)());

  /// Selects [day], clamped to the visible date range.
  void select(DateTime day) {
    final offset = DayUtils.daysBetween(_today, day);
    if (offset.abs() > dateRangeRadius) return;
    state = DayUtils.dateOnly(day);
  }

  void selectToday() => state = _today;
}

final doseLogProvider =
    NotifierProvider<DoseLogController, Map<String, DoseStatus>>(
      DoseLogController.new,
    );

/// User-entered dose logs for this session, keyed by [DoseOccasion.id].
class DoseLogController extends Notifier<Map<String, DoseStatus>> {
  @override
  Map<String, DoseStatus> build() => const {};

  void log(String occasionId, DoseStatus status) {
    state = {...state, occasionId: status};
  }

  /// Clears a log so the dose is back to "not logged".
  void clear(String occasionId) {
    if (!state.containsKey(occasionId)) return;
    state = {...state}..remove(occasionId);
  }

  /// Restores a previous value (used by Undo).
  void restore(String occasionId, DoseStatus? previous) {
    previous == null ? clear(occasionId) : log(occasionId, previous);
  }
}

/// Everything the Today screen needs for the selected date.
@freezed
abstract class DayPlan with _$DayPlan {
  const DayPlan._();

  const factory DayPlan({
    required DateTime date,
    required DateTime today,
    required List<DoseOccasion> occasions,
    required Map<String, DoseStatus> logs,
    required DayProgress progress,
  }) = _DayPlan;

  bool get isToday => DayUtils.isSameDay(date, today);

  /// Doses on future days cannot be logged yet.
  bool get canLog => DayUtils.daysBetween(today, date) <= 0;

  DoseStatus? statusOf(DoseOccasion occasion) => logs[occasion.id];
}

final dayPlanProvider = Provider<DayPlan>((ref) {
  final date = ref.watch(selectedDateProvider);
  final medicines = ref.watch(medicinesProvider);
  final logs = ref.watch(doseLogProvider);
  final today = DayUtils.dateOnly(ref.watch(clockProvider)());
  final occasions = DoseSchedule.occasionsFor(date, medicines);
  return DayPlan(
    date: date,
    today: today,
    occasions: occasions,
    logs: logs,
    progress: DoseSchedule.progressFor(occasions, logs),
  );
});
