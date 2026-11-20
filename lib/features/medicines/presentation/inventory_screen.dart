import 'package:auto_route/auto_route.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router/app_router.gr.dart';
import '../../../core/formatting/app_formats.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/medicine.dart';
import '../../auth/presentation/sign_in_prompt.dart';
import 'medicine_actions.dart';
import 'medicine_l10n.dart';
import 'medicines_controller.dart';
import 'widgets/medicine_visuals.dart';

@RoutePage()
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final medicines = ref.watch(medicinesProvider);
    void add() => runIfCanManageMedicines(
      context,
      ref,
      () => context.router.push(const AddMedicineRoute()),
    );

    return Scaffold(
      appBar: AppToolbar(
        title: l10n.inventoryTitle,
        subtitle: medicines.isEmpty
            ? null
            : l10n.medicineCount(medicines.length),
      ),
      floatingActionButton: medicines.isEmpty
          ? null
          // Scaffold places FABs from the system safe area only, so lift it
          // above the floating tab bar explicitly.
          : Padding(
              padding: EdgeInsets.only(bottom: context.bottomBarInset),
              child: FloatingActionButton.extended(
                key: const ValueKey('add-medicine'),
                onPressed: add,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addMedicine),
              ),
            ),
      body: medicines.isEmpty
          ? Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  0,
                  AppSpacing.page,
                  context.bottomBarInset,
                ),
                child: ContentWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EmptyState(
                        icon: Icons.inventory_2_rounded,
                        title: l10n.emptyInventoryTitle,
                        message: l10n.emptyInventoryMessage,
                        action: AppButton(
                          key: const ValueKey('add-medicine'),
                          label: l10n.addMedicine,
                          icon: const Icon(Icons.add_rounded),
                          onPressed: add,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          // Lazy list: item 0 is the notice, then one tile per medicine.
          // Only one card's swipe actions are open at a time.
          : SlidableAutoCloseBehavior(
              child: ListView.separated(
                // Bottom padding keeps the FAB and the floating tab bar
                // off the last card.
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.sm,
                  AppSpacing.page,
                  96 + context.bottomBarInset,
                ),
                itemCount: medicines.length + 1,
                separatorBuilder: (_, index) => SizedBox(
                  height: index == 0 ? AppSpacing.lg : AppSpacing.md,
                ),
                itemBuilder: (context, index) => ContentWidth(
                  child: index == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PrototypeNotice(message: l10n.inventoryNotice),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.inventorySwipeHint,
                              style: context.text.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        )
                      : MedicineTile(medicine: medicines[index - 1]),
                ),
              ),
            ),
    );
  }
}

/// Inventory card. Tap opens the detail; swiping right-to-left reveals Edit
/// and Delete (also available to screen readers as custom actions).
class MedicineTile extends ConsumerWidget {
  const MedicineTile({super.key, required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Guests are asked to sign in first (see runIfCanManageMedicines).
    void edit() => runIfCanManageMedicines(
      context,
      ref,
      () => context.router.push(EditMedicineRoute(medicineId: medicine.id)),
    );
    void delete() => runIfCanManageMedicines(
      context,
      ref,
      () => confirmAndDeleteMedicine(context, ref, medicine),
    );

    return Slidable(
      key: ValueKey('slidable-${medicine.id}'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SwipeAction(
            key: ValueKey('swipe-edit-${medicine.id}'),
            icon: Icons.edit_outlined,
            label: l10n.actionEdit,
            onPressed: edit,
          ),
          SwipeAction(
            key: ValueKey('swipe-delete-${medicine.id}'),
            icon: Icons.delete_outline_rounded,
            label: l10n.deleteConfirm,
            tone: SwipeActionTone.destructive,
            onPressed: delete,
          ),
        ],
      ),
      // Merged into the card's own node, so screen readers offer the
      // actions on the item they focus.
      child: MergeSemantics(
        child: Semantics(
          customSemanticsActions: {
            CustomSemanticsAction(label: l10n.actionEdit): edit,
            CustomSemanticsAction(label: l10n.deleteConfirm): delete,
          },
          child: _MedicineCard(medicine: medicine),
        ),
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    return AppCard(
      key: ValueKey('medicine-${medicine.id}'),
      onTap: () =>
          context.router.push(MedicineDetailRoute(medicineId: medicine.id)),
      child: Row(
        children: [
          Hero(
            tag: MedicineBadge.heroTag(medicine.id),
            child: MedicineBadge(medicine: medicine, size: 52),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine.name, style: context.text.titleMedium),
                const SizedBox(height: 2),
                Text(
                  l10n.typeAndCadence(
                    l10n.typeLabel(medicine.type),
                    l10n.cadence(medicine),
                  ),
                  style: muted,
                ),
                Text(AppFormats.times(context, medicine.times), style: muted),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.inStock(l10n.stock(medicine)),
                  style: context.text.labelMedium,
                ),
              ],
            ),
          ),
          ExcludeSemantics(
            child: Icon(
              Icons.chevron_right_rounded,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
