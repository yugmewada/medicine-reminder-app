import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'icon_badge.dart';

/// Friendly placeholder for lists with no content.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconBadge(icon: icon, size: 64),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: context.text.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.xl),
            action,
          ],
        ],
      ),
    );
  }
}
