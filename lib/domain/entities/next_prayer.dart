import 'package:meta/meta.dart';

import 'prayer.dart';

/// The upcoming obligatory prayer and the one before it.
@immutable
class NextPrayer {
  const NextPrayer({
    required this.prayer,
    required this.time,
    required this.previousPrayer,
    required this.previousTime,
  });

  final Prayer prayer;
  final DateTime time;
  final Prayer previousPrayer;
  final DateTime previousTime;

  /// Time left until [time]; never negative.
  Duration remaining(DateTime now) {
    final diff = time.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  /// Share of the interval between the previous and next prayer that has
  /// elapsed, in `[0, 1]`.
  double progress(DateTime now) {
    final total = time.difference(previousTime).inSeconds;
    if (total <= 0) return 1;
    final elapsed = now.difference(previousTime).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  bool hasArrived(DateTime now) => !now.isBefore(time);

  @override
  bool operator ==(Object other) =>
      other is NextPrayer &&
      other.prayer == prayer &&
      other.time.isAtSameMomentAs(time) &&
      other.previousPrayer == previousPrayer &&
      other.previousTime.isAtSameMomentAs(previousTime);

  @override
  int get hashCode =>
      Object.hash(prayer, time.millisecondsSinceEpoch, previousPrayer, previousTime.millisecondsSinceEpoch);
}
