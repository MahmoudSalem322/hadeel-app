import 'package:meta/meta.dart';

import '../entities/location_selection.dart';
import '../entities/prayer.dart';
import '../entities/prayer_settings.dart';
import '../repositories/prayer_time_calculator.dart';

@immutable
class PlannedNotification {
  const PlannedNotification({required this.id, required this.prayer, required this.time});

  /// Stable per (day offset, prayer) so rescheduling replaces, not duplicates.
  final int id;
  final Prayer prayer;

  /// When to fire, in the location's zone.
  final DateTime time;
}

/// Plans local prayer notifications for the next [days] days (today
/// included), skipping times already past. Kept well below iOS's limit of
/// 64 pending notifications.
List<PlannedNotification> planPrayerNotifications({
  required DateTime now,
  required ResolvedLocation location,
  required PrayerSettings settings,
  required Set<Prayer> enabled,
  required PrayerTimeCalculator calculator,
  int days = 5,
}) {
  if (enabled.isEmpty) return const [];
  final today = calculator.dateIn(location.timezone, now);
  final planned = <PlannedNotification>[];
  for (var d = 0; d < days; d++) {
    final day = calculator.compute(date: today.addDays(d), location: location, settings: settings);
    for (final prayer in Prayer.obligatory) {
      if (!enabled.contains(prayer)) continue;
      final time = day.timeOf(prayer);
      if (!time.isAfter(now)) continue;
      planned.add(PlannedNotification(id: d * 10 + prayer.index, prayer: prayer, time: time));
    }
  }
  return planned;
}
