import 'package:meta/meta.dart';

/// A date in the Hijri (Umm al-Qura) calendar.
@immutable
class HijriDate {
  const HijriDate(this.year, this.month, this.day)
      : assert(month >= 1 && month <= 12),
        assert(day >= 1 && day <= 30);

  final int year;
  final int month;
  final int day;

  @override
  bool operator ==(Object other) =>
      other is HijriDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => '$day/$month/${year}H';
}
