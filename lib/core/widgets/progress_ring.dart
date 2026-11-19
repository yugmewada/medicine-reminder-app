import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Circular progress with a centered label. Animates between values unless
/// reduced motion is on. Purely visual: give the surrounding widget the
/// accessible description.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.label,
    this.size = 88,
    this.strokeWidth = 9,
  });

  /// 0..1
  final double value;
  final String label;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1)),
          duration: AppMotion.of(context, AppMotion.long),
          curve: AppMotion.emphasized,
          builder: (context, animated, child) => CustomPaint(
            painter: _RingPainter(
              value: animated,
              track: colors.surfaceContainerHighest,
              fill: colors.primary,
              strokeWidth: strokeWidth,
            ),
            child: child,
          ),
          child: Center(
            child: FittedBox(
              child: Padding(
                padding: EdgeInsets.all(strokeWidth + 2),
                child: Text(label, style: context.text.titleLarge),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.track,
    required this.fill,
    required this.strokeWidth,
  });

  final double value;
  final Color track;
  final Color fill;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        paint..color = fill,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.track != track ||
      old.fill != fill ||
      old.strokeWidth != strokeWidth;
}
