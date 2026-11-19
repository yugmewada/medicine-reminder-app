import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/medicine.dart';

/// Icon for a [MedicineType]. Tablets and capsules are drawn, since the
/// Material icon set has no distinct glyphs for them.
class MedicineTypeGlyph extends StatelessWidget {
  const MedicineTypeGlyph({
    super.key,
    required this.type,
    this.size = 22,
    this.color,
  });

  final MedicineType type;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color =
        this.color ?? IconTheme.of(context).color ?? context.colors.onSurface;
    return ExcludeSemantics(
      child: switch (type) {
        MedicineType.liquid => Icon(
          Icons.medication_liquid_rounded,
          size: size,
          color: color,
        ),
        MedicineType.other => Icon(
          Icons.medical_services_rounded,
          size: size,
          color: color,
        ),
        _ => CustomPaint(
          size: Size.square(size),
          painter: _PillPainter(type: type, color: color),
        ),
      },
    );
  }
}

class _PillPainter extends CustomPainter {
  const _PillPainter({required this.type, required this.color});

  final MedicineType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final fill = Paint()..color = color;
    if (type == MedicineType.tablet) {
      // Layer so the score line cuts only the tablet, not the background.
      canvas
        ..saveLayer(Offset.zero & size, Paint())
        ..drawCircle(Offset(s / 2, s / 2), s * 0.40, fill)
        ..drawLine(
          Offset(s * 0.30, s * 0.70),
          Offset(s * 0.70, s * 0.30),
          Paint()
            ..blendMode = BlendMode.clear
            ..strokeWidth = s * 0.09,
        )
        ..restore();
      return;
    }
    canvas
      ..save()
      ..translate(s / 2, s / 2)
      ..rotate(-0.785);
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: s * 0.9, height: s * 0.42),
      Radius.circular(s * 0.21),
    );
    canvas
      ..drawRRect(
        body,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.09,
      )
      ..clipRRect(body)
      ..drawRect(Rect.fromLTRB(-s * 0.45, -s * 0.21, 0, s * 0.21), fill)
      ..restore();
  }

  @override
  bool shouldRepaint(_PillPainter old) =>
      old.type != type || old.color != color;
}

/// Medicine thumbnail: the user's photo if set, otherwise the type glyph on
/// a tinted tile.
class MedicineBadge extends StatelessWidget {
  const MedicineBadge({
    super.key,
    required this.medicine,
    this.size = AppSizes.iconBadge,
  });

  final Medicine medicine;
  final double size;

  /// Hero tag for the inventory → detail shared-element transition. Only
  /// the inventory tile and detail screen use it, so tags stay unique.
  static String heroTag(String medicineId) => 'medicine-badge-$medicineId';

  @override
  Widget build(BuildContext context) {
    final photo = medicine.photo;
    final colors = context.colors;
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox.square(
          dimension: size,
          child: photo != null
              ? Image.memory(
                  photo.bytes,
                  fit: BoxFit.cover,
                  cacheWidth: (size * 3).round(),
                  gaplessPlayback: true,
                )
              : ColoredBox(
                  color: colors.primaryContainer,
                  child: Center(
                    child: MedicineTypeGlyph(
                      type: medicine.type,
                      size: size * 0.5,
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
