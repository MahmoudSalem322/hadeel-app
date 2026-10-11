import 'package:intl/intl.dart';

import '../../domain/entities/geo.dart';

/// Locale-aware formatting for times, dates, numbers and countdowns.
///
/// Times are formatted from their own wall-clock fields, so a `TZDateTime`
/// prints in its location's zone, not the device's.
class AppFormatters {
  /// Digits are Western (0–9) everywhere, matching common usage in
  /// Palestine. intl's `ar` dates default to Eastern digits while its `ar`
  /// numbers use Western ones, so dates are aligned explicitly. An
  /// Eastern-digits option can become a setting later.
  AppFormatters(this.locale)
    : _time = DateFormat.jm(locale)..useNativeDigits = false,
      _gregorian = DateFormat.yMMMMEEEEd(locale)..useNativeDigits = false,
      _shortDate = DateFormat.yMMMMd(locale)..useNativeDigits = false,
      _twoDigits = NumberFormat('00', locale),
      _number = NumberFormat.decimalPattern(locale);

  final String locale;
  final DateFormat _time;
  final DateFormat _gregorian;
  final DateFormat _shortDate;
  final NumberFormat _twoDigits;
  final NumberFormat _number;

  String time(DateTime value) => _time.format(value);

  String dateAndTime(DateTime value) =>
      '${_shortDate.format(value)}، ${_time.format(value)}';

  String gregorianDate(CalendarDate date) =>
      _gregorian.format(DateTime(date.year, date.month, date.day));

  String number(int value) => _number.format(value);

  /// `HH:MM:SS`, hours unbounded, e.g. `01:24:32`.
  String countdown(Duration value) {
    final d = value.isNegative ? Duration.zero : value;
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${_twoDigits.format(h)}:${_twoDigits.format(m)}:${_twoDigits.format(s)}';
  }
}
