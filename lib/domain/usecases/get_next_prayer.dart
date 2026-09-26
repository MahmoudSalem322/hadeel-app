import '../entities/geo.dart';
import '../entities/location_selection.dart';
import '../entities/next_prayer.dart';
import '../entities/prayer_day.dart';
import '../entities/prayer_settings.dart';
import '../repositories/prayer_time_calculator.dart';
import 'resolve_next_prayer.dart';

/// Computes yesterday/today/tomorrow at [ResolvedLocation] and resolves the
/// next prayer.
class GetNextPrayer {
  const GetNextPrayer(this._calculator);

  final PrayerTimeCalculator _calculator;

  NextPrayer call({
    required DateTime now,
    required ResolvedLocation location,
    required PrayerSettings settings,
  }) {
    final today = _calculator.dateIn(location.timezone, now);

    PrayerDay dayAt(CalendarDate date) =>
        _calculator.compute(date: date, location: location, settings: settings);

    return resolveNextPrayer(
      now: now,
      yesterday: dayAt(today.addDays(-1)),
      today: dayAt(today),
      tomorrow: dayAt(today.addDays(1)),
    );
  }
}
