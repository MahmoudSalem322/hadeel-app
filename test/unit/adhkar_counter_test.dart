import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/domain/entities/library.dart';
import 'package:hadeel/domain/usecases/adhkar_counter.dart';

void main() {
  group('AdhkarCounter', () {
    test('counts to the target, then advances to the next dhikr', () {
      var c = const AdhkarCounter(repeats: [3, 1, 2]);
      c = c.tap();
      expect((c.index, c.count), (0, 1));
      c = c.tap().tap();
      expect((c.index, c.count), (1, 0));
      c = c.tap();
      expect((c.index, c.count), (2, 0));
    });

    test('completes after the last repetition of the last dhikr', () {
      var c = const AdhkarCounter(repeats: [1, 2]);
      c = c.tap().tap().tap();
      expect(c.completed, isTrue);
      expect(c.overallProgress, 1);
      expect(c.tap(), c, reason: 'no counting after completion');
    });

    test('overall progress weighs repetitions', () {
      var c = const AdhkarCounter(repeats: [3, 1]);
      c = c.tap();
      expect(c.overallProgress, closeTo(0.25, 1e-9));
      expect(c.itemProgress, closeTo(1 / 3, 1e-9));
    });

    test('navigation, reset and restart', () {
      final c = const AdhkarCounter(repeats: [3, 3, 3]).tap();
      expect(c.next().index, 1);
      expect(c.next().count, 0);
      expect(c.previous().index, 0);
      expect(c.resetItem().count, 0);
      expect(c.goTo(99).index, 2);
      expect(c.goTo(2).next().completed, isTrue);
      expect(c.goTo(2).next().restart(), const AdhkarCounter(repeats: [3, 3, 3]));
    });

    test('restore clamps saved values', () {
      final c = AdhkarCounter.restore([3, 3], index: 1, count: 7);
      expect((c.index, c.count), (1, 2));
      expect(AdhkarCounter.restore([3, 3], index: 2, count: 0).completed, isTrue);
    });
  });

  group('TasbeehCounter', () {
    test('wraps after reaching the target and keeps the lifetime total', () {
      var t = const TasbeehCounter(phraseKey: 'subhanallah', target: 3);
      for (var i = 0; i < 3; i++) {
        t = t.increment();
      }
      expect(t.count, 3);
      expect(t.progress, 1);
      t = t.increment();
      expect(t.count, 1);
      expect(t.total, 4);
      expect(t.rounds, 1);
    });

    test('open-ended counting has no target', () {
      var t = const TasbeehCounter(phraseKey: 'x', target: 0);
      for (var i = 0; i < 150; i++) {
        t = t.increment();
      }
      expect(t.count, 150);
      expect(t.progress, 0);
      expect(t.rounds, 0);
    });

    test('reset keeps the total; changing target resets the count', () {
      const t = TasbeehCounter(phraseKey: 'x', count: 10, total: 50, target: 33);
      expect(t.reset().count, 0);
      expect(t.reset().total, 50);
      expect(t.withTarget(99).count, 0);
      expect(t.withTarget(99).target, 99);
    });
  });
}
