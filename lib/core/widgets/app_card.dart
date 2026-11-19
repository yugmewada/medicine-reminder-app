import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';

/// Standard content card: themed surface, border and radius, with optional
/// ink feedback when [onTap] is set.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Override the surface, e.g. `colorScheme.primaryContainer` for emphasis.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? Padding(padding: padding, child: child)
          // Read as one button by screen readers.
          : MergeSemantics(
              child: Semantics(
                button: true,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(padding: padding, child: child),
                ),
              ),
            ),
    );
  }
}
