import 'package:hijri/hijri_calendar.dart';

import '../../domain/entities/geo.dart';
import '../../domain/entities/hijri_date.dart';

/// Gregorian → Hijri using the Umm al-Qura tables bundled in `hijri`.
///
/// [dayAdjustment] lets users align with local moon sighting (±1–2 days);
/// it is exposed in Settings in a later phase.
class HijriConverter {
  const HijriConverter({this.dayAdjustment = 0});

  final int dayAdjustment;

  HijriDate fromGregorian(CalendarDate date) {
    final shifted = DateTime(date.year, date.month, date.day + dayAdjustment);
    final h = HijriCalendar.fromDate(shifted);
    return HijriDate(h.hYear, h.hMonth, h.hDay);
  }
}
