import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/medicine.dart';
import 'medicines_controller.dart';

/// The one delete flow, shared by the detail screen and the inventory
/// swipe action: confirm, delete from the session, then offer Undo.
///
/// Returns true when the medicine was deleted.
Future<bool> confirmAndDeleteMedicine(
  BuildContext context,
  WidgetRef ref,
  Medicine medicine,
) async {
  final l10n = context.l10n;
  final confirmed = await AppDialogs.confirm(
    context,
    icon: Icons.delete_outline_rounded,
    title: l10n.deleteMedicineTitle(medicine.name),
    message: l10n.deleteMedicineMessage,
    confirmLabel: l10n.deleteConfirm,
    destructive: true,
  );
  if (!confirmed || !context.mounted) return false;

  final inventory = ref.read(medicinesProvider.notifier);
  final index = inventory.delete(medicine.id);
  TopSnackbar.show(
    context,
    message: l10n.medicineDeleted(medicine.name),
    actionLabel: l10n.actionUndo,
    onAction: () => inventory.restore(medicine, index),
  );
  return true;
}
