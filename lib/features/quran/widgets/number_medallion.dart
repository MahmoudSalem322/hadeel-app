import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';
import '../../../shared/extensions/context_x.dart';

/// A quiet eight-point star outline holding a number — used for surah,
/// juz' and ayah numbers. A single geometric motif instead of heavy
/// ornament.
class NumberMedallion extends StatelessWidget {
  const NumberMedallion({super.key, required this.label, this.size = 40, this.semanticLabel});

  final String label;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final medallion = SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _StarPainter(color: context.brand.gold),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            textScaler: TextScaler.noScaling,
            style: context.text.labelMedium!.copyWith(
              color: context.colors.onSurface,
              fontSize: size * (label.length > 2 ? 0.28 : 0.33),
              fontWeight: FontWeight.w600,
              height: 1,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ),
      ),
    );
    if (semanticLabel == null) return ExcludeSemantics(child: medallion);
    return Semantics(label: semanticLabel, excludeSemantics: true, child: medallion);
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final side = size.shortestSide * 0.66;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.035
      ..strokeJoin = StrokeJoin.round;
    final square = Rect.fromCenter(center: Offset.zero, width: side, height: side);

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.drawRect(square, paint);
    canvas.rotate(math.pi / 4);
    canvas.drawRect(square, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color;
}
