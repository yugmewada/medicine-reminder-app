import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'brand_logo.dart';
import 'progress_ring.dart';

enum FeatureArtKind { welcome, inventory, plan, progress }

/// Decorative illustration panel built from UI shapes in the app palette.
///
/// Placeholder artwork: replace with licensed illustrations or product
/// screenshots when available (see docs/MASTER_PROMPT.md > Assets). The
/// scene is laid out at a fixed design size and scaled to fit, so it never
/// overflows and ignores text scaling (it carries no information).
class FeatureArt extends StatelessWidget {
  const FeatureArt({super.key, required this.kind});

  final FeatureArtKind kind;

  static const Size _design = Size(300, 240);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primaryContainer, colors.surfaceContainerHigh],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -40,
                child: _Blob(
                  size: 160,
                  color: colors.primary.withValues(alpha: 0.08),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -50,
                child: _Blob(
                  size: 140,
                  color: colors.primary.withValues(alpha: 0.06),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: FittedBox(
                    child: MediaQuery.withNoTextScaling(
                      child: SizedBox.fromSize(
                        size: _design,
                        child: switch (kind) {
                          FeatureArtKind.welcome => const _WelcomeScene(),
                          FeatureArtKind.inventory => const _InventoryScene(),
                          FeatureArtKind.plan => const _PlanScene(),
                          FeatureArtKind.progress => const _ProgressScene(),
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

/// White rounded panel used inside scenes.
class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = 12});

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      boxShadow: [
        BoxShadow(
          color: context.colors.shadow.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, this.strong = false});

  final double width;
  final bool strong;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: strong ? 9 : 7,
    decoration: BoxDecoration(
      color: strong
          ? context.colors.onSurface.withValues(alpha: 0.75)
          : context.colors.outlineVariant,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, this.size = 34});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: context.colors.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.sm + 2),
    ),
    child: Icon(icon, size: size * 0.55, color: context.colors.primary),
  );
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.icon, required this.width, this.trailing});

  final IconData icon;
  final double width;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _Tile(icon: icon),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Bar(width: width, strong: true),
            const SizedBox(height: 6),
            _Bar(width: width * 0.6),
          ],
        ),
      ),
      ?trailing,
    ],
  );
}

class _WelcomeScene extends StatelessWidget {
  const _WelcomeScene();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceContainerLowest,
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.10),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(child: BrandLogo(size: 88)),
        ),
        const Positioned(
          left: 18,
          top: 28,
          child: _Tile(icon: Icons.medication_liquid_rounded, size: 44),
        ),
        const Positioned(
          right: 20,
          top: 16,
          child: _Tile(icon: Icons.schedule_rounded, size: 40),
        ),
        const Positioned(
          left: 36,
          bottom: 18,
          child: _Tile(icon: Icons.inventory_2_rounded, size: 40),
        ),
        Positioned(
          right: 26,
          bottom: 30,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.status.successContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: context.status.success,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

class _InventoryScene extends StatelessWidget {
  const _InventoryScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 30,
          right: 30,
          top: 24,
          child: _Panel(
            child: Column(
              children: const [
                _ItemRow(icon: Icons.medication_rounded, width: 90),
                SizedBox(height: 12),
                _ItemRow(icon: Icons.medication_liquid_rounded, width: 70),
                SizedBox(height: 12),
                _ItemRow(icon: Icons.medical_services_rounded, width: 80),
              ],
            ),
          ),
        ),
        Positioned(
          right: 6,
          bottom: 14,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_rounded,
              color: context.colors.onPrimary,
              size: 30,
            ),
          ),
        ),
        const Positioned(left: 4, top: 0, child: BrandLogo(size: 48)),
      ],
    );
  }
}

class _PlanScene extends StatelessWidget {
  const _PlanScene();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget day(String n, {bool selected = false}) => Container(
      width: 40,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? colors.primary : colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        n,
        style: context.text.titleMedium?.copyWith(
          color: selected ? colors.onPrimary : colors.onSurface,
        ),
      ),
    );
    Widget check(bool done) => Icon(
      done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
      color: done ? context.status.success : colors.outline,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            day('16'),
            day('17'),
            day('18', selected: true),
            day('19'),
            day('20'),
          ],
        ),
        const SizedBox(height: 14),
        _Panel(
          child: Column(
            children: [
              _ItemRow(
                icon: Icons.medication_rounded,
                width: 80,
                trailing: check(true),
              ),
              const SizedBox(height: 12),
              _ItemRow(
                icon: Icons.medication_liquid_rounded,
                width: 64,
                trailing: check(false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressScene extends StatelessWidget {
  const _ProgressScene();

  @override
  Widget build(BuildContext context) {
    final status = context.status;
    Widget pill(IconData icon, Color bg, Color fg, double w) => Container(
      width: w,
      height: 30,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Container(
            width: w * 0.4,
            height: 7,
            decoration: BoxDecoration(
              color: fg.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
    return Center(
      child: _Panel(
        padding: 20,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProgressRing(
              value: 0.75,
              label: context.l10n.percentValue(0.75),
              size: 110,
              strokeWidth: 11,
            ),
            const SizedBox(width: 18),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pill(
                  Icons.check_rounded,
                  status.successContainer,
                  status.success,
                  96,
                ),
                const SizedBox(height: 10),
                pill(
                  Icons.do_not_disturb_on_outlined,
                  status.warningContainer,
                  status.warning,
                  80,
                ),
                const SizedBox(height: 10),
                const _Bar(width: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
