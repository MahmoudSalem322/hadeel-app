import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The crescent-and-ripple artwork shared by the app and launcher.
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
        child: withBackground
            ? ClipRRect(
                borderRadius: BorderRadius.circular(size * .24),
                child: Image.asset(
                  'assets/branding/icon_v4.png',
                  fit: BoxFit.cover,
                  cacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                      .round(),
                ),
              )
            : CustomPaint(
                painter: HadeelLogoPainter(
                  markColor: markColor,
                  backgroundColor: null,
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
      final tile = RRect.fromRectAndRadius(
        Offset.zero & Size.square(s),
        Radius.circular(22 * u),
      );
      canvas.drawRRect(tile, Paint()..color = backgroundColor!);
    }

    canvas.save();
    canvas.translate(s / 2, s / 2);
    canvas.scale(markScale);
    canvas.translate(-s / 2, -s / 2);

    final paint = Paint()
      ..color = markColor
      ..isAntiAlias = true;

    // Crescent opening toward a remembrance dot and two gentle sound waves.
    final outer = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(45 * u, 51 * u), radius: 35 * u),
      );
    final inner = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(57 * u, 41 * u), radius: 30 * u),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, outer, inner),
      paint,
    );

    canvas.drawCircle(Offset(57 * u, 52 * u), 7 * u, paint);
    final wavePaint = Paint()
      ..color = markColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * u
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(57 * u, 52 * u), radius: 18 * u),
      -0.95,
      1.9,
      false,
      wavePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(57 * u, 52 * u), radius: 29 * u),
      -0.9,
      1.8,
      false,
      wavePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(HadeelLogoPainter oldDelegate) =>
      oldDelegate.markColor != markColor ||
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.markScale != markScale;
}
