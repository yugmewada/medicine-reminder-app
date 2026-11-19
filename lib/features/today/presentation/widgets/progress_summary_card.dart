import 'package:material_ui/material_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/dose_schedule.dart';

/// Taken-versus-scheduled summary for the selected day.
class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({super.key, required this.progress});

  final DayProgress progress;

  /// "1 of 5 scheduled doses logged as taken — 20%"
  static String headline(AppLocalizations l10n, DayProgress p) => p.hasDoses
      ? l10n.progressHeadline(p.taken, p.total, p.percentFraction)
      : l10n.progressNone;

  static String detail(AppLocalizations l10n, DayProgress p) {
    final parts = [
      if (p.skipped > 0) l10n.progressSkipped(p.skipped),
      if (p.notLogged > 0) l10n.progressNotLogged(p.notLogged),
    ];
    return parts.isEmpty
        ? l10n.progressAllLogged
        : parts.join(l10n.listSeparator);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final p = progress;
    final onContainer = context.text.bodySmall?.copyWith(
      color: colors.onPrimaryContainer,
    );
    return AppCard(
      key: const ValueKey('progress-card'),
      color: colors.primaryContainer,
      child: Semantics(
        container: true,
        label: p.hasDoses
            ? '${headline(l10n, p)}. ${detail(l10n, p)}.'
            : headline(l10n, p),
        excludeSemantics: true,
        child: Row(
          children: [
            ProgressRing(
              value: p.fraction,
              label: p.hasDoses
                  ? l10n.percentValue(p.percentFraction)
                  : l10n.progressNoValue,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline(l10n, p),
                    key: const ValueKey('progress-headline'),
                    style: context.text.titleSmall?.copyWith(
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                  if (p.hasDoses) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      detail(l10n, p),
                      key: const ValueKey('progress-detail'),
                      style: onContainer,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.progressCaption, style: onContainer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
