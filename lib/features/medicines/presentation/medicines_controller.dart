import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../data/sample_medicines.dart';
import '../domain/medicine.dart';

final medicinesProvider = NotifierProvider<MedicinesController, List<Medicine>>(
  MedicinesController.new,
);

/// Session-only inventory, seeded with fictional sample medicines.
/// Resets on logout (see `SessionController.logout`) and on app restart.
class MedicinesController extends Notifier<List<Medicine>> {
  var _nextId = 0;

  @override
  List<Medicine> build() => sampleMedicines(ref.read(clockProvider)());

  /// Creates an id for a medicine that has not been saved yet.
  String newId() =>
      'med-${ref.read(clockProvider)().microsecondsSinceEpoch}-${_nextId++}';

  /// Removes the medicine with [id] and returns its former position (for
  /// Undo), or -1 when it does not exist. Its dose logs are kept, so
  /// restoring it also restores its history.
  int delete(String id) {
    final index = state.indexWhere((m) => m.id == id);
    if (index == -1) return -1;
    state = [...state]..removeAt(index);
    return index;
  }

  /// Puts back a deleted [medicine] at its former [index] (Undo).
  void restore(Medicine medicine, int index) {
    if (state.any((m) => m.id == medicine.id)) return;
    state = [...state]..insert(index.clamp(0, state.length), medicine);
  }

  /// Adds [medicine], or replaces the one with the same id.
  void save(Medicine medicine) {
    final normalized = medicine.normalized();
    final index = state.indexWhere((m) => m.id == medicine.id);
    state = index == -1
        ? [...state, normalized]
        : [...state.sublist(0, index), normalized, ...state.sublist(index + 1)];
  }
}

final medicineByIdProvider = Provider.family<Medicine?, String>((ref, id) {
  for (final medicine in ref.watch(medicinesProvider)) {
    if (medicine.id == id) return medicine;
  }
  return null;
});
