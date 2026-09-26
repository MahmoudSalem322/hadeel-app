import 'package:meta/meta.dart';

/// A point on Earth in decimal degrees.
@immutable
class GeoCoordinates {
  const GeoCoordinates(this.latitude, this.longitude)
      : assert(latitude >= -90 && latitude <= 90),
        assert(longitude >= -180 && longitude <= 180);

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) =>
      other is GeoCoordinates && other.latitude == latitude && other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'GeoCoordinates($latitude, $longitude)';
}

/// A calendar day with no time or zone attached.
@immutable
class CalendarDate implements Comparable<CalendarDate> {
  const CalendarDate(this.year, this.month, this.day);

  /// The calendar day of [dateTime] as seen in its own zone.
  factory CalendarDate.of(DateTime dateTime) =>
      CalendarDate(dateTime.year, dateTime.month, dateTime.day);

  final int year;
  final int month;
  final int day;

  CalendarDate addDays(int days) {
    final shifted = DateTime.utc(year, month, day + days);
    return CalendarDate(shifted.year, shifted.month, shifted.day);
  }

  @override
  int compareTo(CalendarDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is CalendarDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
