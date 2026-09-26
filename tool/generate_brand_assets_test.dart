// Renders the HadeelLogo painter to the PNGs consumed by
// flutter_launcher_icons and flutter_native_splash.
//
// Run: flutter test tool/generate_brand_assets_test.dart
// Then: dart run flutter_launcher_icons && dart run flutter_native_splash:create
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/theme/app_colors.dart';
import 'package:hadeel/shared/widgets/hadeel_logo.dart';

Future<void> _render(String path, int size, CustomPainter painter) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  painter.paint(canvas, Size.square(size.toDouble()));
  final image = await recorder.endRecording().toImage(size, size);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File(path)..createSync(recursive: true);
  file.writeAsBytesSync(bytes!.buffer.asUint8List());
}

void main() {
  test('generate brand assets', () async {
    // iOS / legacy Android: full-bleed square (iOS applies its own mask).
    await _render(
      'assets/branding/icon_1024.png',
      1024,
      const _FullBleedIconPainter(),
    );
    // Android adaptive foreground: mark inside the 66% safe zone.
    await _render(
      'assets/branding/icon_foreground.png',
      1024,
      const HadeelLogoPainter(markColor: AppColors.gold, markScale: 0.62),
    );
    // Native splash: the tile at a comfortable size on a transparent canvas.
    await _render(
      'assets/branding/splash_logo.png',
      768,
      const _SplashPainter(),
    );
  });
}

class _FullBleedIconPainter extends CustomPainter {
  const _FullBleedIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.primary);
    const HadeelLogoPainter(markColor: AppColors.gold, markScale: 0.8).paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SplashPainter extends CustomPainter {
  const _SplashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Android 12 crops the splash icon to a circle of 2/3 the canvas, so
    // the tile sits well inside that.
    final tile = size.shortestSide * 0.5;
    canvas.translate((size.width - tile) / 2, (size.height - tile) / 2);
    const HadeelLogoPainter(markColor: AppColors.gold, backgroundColor: AppColors.primary)
        .paint(canvas, Size.square(tile));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
