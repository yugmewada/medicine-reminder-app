import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_tokens.dart';

/// Doseza mark: a tilted two-tone capsule, drawn in code.
///
/// Placeholder until an official vector logo exists; replace the painter
/// with the exported asset when it does.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = AppSizes.logo,
    this.color,
    this.accent,
  });

  final double size;

  /// Main half. Defaults to `colorScheme.primary`.
  final Color? color;

  /// Second half. Defaults to a lighter tint of [color].
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final main = color ?? Theme.of(context).colorScheme.primary;
    return Semantics(
      label: context.l10n.logoLabel(context.l10n.appTitle),
      image: true,
      child: CustomPaint(
        size: Size.square(size),
        painter: _CapsulePainter(
          main: main,
          accent: accent ?? main.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}

class _CapsulePainter extends CustomPainter {
  const _CapsulePainter({required this.main, required this.accent});

  final Color main;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    canvas
      ..save()
      ..translate(s / 2, s / 2)
      ..rotate(-math.pi / 4);

    final length = s * 0.92;
    final width = s * 0.40;
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: length, height: width),
      Radius.circular(width / 2),
    );

    canvas.save();
    canvas.clipRRect(body);
    canvas.drawRect(
      Rect.fromLTRB(-length / 2, -width / 2, 0, width / 2),
      Paint()..color = main,
    );
    canvas.drawRect(
      Rect.fromLTRB(0, -width / 2, length / 2, width / 2),
      Paint()..color = accent,
    );
    canvas.restore();

    // Highlight on the main half.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          -length * 0.36,
          -width * 0.26,
          length * 0.22,
          width * 0.14,
        ),
        Radius.circular(width * 0.07),
      ),
      Paint()..color = const Color(0x59FFFFFF),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CapsulePainter old) =>
      old.main != main || old.accent != accent;
}
