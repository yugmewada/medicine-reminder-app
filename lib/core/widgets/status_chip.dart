import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

enum StatusTone { success, warning, neutral, info }

/// Compact status label. Always shows an icon and text so status never
/// depends on color alone.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.icon,
    this.tone = StatusTone.neutral,
  });

  final String label;
  final IconData icon;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = context.status;
    final (background, foreground) = switch (tone) {
      StatusTone.success => (
        status.successContainer,
        status.onSuccessContainer,
      ),
      StatusTone.warning => (
        status.warningContainer,
        status.onWarningContainer,
      ),
      StatusTone.info => (colors.primaryContainer, colors.onPrimaryContainer),
      StatusTone.neutral => (
        colors.surfaceContainerHigh,
        colors.onSurfaceVariant,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(child: Icon(icon, size: 16, color: foreground)),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              style: context.text.labelMedium?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
