import 'package:meta/meta.dart';

import 'quran.dart';

/// What a favorite points to. Keys are stable ids within each kind
/// (e.g. `2:255` for an ayah).
enum FavoriteKind { ayah, dhikr, dua, hadith }

@immutable
class FavoriteItem {
  const FavoriteItem({required this.kind, required this.key, required this.createdAt});

  final FavoriteKind kind;
  final String key;
  final DateTime createdAt;
}

@immutable
class Bookmark {
  const Bookmark({required this.ref, required this.createdAt});

  final AyahRef ref;
  final DateTime createdAt;
}

@immutable
class TasbeehCounter {
  const TasbeehCounter({required this.phraseKey, this.count = 0, this.total = 0, this.target = 33});

  static const List<int> targets = [33, 99, 100, 0]; // 0 = no limit

  final String phraseKey;

  /// Current count toward [target].
  final int count;

  /// Lifetime total for this phrase.
  final int total;

  /// 0 means open-ended counting.
  final int target;

  bool get hasTarget => target > 0;

  /// Completed rounds of [target] within the lifetime total.
  int get rounds => hasTarget ? total ~/ target : 0;

  double get progress => hasTarget ? (count / target).clamp(0.0, 1.0) : 0;

  TasbeehCounter increment() {
    final next = hasTarget && count >= target ? 1 : count + 1;
    return TasbeehCounter(phraseKey: phraseKey, count: next, total: total + 1, target: target);
  }

  TasbeehCounter reset() => TasbeehCounter(phraseKey: phraseKey, total: total, target: target);

  TasbeehCounter withTarget(int value) =>
      TasbeehCounter(phraseKey: phraseKey, count: 0, total: total, target: value);

  @override
  bool operator ==(Object other) =>
      other is TasbeehCounter &&
      other.phraseKey == phraseKey &&
      other.count == count &&
      other.total == total &&
      other.target == target;

  @override
  int get hashCode => Object.hash(phraseKey, count, total, target);
}

/// Position in an adhkar category for one day.
@immutable
class AdhkarSession {
  const AdhkarSession({required this.categoryKey, required this.itemIndex, required this.count});

  final String categoryKey;
  final int itemIndex;

  /// Repetitions done for the item at [itemIndex].
  final int count;
}

/// Last place the reader stopped.
@immutable
class ReadingPosition {
  const ReadingPosition({required this.ref, required this.updatedAt});

  final AyahRef ref;
  final DateTime updatedAt;
}
