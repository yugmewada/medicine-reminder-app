import 'package:demo_project/features/medicines/data/sample_medicines.dart';
import 'package:demo_project/features/medicines/domain/medicine.dart';
import 'package:demo_project/features/today/domain/dose_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  final medicines = sampleMedicines(fixedNow);

  List<String> names(DateTime day) => [
    for (final o in DoseSchedule.occasionsFor(day, medicines))
      '${o.time.key} ${o.medicine.name}',
  ];

  group('occasionsFor', () {
    test('daily medicines on a Thursday, sorted by time', () {
      expect(names(DateTime(2026, 11, 19)), [
        '08:00 Brevora',
        '13:00 Ceralin',
        '20:00 Brevora',
        '21:30 Omnivy',
      ]);
    });

    test('weekly medicine appears only on its weekday', () {
      expect(names(DateTime(2026, 11, 16)), contains('09:00 Dulvexa'));
      expect(names(DateTime(2026, 11, 17)), isNot(contains('09:00 Dulvexa')));
    });

    test('monthly medicine appears only on its day of month', () {
      expect(names(DateTime(2026, 12, 1)), contains('10:00 Novaxil'));
      expect(names(DateTime(2026, 12, 2)), isNot(contains('10:00 Novaxil')));
    });

    test('nothing is scheduled before a medicine starts', () {
      final m = Medicine(
        id: 'x',
        name: 'Test',
        type: MedicineType.other,
        frequency: ScheduleFrequency.daily,
        times: const [ScheduleTime(9, 0)],
        stockQuantity: 1,
        stockUnit: StockUnit.units,
        startDate: DateTime(2026, 11, 19),
      );
      expect(DoseSchedule.occasionsFor(DateTime(2026, 11, 18), [m]), isEmpty);
      expect(
        DoseSchedule.occasionsFor(DateTime(2026, 11, 19, 23), [m]),
        hasLength(1),
      );
    });
  });

  group('progress', () {
    DayProgress progressWith(int total, {int taken = 0, int skipped = 0}) {
      final occasions = DoseSchedule.occasionsFor(
        DateTime(2026, 11, 16),
        medicines,
      ).take(total).toList();
      final logs = {
        for (final o in occasions.take(taken)) o.id: DoseStatus.taken,
        for (final o in occasions.skip(taken).take(skipped))
          o.id: DoseStatus.skipped,
      };
      return DoseSchedule.progressFor(occasions, logs);
    }

    test('1 taken of 5 scheduled is 20%', () {
      final p = progressWith(5, taken: 1);
      expect((p.taken, p.total, p.percent), (1, 5, 20));
    });

    test('skipped doses count toward the total but not as taken', () {
      final p = progressWith(5, taken: 2, skipped: 2);
      expect((p.taken, p.skipped, p.logged, p.percent), (2, 2, 4, 40));
    });

    test('zero scheduled doses is 0% without dividing by zero', () {
      final p = DoseSchedule.progressFor(const [], const {});
      expect(p.hasDoses, isFalse);
      expect(p.percent, 0);
      expect(p.fraction, 0);
    });

    test('rounds down so 100% only means all taken', () {
      expect(progressWith(3, taken: 2).percent, 66);
      expect(progressWith(3, taken: 3).percent, 100);
    });

    test('logs for other days are ignored', () {
      final thursday = DoseSchedule.occasionsFor(
        DateTime(2026, 11, 19),
        medicines,
      );
      final monday = DoseSchedule.occasionsFor(
        DateTime(2026, 11, 16),
        medicines,
      );
      final p = DoseSchedule.progressFor(thursday, {
        monday.first.id: DoseStatus.taken,
      });
      expect(p.taken, 0);
    });
  });
}
