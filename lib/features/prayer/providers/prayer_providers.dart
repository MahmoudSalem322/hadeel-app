import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../domain/entities/geo.dart';
import '../../../domain/entities/location_selection.dart';
import '../../../domain/entities/next_prayer.dart';
import '../../../domain/entities/prayer_day.dart';
import '../../../domain/usecases/get_next_prayer.dart';
import '../../settings/providers/settings_provider.dart';

/// The saved location turned into coordinates + zone, or `null` if unset.
final resolvedLocationProvider = Provider<ResolvedLocation?>((ref) {
  final selection = ref.watch(settingsProvider.select((s) => s.location));
  switch (selection) {
    case null:
      return null;
    case CityLocationSelection(:final cityId):
      final cities = ref.watch(citiesProvider);
      for (final city in cities) {
        if (city.id == cityId) {
          return ResolvedLocation(
            coordinates: city.coordinates,
            timezone: city.timezone,
            city: city,
          );
        }
      }
      return null;
    case GpsLocationSelection(:final coordinates, :final timezone):
      return ResolvedLocation(coordinates: coordinates, timezone: timezone);
  }
});

/// Today's date in the location's zone (device date when no location).
/// Only notifies when the date actually changes.
final todayDateProvider = Provider<CalendarDate>((ref) {
  final now = ref.watch(nowProvider);
  final location = ref.watch(resolvedLocationProvider);
  if (location == null) return CalendarDate.of(now);
  return ref.watch(prayerCalculatorProvider).dateIn(location.timezone, now);
});

final todayPrayerDayProvider = Provider<PrayerDay?>((ref) {
  final location = ref.watch(resolvedLocationProvider);
  if (location == null) return null;
  return ref.watch(prayerCalculatorProvider).compute(
        date: ref.watch(todayDateProvider),
        location: location,
        settings: ref.watch(settingsProvider.select((s) => s.prayer)),
      );
});

final nextPrayerProvider = NotifierProvider<NextPrayerNotifier, NextPrayer?>(NextPrayerNotifier.new);

/// Keeps the next prayer current. It recomputes only when the target time
/// is reached (or the clock jumps backwards), not on every tick.
class NextPrayerNotifier extends Notifier<NextPrayer?> {
  @override
  NextPrayer? build() {
    final location = ref.watch(resolvedLocationProvider);
    if (location == null) return null;
    final settings = ref.watch(settingsProvider.select((s) => s.prayer));
    final getNext = GetNextPrayer(ref.watch(prayerCalculatorProvider));
    final clock = ref.watch(clockProvider);

    NextPrayer compute(DateTime now) => getNext(now: now, location: location, settings: settings);

    ref.listen<DateTime>(nowProvider, (_, now) {
      final current = state;
      if (current == null || current.hasArrived(now) || now.isBefore(current.previousTime)) {
        state = compute(now);
      }
    });

    return compute(clock.now());
  }
}
