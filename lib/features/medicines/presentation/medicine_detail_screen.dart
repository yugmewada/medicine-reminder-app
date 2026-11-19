import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router/app_router.gr.dart';
import '../../../core/formatting/app_formats.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/presentation/sign_in_prompt.dart';
import '../domain/medicine.dart';
import 'medicine_actions.dart';
import 'medicine_l10n.dart';
import 'medicines_controller.dart';
import 'widgets/medicine_visuals.dart';

/// Medicine view at `/inventory/medicine/:medicineId`, with Edit and
/// Delete. An unknown id (stale deep link, reset session) shows a
/// recoverable state.
@RoutePage()
class MedicineDetailScreen extends ConsumerStatefulWidget {
  const MedicineDetailScreen({
    super.key,
    @PathParam('medicineId') required this.medicineId,
  });

  final String medicineId;

  @override
  ConsumerState<MedicineDetailScreen> createState() =>
      _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends ConsumerState<MedicineDetailScreen> {
  /// Last medicine shown. After deleting it here, the screen keeps showing it
  /// while it animates out, instead of flashing "Medicine not found".
  Medicine? _lastShown;
  bool _deletedHere = false;

  Future<void> _delete(Medicine medicine) async {
    final router = context.router;
    _deletedHere = true;
    final deleted = await confirmAndDeleteMedicine(context, ref, medicine);
    if (!deleted) {
      _deletedHere = false;
      return;
    }
    await router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = ref.watch(medicineByIdProvider(widget.medicineId));
    if (current != null) _lastShown = current;
    final medicine = current ?? (_deletedHere ? _lastShown : null);
    if (medicine == null) {
      return MedicineNotFound(title: l10n.medicineFallbackTitle);
    }

    // Guests are asked to sign in first (see runIfCanManageMedicines).
    void edit() => runIfCanManageMedicines(
      context,
      ref,
      () => context.router.push(EditMedicineRoute(medicineId: medicine.id)),
    );
    void delete() =>
        runIfCanManageMedicines(context, ref, () => _delete(medicine));

    return Scaffold(
      appBar: AppToolbar(
        title: medicine.name,
        actions: [
          IconButton(
            key: const ValueKey('edit-medicine'),
            tooltip: l10n.editMedicine,
            icon: const Icon(Icons.edit_outlined),
            onPressed: edit,
          ),
          IconButton(
            key: const ValueKey('delete-medicine'),
            tooltip: l10n.deleteMedicine,
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: delete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      Hero(
                        tag: MedicineBadge.heroTag(medicine.id),
                        child: MedicineBadge(medicine: medicine, size: 112),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        medicine.name,
                        style: context.text.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.typeLabel(medicine.type),
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Icons.event_repeat_rounded,
                        label: l10n.labelFrequency,
                        value: l10n.frequencyWithCadence(
                          l10n.frequencyLabel(medicine.frequency),
                          l10n.cadence(medicine),
                        ),
                      ),
                      const Divider(),
                      InfoRow(
                        icon: Icons.schedule_rounded,
                        label: l10n.labelScheduleTimes,
                        value: AppFormats.times(context, medicine.times),
                      ),
                      const Divider(),
                      InfoRow(
                        icon: Icons.inventory_2_outlined,
                        label: l10n.labelInStock,
                        value: l10n.stock(medicine),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrototypeNotice(message: l10n.detailNotice),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: l10n.editMedicine,
                  icon: const Icon(Icons.edit_outlined),
                  expand: true,
                  onPressed: edit,
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton.secondary(
                  key: const ValueKey('delete-medicine-button'),
                  label: l10n.deleteMedicine,
                  icon: const Icon(Icons.delete_outline_rounded),
                  expand: true,
                  destructive: true,
                  onPressed: delete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when a medicine id does not exist (shared by detail and edit).
class MedicineNotFound extends StatelessWidget {
  const MedicineNotFound({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppToolbar(title: title),
      body: Center(
        child: SingleChildScrollView(
          child: EmptyState(
            icon: Icons.search_off_rounded,
            title: l10n.medicineNotFoundTitle,
            message: l10n.medicineNotFoundMessage,
            action: AppButton.secondary(
              key: const ValueKey('back-to-inventory'),
              label: l10n.backToInventory,
              onPressed: () => context.router.navigate(
                const HomeShellRoute(children: [InventoryTabRoute()]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
