import 'package:demo_project/features/medicines/domain/medicine.dart';
import 'package:demo_project/features/medicines/presentation/medicine_form_controller.dart';
import 'package:demo_project/features/medicines/presentation/medicines_controller.dart';
import 'package:demo_project/core/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  /// Keeps the auto-dispose form provider alive for the test.
  MedicineFormController form(ProviderContainer c, [String? id]) {
    c.listen(medicineFormProvider(id), (_, _) {});
    return c.read(medicineFormProvider(id).notifier);
  }

  MedicineFormState state(ProviderContainer c, [String? id]) =>
      c.read(medicineFormProvider(id));

  test('a new form starts pristine, with no suggested times', () {
    final c = testContainer();
    form(c);
    final s = state(c);
    expect(s.isEditing, isFalse);
    expect(s.times, isEmpty);
    expect(s.isDirty, isFalse);
    expect(s.isValid, isFalse);
  });

  test('stock unit follows the type until the user picks one', () {
    final c = testContainer();
    final f = form(c);
    f.selectType(MedicineType.liquid);
    expect(state(c).unit, StockUnit.millilitres);
    f.selectUnit(StockUnit.units);
    f.selectType(MedicineType.capsule);
    expect(state(c).unit, StockUnit.units);
  });

  test('times are kept sorted, unique and limited', () {
    final c = testContainer();
    final f = form(c);
    expect(f.addTime(const ScheduleTime(20, 0)), AddTimeResult.added);
    expect(f.addTime(const ScheduleTime(8, 0)), AddTimeResult.added);
    expect(f.addTime(const ScheduleTime(8, 0)), AddTimeResult.duplicate);
    expect(state(c).times.map((t) => t.key), ['08:00', '20:00']);
    for (var h = 1; h <= 4; h++) {
      f.addTime(ScheduleTime(h, 30));
    }
    expect(state(c).times, hasLength(Medicine.maxTimes));
    expect(f.addTime(const ScheduleTime(23, 0)), AddTimeResult.limitReached);
    f.removeTime(const ScheduleTime(8, 0));
    expect(state(c).times, hasLength(Medicine.maxTimes - 1));
  });

  test('submit: invalid returns null and reports issues in screen order', () {
    final c = testContainer();
    final f = form(c);
    expect(f.submit(), isNull);
    expect(state(c).firstIssue, MedicineFormIssue.nameMissing);

    f.setName('x' * (Medicine.maxNameLength + 1));
    expect(state(c).firstIssue, MedicineFormIssue.nameTooLong);
    f.setName('Lumora');
    expect(state(c).firstIssue, MedicineFormIssue.timesMissing);
    f.addTime(const ScheduleTime(9, 0));
    expect(state(c).firstIssue, MedicineFormIssue.quantityMissing);
    f.setQuantity('2.5');
    expect(state(c).firstIssue, MedicineFormIssue.quantityNotWhole);
    f.setQuantity('${Medicine.maxStock + 1}');
    expect(state(c).firstIssue, MedicineFormIssue.quantityOutOfRange);

    expect(f.submit(), isNull);
    expect(c.read(medicinesProvider), hasLength(5)); // nothing saved
    f.setQuantity('3');
    expect(state(c).firstIssue, isNull);
    expect(f.submit(), isNotNull);
  });

  test('submit: valid input is saved to the session inventory', () {
    final c = testContainer();
    final f = form(c)
      ..setName('  Lumora  ')
      ..setQuantity('12')
      ..selectFrequency(ScheduleFrequency.weekly)
      ..selectWeekday(DateTime.friday);
    f.addTime(const ScheduleTime(9, 15));

    final saved = f.submit()!;
    expect(saved.name, 'Lumora');
    expect(saved.stockQuantity, 12);
    expect(saved.startDate, DateTime(2026, 11, 19));
    expect(c.read(medicinesProvider).last.name, 'Lumora');
    expect(c.read(medicinesProvider).last.weekday, DateTime.friday);
  });

  test('editing tracks changes against the original medicine', () {
    final c = testContainer();
    final f = form(c, 'sample-ceralin');
    expect(state(c, 'sample-ceralin').isEditing, isTrue);
    expect(state(c, 'sample-ceralin').isDirty, isFalse);
    f.setQuantity('30');
    expect(state(c, 'sample-ceralin').isDirty, isTrue);
    f.setQuantity('18');
    expect(state(c, 'sample-ceralin').isDirty, isFalse);

    f.setQuantity('30');
    f.submit();
    final updated = c.read(medicineByIdProvider('sample-ceralin'))!;
    expect(updated.stockQuantity, 30);
    expect(c.read(medicinesProvider), hasLength(5));
  });

  test('pickPhoto stores a picked image and reports failures', () async {
    final picker = FakeMediaPicker();
    final c = testContainer(picker: picker);
    final f = form(c);
    expect(await f.pickPhoto(), isA<MediaPicked>());
    expect(state(c).photo, isNotNull);
    expect(state(c).pickingPhoto, isFalse);
    expect(state(c).isDirty, isTrue);

    picker.result = const MediaPickFailed(MediaPickFailure.accessDenied);
    final failed = await f.pickPhoto();
    expect(failed, isA<MediaPickFailed>());
    expect(state(c).photo, isNotNull); // previous photo kept

    f.removePhoto();
    expect(state(c).photo, isNull);
  });
}
