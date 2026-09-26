import 'package:meta/meta.dart';

import 'geo.dart';
import 'prayer.dart';

/// Prayer times for one calendar day at one location.
///
/// Times are absolute instants whose wall-clock fields are expressed in the
/// location's timezone (they are `TZDateTime`s at runtime).
@immutable
class PrayerDay {
  PrayerDay({required this.date, required Map<Prayer, DateTime> times})
      : assert(times.length == Prayer.values.length),
        _times = Map.unmodifiable(times);

  final CalendarDate date;
  final Map<Prayer, DateTime> _times;

  DateTime timeOf(Prayer prayer) => _times[prayer]!;

  /// All six markers in chronological order.
  List<MapEntry<Prayer, DateTime>> get entries =>
      [for (final p in Prayer.values) MapEntry(p, _times[p]!)];
}
