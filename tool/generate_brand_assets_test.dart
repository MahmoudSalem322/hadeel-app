// Builds splash and web artwork from the launcher source.
// Run: flutter test tool/generate_brand_assets_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate splash and web icons from current brand artwork', () async {
    final codec = await ui.instantiateImageCodec(
      await File('assets/branding/icon_v4.png').readAsBytes(),
    );
    final frame = await codec.getNextFrame();
    final source = frame.image;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    // Keep the complete tile within Android 12's circular splash safe area.
    canvas.drawImageRect(
      source,
      ui.Rect.fromLTWH(0, 0, source.width.toDouble(), source.height.toDouble()),
      const ui.Rect.fromLTWH(192, 192, 384, 384),
      ui.Paint()..filterQuality = ui.FilterQuality.high,
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(768, 768);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File('assets/branding/splash_logo.png')
        .writeAsBytesSync(bytes!.buffer.asUint8List());
    image.dispose();

    Future<void> renderWebIcon(String path, int size) async {
      final iconRecorder = ui.PictureRecorder();
      final iconCanvas = ui.Canvas(iconRecorder);
      iconCanvas.drawImageRect(
        source,
        ui.Rect.fromLTWH(
          0,
          0,
          source.width.toDouble(),
          source.height.toDouble(),
        ),
        ui.Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        ui.Paint()..filterQuality = ui.FilterQuality.high,
      );
      final iconPicture = iconRecorder.endRecording();
      final icon = await iconPicture.toImage(size, size);
      final iconBytes = await icon.toByteData(format: ui.ImageByteFormat.png);
      File(path).writeAsBytesSync(iconBytes!.buffer.asUint8List());
      icon.dispose();
      iconPicture.dispose();
    }

    await renderWebIcon('web/favicon.png', 32);
    await renderWebIcon('web/icons/Icon-192.png', 192);
    await renderWebIcon('web/icons/Icon-512.png', 512);
    await renderWebIcon('web/icons/Icon-maskable-192.png', 192);
    await renderWebIcon('web/icons/Icon-maskable-512.png', 512);
    source.dispose();
    picture.dispose();
    codec.dispose();
  });
}
