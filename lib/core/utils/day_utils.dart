/// Calendar-day helpers. All functions ignore the time-of-day component.
abstract final class DayUtils {
  /// Midnight (local) of [value]'s calendar day.
  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Whole calendar days from [from] to [to]; negative if [to] is earlier.
  /// Uses UTC dates so daylight-saving shifts do not produce off-by-one.
  static int daysBetween(DateTime from, DateTime to) {
    final a = DateTime.utc(from.year, from.month, from.day);
    final b = DateTime.utc(to.year, to.month, to.day);
    return b.difference(a).inDays;
  }

  /// [center] ± [radius] days, in order (length `2 * radius + 1`).
  static List<DateTime> daysAround(DateTime center, int radius) {
    final day = dateOnly(center);
    return [
      for (var i = -radius; i <= radius; i++)
        DateTime(day.year, day.month, day.day + i),
    ];
  }

  /// Stable `yyyy-mm-dd` key for maps and widget keys.
  static String key(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)}';
  }
}
