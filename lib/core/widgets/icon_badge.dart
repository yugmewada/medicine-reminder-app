import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Rounded tile holding an icon. Decorative by default.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.size = AppSizes.iconBadge,
    this.background,
    this.foreground,
  });

  final IconData icon;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background ?? context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(
          icon,
          size: size * 0.52,
          color: foreground ?? context.colors.onPrimaryContainer,
        ),
      ),
    );
  }
}
