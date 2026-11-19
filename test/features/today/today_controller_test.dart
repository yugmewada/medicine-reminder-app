import 'package:demo_project/features/today/domain/dose_schedule.dart';
import 'package:demo_project/features/today/presentation/today_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  test('select stays within the date range', () {
    final c = testContainer();
    final dates = c.read(selectedDateProvider.notifier);
    dates.select(DateTime(2026, 12, 3, 15)); // +14 days, time dropped
    expect(c.read(selectedDateProvider), DateTime(2026, 12, 3));
    dates.select(DateTime(2026, 12, 4)); // +15: ignored
    expect(c.read(selectedDateProvider), DateTime(2026, 12, 3));
    dates.selectToday();
    expect(c.read(selectedDateProvider), DateTime(2026, 11, 19));
  });

  test('dose log: log, restore and clear', () {
    final c = testContainer();
    final logs = c.read(doseLogProvider.notifier);
    logs.log('a', DoseStatus.taken);
    logs.log('a', DoseStatus.skipped);
    logs.restore('a', DoseStatus.taken);
    expect(c.read(doseLogProvider), {'a': DoseStatus.taken});
    logs.restore('a', null);
    expect(c.read(doseLogProvider), isEmpty);
  });

  test('day plan recalculates when the date or logs change', () {
    final c = testContainer();
    expect(c.read(dayPlanProvider).progress.total, 4);
    final first = c.read(dayPlanProvider).occasions.first;
    c.read(doseLogProvider.notifier).log(first.id, DoseStatus.taken);
    expect(c.read(dayPlanProvider).progress.percent, 25);

    c.read(selectedDateProvider.notifier).select(DateTime(2026, 11, 16));
    final monday = c.read(dayPlanProvider);
    expect(monday.progress.total, 5);
    expect(monday.progress.taken, 0);
    expect(monday.canLog, isTrue);
    expect(monday.isToday, isFalse);

    c.read(selectedDateProvider.notifier).select(DateTime(2026, 11, 20));
    expect(c.read(dayPlanProvider).canLog, isFalse);
  });
}
