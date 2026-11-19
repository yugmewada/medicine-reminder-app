import 'package:material_ui/material_ui.dart';

import '../../../../core/formatting/app_formats.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../medicines/presentation/medicine_l10n.dart';
import '../../../medicines/presentation/widgets/medicine_visuals.dart';
import '../../domain/dose_schedule.dart';

/// Display state of a dose occasion. Labels come from `l10n.doseStatus`.
enum DoseDisplay {
  taken(Icons.check_circle_rounded, StatusTone.success),
  skipped(Icons.do_not_disturb_on_rounded, StatusTone.warning),
  upcoming(Icons.schedule_rounded, StatusTone.info),
  scheduled(Icons.event_rounded, StatusTone.neutral),
  notLogged(Icons.radio_button_unchecked_rounded, StatusTone.neutral);

  const DoseDisplay(this.icon, this.tone);

  final IconData icon;
  final StatusTone tone;

  bool get isLogged => this == taken || this == skipped;

  static DoseDisplay of({
    required DoseStatus? status,
    required DateTime scheduledAt,
    required DateTime now,
    required bool canLog,
  }) {
    return switch (status) {
      DoseStatus.taken => taken,
      DoseStatus.skipped => skipped,
      null when !canLog => scheduled,
      null when scheduledAt.isAfter(now) => upcoming,
      null => notLogged,
    };
  }
}

class DoseCard extends StatelessWidget {
  const DoseCard({
    super.key,
    required this.occasion,
    required this.display,
    required this.canLog,
    required this.onLog,
    required this.onUndo,
  });

  final DoseOccasion occasion;
  final DoseDisplay display;
  final bool canLog;
  final ValueChanged<DoseStatus> onLog;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final medicine = occasion.medicine;
    final time = AppFormats.time(context, occasion.time);
    final id = occasion.id;
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );

    return AppCard(
      key: ValueKey('dose-$id'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MedicineBadge(medicine: medicine),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medicine.name, style: context.text.titleMedium),
                      Text(
                        l10n.doseTimeAndType(
                          time,
                          l10n.typeLabel(medicine.type),
                        ),
                        style: muted,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Status changes cross-fade so the change is noticed.
                      KeyedSubtree(
                        key: ValueKey('status-$id'),
                        child: AnimatedSwitcher(
                          duration: AppMotion.of(context, AppMotion.short),
                          switchInCurve: AppMotion.enter,
                          switchOutCurve: AppMotion.exit,
                          child: StatusChip(
                            key: ValueKey(display),
                            label: l10n.doseStatus(display.name),
                            icon: display.icon,
                            tone: display.tone,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (!canLog)
            Text(l10n.doseFutureNote, style: muted)
          else if (display.isLogged)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton.text(
                key: ValueKey('dose-undo-$id'),
                label: l10n.actionUndo,
                icon: const Icon(Icons.undo_rounded),
                compact: true,
                onPressed: onUndo,
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    hint: l10n.doseTakenHint(time, medicine.name),
                    child: AppButton.tonal(
                      key: ValueKey('dose-taken-$id'),
                      label: l10n.actionTaken,
                      icon: const Icon(Icons.check_rounded),
                      compact: true,
                      onPressed: () => onLog(DoseStatus.taken),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Semantics(
                    hint: l10n.doseSkipHint(time, medicine.name),
                    child: AppButton.secondary(
                      key: ValueKey('dose-skip-$id'),
                      label: l10n.actionSkip,
                      icon: const Icon(Icons.do_not_disturb_on_outlined),
                      compact: true,
                      onPressed: () => onLog(DoseStatus.skipped),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
