import '../domain/medicine.dart';

/// Fictional sample inventory. Names are invented and the schedules are
/// placeholders, not dosing guidance.
List<Medicine> sampleMedicines(DateTime today) {
  final start = DateTime(today.year, today.month, today.day - 30);
  return [
    Medicine(
      id: 'sample-brevora',
      name: 'Brevora',
      type: MedicineType.tablet,
      frequency: ScheduleFrequency.daily,
      times: const [ScheduleTime(8, 0), ScheduleTime(20, 0)],
      stockQuantity: 42,
      stockUnit: StockUnit.tablets,
      startDate: start,
    ),
    Medicine(
      id: 'sample-ceralin',
      name: 'Ceralin',
      type: MedicineType.capsule,
      frequency: ScheduleFrequency.daily,
      times: const [ScheduleTime(13, 0)],
      stockQuantity: 18,
      stockUnit: StockUnit.capsules,
      startDate: start,
    ),
    Medicine(
      id: 'sample-omnivy',
      name: 'Omnivy',
      type: MedicineType.liquid,
      frequency: ScheduleFrequency.daily,
      times: const [ScheduleTime(21, 30)],
      stockQuantity: 150,
      stockUnit: StockUnit.millilitres,
      startDate: start,
    ),
    Medicine(
      id: 'sample-dulvexa',
      name: 'Dulvexa',
      type: MedicineType.tablet,
      frequency: ScheduleFrequency.weekly,
      weekday: DateTime.monday,
      times: const [ScheduleTime(9, 0)],
      stockQuantity: 6,
      stockUnit: StockUnit.tablets,
      startDate: start,
    ),
    Medicine(
      id: 'sample-novaxil',
      name: 'Novaxil',
      type: MedicineType.other,
      frequency: ScheduleFrequency.monthly,
      dayOfMonth: 1,
      times: const [ScheduleTime(10, 0)],
      stockQuantity: 2,
      stockUnit: StockUnit.units,
      startDate: start,
    ),
  ];
}
