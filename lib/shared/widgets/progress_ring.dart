import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Thin circular progress used by the prayer card and (later) tasbeeh.
/// Animates smoothly between values.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.color,
    required this.trackColor,
    this.size = 64,
    this.strokeWidth = 4,
    this.child,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double size;
  final double strokeWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: progress.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => CustomPaint(
          painter: _RingPainter(
            progress: value,
            color: color,
            trackColor: trackColor,
            strokeWidth: strokeWidth,
            rtl: Directionality.of(context) == TextDirection.rtl,
          ),
          child: child,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.rtl,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * math.pi, false, base..color = trackColor);
    if (progress <= 0) return;
    // Progress runs in reading direction: counter-clockwise for RTL.
    final sweep = 2 * math.pi * progress * (rtl ? -1 : 1);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, base..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.strokeWidth != strokeWidth ||
      old.rtl != rtl;
}
