import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The Hadeel mark: a crescent cradling a single dove wing (هديل is the
/// cooing of doves). Drawn in code so one source feeds the app, the splash
/// and the generated launcher icons.
class HadeelLogo extends StatelessWidget {
  const HadeelLogo({
    super.key,
    this.size = 96,
    this.withBackground = true,
    this.markColor = AppColors.gold,
    this.backgroundColor = AppColors.primary,
    this.semanticLabel,
  });

  final double size;
  final bool withBackground;
  final Color markColor;
  final Color backgroundColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: HadeelLogoPainter(
            markColor: markColor,
            backgroundColor: withBackground ? backgroundColor : null,
          ),
        ),
      ),
    );
  }
}

class HadeelLogoPainter extends CustomPainter {
  const HadeelLogoPainter({
    required this.markColor,
    this.backgroundColor,
    this.markScale = 1,
  });

  final Color markColor;

  /// Rounded-square tile behind the mark; `null` draws the mark alone.
  final Color? backgroundColor;

  /// Shrinks the mark inside the canvas (adaptive icons need a safe zone).
  final double markScale;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final u = s / 100; // design grid: 100 × 100

    if (backgroundColor != null) {
      final tile = RRect.fromRectAndRadius(Offset.zero & Size.square(s), Radius.circular(22 * u));
      canvas.drawRRect(tile, Paint()..color = backgroundColor!);
    }

    canvas.save();
    canvas.translate(s / 2, s / 2);
    canvas.scale(markScale);
    canvas.translate(-s / 2, -s / 2);

    final paint = Paint()
      ..color = markColor
      ..isAntiAlias = true;

    // Crescent: outer disc minus an offset disc, opening towards the
    // upper-leading corner.
    final outer = Path()..addOval(Rect.fromCircle(center: Offset(47 * u, 53 * u), radius: 31 * u));
    final inner = Path()..addOval(Rect.fromCircle(center: Offset(60 * u, 43 * u), radius: 26 * u));
    canvas.drawPath(Path.combine(PathOperation.difference, outer, inner), paint);

    // Dove wing: a long leaf rising from the crescent's inner curve...
    // Both shapes float in the crescent's hollow with a small gap, so the
    // mark stays crisp at launcher-icon sizes.
    final wing = Path()
      ..moveTo(52 * u, 60 * u)
      ..cubicTo(59 * u, 47 * u, 70 * u, 35 * u, 86 * u, 24 * u)
      ..cubicTo(81 * u, 40 * u, 72 * u, 52 * u, 57 * u, 62 * u)
      ..quadraticBezierTo(53 * u, 63 * u, 52 * u, 60 * u)
      ..close();
    canvas.drawPath(wing, paint);

    // ...and a shorter second feather beneath it for a sense of flight.
    final feather = Path()
      ..moveTo(60 * u, 64 * u)
      ..cubicTo(66 * u, 58 * u, 74 * u, 53 * u, 84 * u, 49 * u)
      ..cubicTo(79 * u, 57 * u, 72 * u, 63 * u, 64 * u, 66 * u)
      ..quadraticBezierTo(60 * u, 67 * u, 60 * u, 64 * u)
      ..close();
    canvas.drawPath(feather, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(HadeelLogoPainter oldDelegate) =>
      oldDelegate.markColor != markColor ||
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.markScale != markScale;
}
