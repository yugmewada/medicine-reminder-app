import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/utils.dart';
import '../../medicines/domain/medicine.dart';

part 'dose_schedule.freezed.dart';

/// What the user logged for a dose occasion. A log is the user's own
/// record; it does not prove a medicine was taken.
enum DoseStatus { taken, skipped }

/// One scheduled time for one medicine on one day.
@freezed
abstract class DoseOccasion with _$DoseOccasion {
  const DoseOccasion._();

  const factory DoseOccasion({
    required Medicine medicine,
    required DateTime date,
    required ScheduleTime time,
  }) = _DoseOccasion;

  /// `medicineId|yyyy-mm-dd|HH:mm`. Stable across medicine edits that keep
  /// the time, so logs survive renames.
  String get id => '${medicine.id}|${DayUtils.key(date)}|${time.key}';

  DateTime get scheduledAt => time.on(date);
}

/// Taken-versus-scheduled counts for one day.
@freezed
abstract class DayProgress with _$DayProgress {
  const DayProgress._();

  const factory DayProgress({
    required int taken,
    required int skipped,
    required int total,
  }) = _DayProgress;

  bool get hasDoses => total > 0;
  int get logged => taken + skipped;
  int get notLogged => total - logged;

  /// taken / total × 100, rounded down so 100% only means every dose was
  /// logged as taken. 0 when nothing is scheduled (never divides by zero).
  int get percent => total == 0 ? 0 : (taken * 100) ~/ total;

  /// [percent] as a fraction for locale-aware percent formatting.
  double get percentFraction => percent / 100;

  /// Exact share for the progress ring.
  double get fraction => total == 0 ? 0 : taken / total;
}

abstract final class DoseSchedule {
  /// Dose occasions for [day], ordered by time, then medicine name.
  static List<DoseOccasion> occasionsFor(
    DateTime day,
    Iterable<Medicine> medicines,
  ) {
    final date = DayUtils.dateOnly(day);
    final occasions = [
      for (final medicine in medicines)
        if (medicine.isScheduledOn(date))
          for (final time in medicine.times)
            DoseOccasion(medicine: medicine, date: date, time: time),
    ];
    occasions.sort((a, b) {
      final byTime = a.time.compareTo(b.time);
      if (byTime != 0) return byTime;
      return a.medicine.name.toLowerCase().compareTo(
        b.medicine.name.toLowerCase(),
      );
    });
    return occasions;
  }

  static DayProgress progressFor(
    List<DoseOccasion> occasions,
    Map<String, DoseStatus> logs,
  ) {
    var taken = 0;
    var skipped = 0;
    for (final occasion in occasions) {
      switch (logs[occasion.id]) {
        case DoseStatus.taken:
          taken++;
        case DoseStatus.skipped:
          skipped++;
        case null:
          break;
      }
    }
    return DayProgress(taken: taken, skipped: skipped, total: occasions.length);
  }
}
