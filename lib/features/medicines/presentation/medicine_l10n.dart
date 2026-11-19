import '../../../core/formatting/app_formats.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/utils/utils.dart';
import '../domain/medicine.dart';
import 'medicine_form_controller.dart';

/// Localized display text for medicine domain values and typed errors.
/// Domain enums carry no user-facing text; map them here.
extension MedicineL10n on AppLocalizations {
  String typeLabel(MedicineType type) => medicineType(type.name);

  String frequencyLabel(ScheduleFrequency frequency) =>
      frequencyName(frequency.name);

  String unitLabel(StockUnit unit) => stockUnitName(unit.name);

  /// e.g. "42 tablets", "150 mL", "1 unit".
  String stock(Medicine medicine) =>
      stockAmount(medicine.stockUnit.name, medicine.stockQuantity);

  /// e.g. "Every day", "Every Monday", "Monthly on day 1".
  String cadence(Medicine medicine) => switch (medicine.frequency) {
    ScheduleFrequency.daily => cadenceDaily,
    ScheduleFrequency.weekly => cadenceWeekly(
      AppFormats.weekdayDate(medicine.weekday),
    ),
    ScheduleFrequency.monthly => cadenceMonthly(medicine.dayOfMonth),
  };

  /// Snackbar text for a form problem, e.g. "Please enter a medicine name."
  String formIssue(MedicineFormIssue issue) => medicineFormIssue(
    issue.name,
    Medicine.maxNameLength,
    0,
    Medicine.maxStock,
  );

  String pickError(MediaPickFailure failure) => pickFailed(failure.name);
}
