import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'icon_badge.dart';

/// Tappable settings-style row: icon, title, optional subtitle, chevron.
class ActionRow extends StatelessWidget {
  const ActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.destructive = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool destructive;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = this.subtitle;
    return ListTile(
      onTap: onTap,
      leading: IconBadge(
        icon: icon,
        size: 40,
        background: destructive
            ? colors.errorContainer
            : colors.surfaceContainerHigh,
        foreground: destructive ? colors.error : colors.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: destructive
            ? context.text.titleSmall?.copyWith(color: colors.error)
            : null,
      ),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: showChevron
          ? ExcludeSemantics(
              child: Icon(
                Icons.chevron_right_rounded,
                color: colors.onSurfaceVariant,
              ),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
