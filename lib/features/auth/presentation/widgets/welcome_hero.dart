import 'package:material_ui/material_ui.dart';

/// Full-bleed photo with content (the auth actions) pinned to its bottom.
///
/// Falls back to a branded placeholder when [image] is null or fails to load.
class WelcomeHero extends StatelessWidget {
  const WelcomeHero({
    super.key,
    required this.child,
    this.image,
    this.minHeight = 300,
  });

  final ImageProvider? image;
  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Stack(
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: image == null
                  ? const _HeroPlaceholder()
                  : Image(
                      image: image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _HeroPlaceholder(),
                    ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: child),
        ],
      ),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [scheme.primaryContainer, scheme.primary],
        ),
      ),
      child: Align(
        alignment: const Alignment(0, -0.4),
        child: Icon(
          Icons.storefront_outlined,
          size: 72,
          color: scheme.onPrimary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
