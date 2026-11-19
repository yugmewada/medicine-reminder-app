import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';

/// App mark drawn in code, traced from the design screenshot.
///
/// Replace with the official vector asset once it is exported from Figma.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = AppSizes.logo, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'App logo',
      image: true,
      child: CustomPaint(
        size: Size.square(size),
        painter: _BrandLogoPainter(
          color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _BrandLogoPainter extends CustomPainter {
  const _BrandLogoPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path polygon(List<(double, double)> points) {
      final path = Path()
        ..moveTo(points.first.$1 * size.width, points.first.$2 * size.height);
      for (final (x, y) in points.skip(1)) {
        path.lineTo(x * size.width, y * size.height);
      }
      return path..close();
    }

    final triangle = polygon([(0.5, 0.06), (0.955, 0.96), (0.045, 0.96)]);
    final chevronCut = polygon([
      (0.192, 0.819),
      (0.492, 0.228),
      (0.904, 1.05),
      (0.703, 1.05),
      (0.474, 0.461),
      (0.218, 0.839),
    ]);

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawPath(triangle, Paint()..color = color);
    canvas.drawPath(
      triangle,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.08
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(chevronCut, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BrandLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
