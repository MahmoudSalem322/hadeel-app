import 'package:meta/meta.dart';

/// Supported calculation conventions (fajr/isha angles or intervals).
enum CalculationMethodType {
  egyptian,
  muslimWorldLeague,
  ummAlQura,
  karachi,
  northAmerica,
  dubai,
  kuwait,
  qatar,
  turkey,
  singapore,
  moonSightingCommittee,
}

/// Juristic school for Asr: Shafi (shadow = 1×) or Hanafi (shadow = 2×).
enum AsrMadhab { shafi, hanafi }

@immutable
class PrayerSettings {
  const PrayerSettings({
    this.method = CalculationMethodType.egyptian,
    this.madhab = AsrMadhab.shafi,
  });

  static const PrayerSettings defaults = PrayerSettings();

  final CalculationMethodType method;
  final AsrMadhab madhab;

  PrayerSettings copyWith({CalculationMethodType? method, AsrMadhab? madhab}) =>
      PrayerSettings(method: method ?? this.method, madhab: madhab ?? this.madhab);

  @override
  bool operator ==(Object other) =>
      other is PrayerSettings && other.method == method && other.madhab == madhab;

  @override
  int get hashCode => Object.hash(method, madhab);
}
