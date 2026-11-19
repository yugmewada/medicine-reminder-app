import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/medicines/domain/medicine.dart';
import '../l10n/l10n.dart';

/// Locale-aware date/time formatting that is not a full sentence. Sentences
/// with dates use DateTime placeholders in the ARB file instead. Never store
/// these strings as data.
abstract final class AppFormats {
  static String _locale(BuildContext context) =>
      Localizations.localeOf(context).toString();

  /// Abbreviated weekday, e.g. "Thu".
  static String weekdayShort(BuildContext context, DateTime date) =>
      DateFormat.E(_locale(context)).format(date);

  /// A date for weekday [weekday] ([DateTime.monday]..[DateTime.sunday]),
  /// for formatting weekday names. 2024-01-01 was a Monday.
  static DateTime weekdayDate(int weekday) => DateTime(2024, 1, weekday);

  /// Time of day; respects the device's 12/24-hour setting.
  static String time(BuildContext context, ScheduleTime time) =>
      MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay(hour: time.hour, minute: time.minute),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      );

  /// Times joined with the localized list separator.
  static String times(BuildContext context, List<ScheduleTime> times) =>
      times.map((t) => time(context, t)).join(context.l10n.timeListSeparator);
}
