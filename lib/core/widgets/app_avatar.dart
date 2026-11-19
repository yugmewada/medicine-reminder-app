import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Circular avatar showing [image], else [initials], else [icon] (e.g. a
/// generic person for guests).
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.semanticLabel,
    this.initials,
    this.icon,
    this.image,
    this.size = AppSizes.avatar,
  }) : assert(initials != null || icon != null || image != null);

  final String? initials;
  final IconData? icon;
  final String semanticLabel;
  final ImageProvider? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final image = this.image;
    return Semantics(
      label: semanticLabel,
      image: true,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primary,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.primary.withValues(alpha: 0.75)],
          ),
          image: image == null
              ? null
              : DecorationImage(image: image, fit: BoxFit.cover),
          border: Border.all(color: colors.surfaceContainerLowest, width: 3),
        ),
        alignment: Alignment.center,
        child: image != null
            ? null
            : initials == null
            ? Icon(icon, color: colors.onPrimary, size: size * 0.5)
            : Text(
                initials!,
                // Fixed relative to the circle so it never overflows it.
                textScaler: TextScaler.noScaling,
                style: context.text.headlineSmall?.copyWith(
                  color: colors.onPrimary,
                  fontSize: size * 0.34,
                ),
              ),
      ),
    );
  }
}
