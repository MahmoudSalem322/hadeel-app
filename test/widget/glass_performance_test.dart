import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/shared/widgets/app_shell.dart';
import 'package:hadeel/shared/widgets/liquid_glass.dart';

int blurLayers(Layer layer) {
  var count = layer is BackdropFilterLayer ? 1 : 0;
  if (layer is ContainerLayer) {
    var child = layer.firstChild;
    while (child != null) {
      count += blurLayers(child);
      child = child.nextSibling;
    }
  }
  return count;
}

class _PaintProbe extends CustomPainter {
  _PaintProbe(this.onPaint);
  final VoidCallback onPaint;
  @override
  void paint(Canvas canvas, Size size) => onPaint();
  @override
  bool shouldRepaint(_PaintProbe oldDelegate) => true;
}

void main() {
  testWidgets('a glass grid does not multiply live GPU blur passes', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const LiquidGlass(
                blur: 8,
                child: SizedBox(height: 48, width: 300),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  children: List.generate(
                    24,
                    (i) => LiquidGlass(child: Center(child: Text('$i'))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final layers = blurLayers(tester.binding.renderViews.single.debugLayer!);
    expect(
      layers,
      1,
      reason: 'only the overlay needs to sample the live backdrop',
    );
  });
  testWidgets(
    'switching tabs paints the destination without painting the old screen',
    (tester) async {
      var oldPaints = 0;
      var newPaints = 0;
      final children = [
        CustomPaint(
          painter: _PaintProbe(() => oldPaints++),
          child: const Text('old'),
        ),
        CustomPaint(
          painter: _PaintProbe(() => newPaints++),
          child: const Text('new'),
        ),
      ];
      Widget app(int index) => MaterialApp(
        home: AnimatedBranchContainer(currentIndex: index, children: children),
      );
      await tester.pumpWidget(app(0));
      final before = oldPaints;
      await tester.pumpWidget(app(1));
      await tester.pump(const Duration(milliseconds: 16));
      expect(
        oldPaints,
        before,
        reason: 'outgoing page must not be composited during the switch',
      );
      expect(newPaints, greaterThan(0));
      expect(find.text('old'), findsNothing);
      expect(find.text('new'), findsOneWidget);
      await tester.pumpWidget(app(0));
      expect(find.text('old'), findsOneWidget);
    },
  );
}
