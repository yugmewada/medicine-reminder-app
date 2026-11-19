import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

enum SwipeActionTone { neutral, destructive }

/// One action revealed by swiping a card (`flutter_slidable` action pane),
/// styled to match [AppCard]: same radius, a gap from the card, themed
/// colors, and a 48dp+ target. Closes the pane before running [onPressed].
///
/// Swipes are not discoverable for screen readers: also expose each action
/// as a `CustomSemanticsAction` on the card.
class SwipeAction extends StatelessWidget {
  const SwipeAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tone = SwipeActionTone.neutral,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final SwipeActionTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      SwipeActionTone.neutral => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      SwipeActionTone.destructive => (
        colors.errorContainer,
        colors.onErrorContainer,
      ),
    };
    return Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Slidable.of(context)?.close();
              onPressed();
            },
            child: Semantics(
              button: true,
              label: label,
              excludeSemantics: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: foreground),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelMedium?.copyWith(
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
