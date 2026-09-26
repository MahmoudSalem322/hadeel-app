import 'package:meta/meta.dart';

/// Pure state machine for reading a list of adhkar, each said [repeats]
/// times. Tapping counts one repetition; finishing an item moves to the next;
/// finishing the last item marks the session complete.
@immutable
class AdhkarCounter {
  /// [repeats] must not be empty (callers skip empty categories).
  const AdhkarCounter({required this.repeats, this.index = 0, this.count = 0, this.completed = false});

  /// Restores a saved position, clamping anything out of range.
  factory AdhkarCounter.restore(List<int> repeats, {required int index, required int count}) {
    if (index >= repeats.length) {
      return AdhkarCounter(repeats: repeats, index: repeats.length - 1, count: repeats.last, completed: true);
    }
    final i = index.clamp(0, repeats.length - 1);
    return AdhkarCounter(repeats: repeats, index: i, count: count.clamp(0, repeats[i] - 1));
  }

  final List<int> repeats;
  final int index;

  /// Repetitions done for the current item.
  final int count;
  final bool completed;

  int get total => repeats.length;
  int get target => repeats[index];
  bool get isFirst => index == 0;
  bool get isLast => index == total - 1;

  /// Share of the whole session done, in `[0, 1]`.
  double get overallProgress {
    if (completed) return 1;
    final done = repeats.take(index).fold<int>(0, (a, b) => a + b) + count;
    final all = repeats.fold<int>(0, (a, b) => a + b);
    return done / all;
  }

  /// Share of the current item done.
  double get itemProgress => completed ? 1 : count / target;

  AdhkarCounter tap() {
    if (completed) return this;
    final next = count + 1;
    if (next < target) return _copy(count: next);
    if (isLast) return _copy(count: target, completed: true);
    return _copy(index: index + 1, count: 0);
  }

  AdhkarCounter goTo(int i) {
    final target = i.clamp(0, total - 1);
    return AdhkarCounter(repeats: repeats, index: target);
  }

  AdhkarCounter next() => isLast ? _copy(count: target, completed: true) : goTo(index + 1);

  AdhkarCounter previous() => goTo(index - 1);

  AdhkarCounter resetItem() => _copy(count: 0, completed: false);

  AdhkarCounter restart() => AdhkarCounter(repeats: repeats);

  AdhkarCounter _copy({int? index, int? count, bool? completed}) => AdhkarCounter(
        repeats: repeats,
        index: index ?? this.index,
        count: count ?? this.count,
        completed: completed ?? this.completed,
      );

  @override
  bool operator ==(Object other) =>
      other is AdhkarCounter &&
      other.index == index &&
      other.count == count &&
      other.completed == completed &&
      other.repeats.length == repeats.length;

  @override
  int get hashCode => Object.hash(index, count, completed, repeats.length);
}
