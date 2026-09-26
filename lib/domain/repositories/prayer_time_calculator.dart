import '../entities/geo.dart';
import '../entities/location_selection.dart';
import '../entities/prayer_day.dart';
import '../entities/prayer_settings.dart';

/// Computes prayer times on the device from astronomy — never from an API.
abstract interface class PrayerTimeCalculator {
  PrayerDay compute({
    required CalendarDate date,
    required ResolvedLocation location,
    required PrayerSettings settings,
  });

  /// Today's calendar date as seen in [timezone] at [instant].
  CalendarDate dateIn(String timezone, DateTime instant);
}
