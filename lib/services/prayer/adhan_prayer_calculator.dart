import 'package:adhan/adhan.dart' as adhan;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/geo.dart';
import '../../domain/entities/location_selection.dart';
import '../../domain/entities/prayer.dart';
import '../../domain/entities/prayer_day.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/repositories/prayer_time_calculator.dart';

/// [PrayerTimeCalculator] backed by the `adhan` package (a port of the
/// Batoul Apps Adhan library). Everything runs locally.
///
/// This is the only file that imports `adhan`; the rest of the app sees
/// domain types. Times come back as UTC instants and are converted to
/// [tz.TZDateTime] in the location's IANA zone, so DST is handled by the
/// bundled tz database rather than the device clock.
class AdhanPrayerCalculator implements PrayerTimeCalculator {
  const AdhanPrayerCalculator();

  @override
  PrayerDay compute({
    required CalendarDate date,
    required ResolvedLocation location,
    required PrayerSettings settings,
  }) {
    final zone = resolveZone(location.timezone);
    final params = _parameters(settings);
    final times = adhan.PrayerTimes.utc(
      adhan.Coordinates(location.coordinates.latitude, location.coordinates.longitude),
      adhan.DateComponents(date.year, date.month, date.day),
      params,
    );

    tz.TZDateTime inZone(DateTime utc) => tz.TZDateTime.from(utc, zone);

    return PrayerDay(
      date: date,
      times: {
        Prayer.fajr: inZone(times.fajr),
        Prayer.sunrise: inZone(times.sunrise),
        Prayer.dhuhr: inZone(times.dhuhr),
        Prayer.asr: inZone(times.asr),
        Prayer.maghrib: inZone(times.maghrib),
        Prayer.isha: inZone(times.isha),
      },
    );
  }

  @override
  CalendarDate dateIn(String timezone, DateTime instant) {
    final local = tz.TZDateTime.from(instant, resolveZone(timezone));
    return CalendarDate(local.year, local.month, local.day);
  }

  /// Looks up an IANA zone, falling back to UTC for `UTC` (not a named entry
  /// in the tz database) or any unknown id, so bad stored data never crashes.
  static tz.Location resolveZone(String id) {
    if (id == 'UTC' || id == 'Etc/UTC') return tz.UTC;
    try {
      return tz.getLocation(id);
    } on tz.LocationNotFoundException {
      return tz.UTC;
    }
  }

  adhan.CalculationParameters _parameters(PrayerSettings settings) {
    final params = _method(settings.method).getParameters();
    params.madhab = switch (settings.madhab) {
      AsrMadhab.shafi => adhan.Madhab.shafi,
      AsrMadhab.hanafi => adhan.Madhab.hanafi,
    };
    return params;
  }

  adhan.CalculationMethod _method(CalculationMethodType type) => switch (type) {
        CalculationMethodType.egyptian => adhan.CalculationMethod.egyptian,
        CalculationMethodType.muslimWorldLeague => adhan.CalculationMethod.muslim_world_league,
        CalculationMethodType.ummAlQura => adhan.CalculationMethod.umm_al_qura,
        CalculationMethodType.karachi => adhan.CalculationMethod.karachi,
        CalculationMethodType.northAmerica => adhan.CalculationMethod.north_america,
        CalculationMethodType.dubai => adhan.CalculationMethod.dubai,
        CalculationMethodType.kuwait => adhan.CalculationMethod.kuwait,
        CalculationMethodType.qatar => adhan.CalculationMethod.qatar,
        CalculationMethodType.turkey => adhan.CalculationMethod.turkey,
        CalculationMethodType.singapore => adhan.CalculationMethod.singapore,
        CalculationMethodType.moonSightingCommittee =>
          adhan.CalculationMethod.moon_sighting_committee,
      };
}
