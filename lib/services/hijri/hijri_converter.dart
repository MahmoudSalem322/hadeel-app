import 'package:hijri/hijri_calendar.dart';

import '../../domain/entities/geo.dart';
import '../../domain/entities/hijri_date.dart';

/// Gregorian ↔ Hijri using the Umm al-Qura tables bundled in `hijri`.
///
/// [dayAdjustment] shifts the Hijri calendar to match local moon sighting:
/// +1 means the Hijri date is one day ahead of Umm al-Qura.
class HijriConverter {
  const HijriConverter({this.dayAdjustment = 0});

  final int dayAdjustment;

  HijriDate fromGregorian(CalendarDate date) {
    final shifted = DateTime(date.year, date.month, date.day + dayAdjustment);
    final h = HijriCalendar.fromDate(shifted);
    return HijriDate(h.hYear, h.hMonth, h.hDay);
  }

  /// Gregorian date on which Hijri [date] falls.
  CalendarDate toGregorian(HijriDate date) {
    final g = HijriCalendar().hijriToGregorian(date.year, date.month, date.day);
    return CalendarDate.of(g).addDays(-dayAdjustment);
  }

  /// 29 or 30.
  int monthLength(int year, int month) => HijriCalendar().getDaysInMonth(year, month);

  /// Month before/after (year, month) by [delta] months.
  static (int, int) shiftMonth(int year, int month, int delta) {
    final index = year * 12 + (month - 1) + delta;
    return (index ~/ 12, index % 12 + 1);
  }
}
