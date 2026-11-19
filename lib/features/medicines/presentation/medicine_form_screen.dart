import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/formatting/app_formats.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/medicine.dart';
import 'medicine_detail_screen.dart';
import 'medicine_form_controller.dart';
import 'medicine_l10n.dart';
import 'medicines_controller.dart';
import 'widgets/medicine_visuals.dart';
import 'widgets/photo_field.dart';

/// Route for adding a medicine (`/inventory/add`).
@RoutePage()
class AddMedicineScreen extends StatelessWidget {
  const AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) => const MedicineFormScreen();
}

/// Route for editing a medicine (`/inventory/medicine/:medicineId/edit`).
@RoutePage()
class EditMedicineScreen extends StatelessWidget {
  const EditMedicineScreen({
    super.key,
    @PathParam('medicineId') required this.medicineId,
  });

  final String medicineId;

  @override
  Widget build(BuildContext context) =>
      MedicineFormScreen(medicineId: medicineId);
}

/// Add or edit form. A view over [MedicineFormController]: it renders
/// [MedicineFormState] and sends intents; rules live in the controller.
class MedicineFormScreen extends ConsumerWidget {
  const MedicineFormScreen({super.key, this.medicineId});

  /// Null to add a new medicine.
  final String? medicineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = medicineId;
    if (id != null && ref.watch(medicineByIdProvider(id)) == null) {
      return MedicineNotFound(title: context.l10n.editMedicine);
    }
    return _MedicineForm(medicineId: id);
  }
}

class _MedicineForm extends ConsumerStatefulWidget {
  const _MedicineForm({required this.medicineId});

  final String? medicineId;

  @override
  ConsumerState<_MedicineForm> createState() => _MedicineFormState();
}

class _MedicineFormState extends ConsumerState<_MedicineForm> {
  /// Text controllers are view state; their values are mirrored into the
  /// controller through intents on every change.
  late final TextEditingController _name;
  late final TextEditingController _quantity;

  MedicineFormController get _controller =>
      ref.read(medicineFormProvider(widget.medicineId).notifier);

  @override
  void initState() {
    super.initState();
    final state = ref.read(medicineFormProvider(widget.medicineId));
    _name = TextEditingController(text: state.name);
    _quantity = TextEditingController(text: state.quantity);
  }

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    super.dispose();
  }

  Future<void> _addTime() async {
    final now = ref.read(clockProvider)();
    final l10n = context.l10n;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: 0),
      helpText: l10n.timePickerHelp,
    );
    if (picked == null || !mounted) return;
    final time = ScheduleTime(picked.hour, picked.minute);
    if (_controller.addTime(time) == AddTimeResult.duplicate) {
      TopSnackbar.show(
        context,
        message: l10n.timeAlreadyAdded(AppFormats.time(context, time)),
        tone: SnackTone.warning,
      );
    }
  }

  Future<void> _pickPhoto() async {
    final l10n = context.l10n;
    final result = await _controller.pickPhoto();
    if (!mounted) return;
    if (result case MediaPickFailed(:final failure)) {
      TopSnackbar.show(
        context,
        message: l10n.pickError(failure),
        tone: SnackTone.error,
      );
    }
  }

  void _save() {
    final l10n = context.l10n;
    final state = ref.read(medicineFormProvider(widget.medicineId));
    final saved = _controller.submit();
    if (saved == null) {
      // Validation is reported only here, never as inline field errors.
      TopSnackbar.show(
        context,
        message: l10n.formIssue(state.firstIssue!),
        tone: SnackTone.warning,
      );
      return;
    }
    TopSnackbar.show(
      context,
      message: state.isEditing
          ? l10n.medicineUpdated(saved.name)
          : l10n.medicineAdded(saved.name),
      tone: SnackTone.success,
    );
    // pop (unlike maybePop) bypasses PopScope: saving never asks to discard.
    context.router.pop(saved);
  }

  Future<void> _confirmDiscard() async {
    final l10n = context.l10n;
    final discard = await AppDialogs.confirm(
      context,
      title: l10n.discardTitle,
      message: l10n.discardMessage,
      confirmLabel: l10n.discardConfirm,
      cancelLabel: l10n.keepEditing,
      destructive: true,
    );
    if (discard && mounted) context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(medicineFormProvider(widget.medicineId));
    return PopScope<Object?>(
      canPop: !state.isDirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: Scaffold(
        appBar: AppToolbar(
          title: state.isEditing ? l10n.editMedicine : l10n.addMedicine,
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
                children: _fields(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _fields(BuildContext context, MedicineFormState state) {
    final l10n = context.l10n;
    final c = _controller;
    const gap = SizedBox(height: AppSpacing.xl);
    return [
      PhotoField(
        photo: state.photo,
        loading: state.pickingPhoto,
        onPick: _pickPhoto,
        onRemove: c.removePhoto,
      ),
      gap,
      AppTextField(
        fieldKey: const ValueKey('field-name'),
        controller: _name,
        label: l10n.fieldName,
        textCapitalization: TextCapitalization.words,
        maxLength: Medicine.maxNameLength,
        onChanged: c.setName,
      ),
      gap,
      ChoiceGroup<MedicineType>(
        label: l10n.fieldType,
        keyPrefix: 'type',
        options: MedicineType.values,
        selected: state.type,
        labelOf: l10n.typeLabel,
        iconOf: (t) => MedicineTypeGlyph(type: t, size: 18),
        onSelected: c.selectType,
      ),
      gap,
      ChoiceGroup<ScheduleFrequency>(
        label: l10n.labelFrequency,
        helper: l10n.fieldFrequencyHelp,
        keyPrefix: 'frequency',
        options: ScheduleFrequency.values,
        selected: state.frequency,
        labelOf: l10n.frequencyLabel,
        onSelected: c.selectFrequency,
      ),
      if (state.frequency == ScheduleFrequency.weekly) ...[
        const SizedBox(height: AppSpacing.lg),
        ChoiceGroup<int>(
          label: l10n.fieldWeekday,
          keyPrefix: 'weekday',
          options: const [1, 2, 3, 4, 5, 6, 7],
          selected: state.weekday,
          labelOf: (d) =>
              AppFormats.weekdayShort(context, AppFormats.weekdayDate(d)),
          onSelected: c.selectWeekday,
        ),
      ],
      if (state.frequency == ScheduleFrequency.monthly) ...[
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<int>(
          key: const ValueKey('field-day-of-month'),
          initialValue: state.dayOfMonth,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: l10n.fieldDayOfMonth,
            helperText: l10n.fieldDayOfMonthHelp,
          ),
          items: [
            for (var d = 1; d <= Medicine.maxDayOfMonth; d++)
              DropdownMenuItem(value: d, child: Text(l10n.dayOfMonthOption(d))),
          ],
          onChanged: (d) {
            if (d != null) c.selectDayOfMonth(d);
          },
        ),
      ],
      gap,
      _ScheduleTimes(
        times: state.times,
        canAdd: state.canAddTime,
        onAdd: _addTime,
        onRemove: c.removeTime,
      ),
      gap,
      AppTextField(
        fieldKey: const ValueKey('field-quantity'),
        controller: _quantity,
        label: l10n.fieldQuantity,
        helper: l10n.fieldQuantityHelp,
        suffixText: l10n.unitLabel(state.unit),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: Medicine.maxStock.toString().length,
        onChanged: c.setQuantity,
      ),
      const SizedBox(height: AppSpacing.lg),
      ChoiceGroup<StockUnit>(
        label: l10n.fieldUnit,
        keyPrefix: 'unit',
        options: StockUnit.values,
        selected: state.unit,
        labelOf: l10n.unitLabel,
        onSelected: c.selectUnit,
      ),
      gap,
      Text(
        l10n.formSessionNote,
        style: context.text.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      AppButton(
        key: const ValueKey('save-medicine'),
        label: state.isEditing ? l10n.saveChanges : l10n.addMedicine,
        expand: true,
        onPressed: _save,
      ),
      const SizedBox(height: AppSpacing.sm),
      AppButton.text(
        key: const ValueKey('cancel-medicine'),
        label: l10n.actionCancel,
        expand: true,
        onPressed: () => context.router.maybePop(),
      ),
    ];
  }
}

class _ScheduleTimes extends StatelessWidget {
  const _ScheduleTimes({
    required this.times,
    required this.canAdd,
    required this.onAdd,
    required this.onRemove,
  });

  final List<ScheduleTime> times;
  final bool canAdd;
  final VoidCallback onAdd;
  final ValueChanged<ScheduleTime> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.labelScheduleTimes, style: context.text.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.scheduleTimesHelp,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final time in times)
              InputChip(
                key: ValueKey('time-${time.key}'),
                avatar: const Icon(Icons.schedule_rounded, size: 18),
                label: Text(AppFormats.time(context, time)),
                deleteButtonTooltipMessage: l10n.removeTime(
                  AppFormats.time(context, time),
                ),
                onDeleted: () => onRemove(time),
              ),
            if (canAdd)
              ActionChip(
                key: const ValueKey('add-time'),
                avatar: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.addTime),
                onPressed: onAdd,
              )
            else
              Text(
                l10n.maxTimes(Medicine.maxTimes),
                style: context.text.bodySmall,
              ),
          ],
        ),
      ],
    );
  }
}
