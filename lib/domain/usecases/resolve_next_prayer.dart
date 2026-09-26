import '../entities/next_prayer.dart';
import '../entities/prayer.dart';
import '../entities/prayer_day.dart';

/// Finds the next obligatory prayer after [now].
///
/// [yesterday] supplies the previous Isha before Fajr, and [tomorrow]
/// supplies Fajr once today's Isha has passed. A prayer whose time equals
/// [now] counts as arrived, so the countdown moves on at exactly 00:00:00.
NextPrayer resolveNextPrayer({
  required DateTime now,
  required PrayerDay yesterday,
  required PrayerDay today,
  required PrayerDay tomorrow,
}) {
  final timeline = <MapEntry<Prayer, DateTime>>[
    MapEntry(Prayer.isha, yesterday.timeOf(Prayer.isha)),
    for (final p in Prayer.obligatory) MapEntry(p, today.timeOf(p)),
    MapEntry(Prayer.fajr, tomorrow.timeOf(Prayer.fajr)),
  ];

  for (var i = 1; i < timeline.length; i++) {
    final candidate = timeline[i];
    if (now.isBefore(candidate.value)) {
      final previous = timeline[i - 1];
      return NextPrayer(
        prayer: candidate.key,
        time: candidate.value,
        previousPrayer: previous.key,
        previousTime: previous.value,
      );
    }
  }

  // Only reachable if [now] is after tomorrow's Fajr, i.e. the caller passed
  // stale days. Fall back to tomorrow's Fajr rather than throwing in the UI.
  final last = timeline.last;
  return NextPrayer(
    prayer: last.key,
    time: last.value,
    previousPrayer: timeline[timeline.length - 2].key,
    previousTime: timeline[timeline.length - 2].value,
  );
}
