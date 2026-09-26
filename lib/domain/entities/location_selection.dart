import 'package:meta/meta.dart';

import 'city.dart';
import 'geo.dart';

/// What the user chose as their location. Persisted locally.
@immutable
sealed class LocationSelection {
  const LocationSelection();
}

/// A city picked manually from the bundled list.
final class CityLocationSelection extends LocationSelection {
  const CityLocationSelection(this.cityId);

  final String cityId;

  @override
  bool operator ==(Object other) => other is CityLocationSelection && other.cityId == cityId;

  @override
  int get hashCode => cityId.hashCode;
}

/// A GPS fix, cached so the app keeps working with GPS off or offline.
final class GpsLocationSelection extends LocationSelection {
  const GpsLocationSelection({
    required this.coordinates,
    required this.timezone,
    required this.capturedAt,
  });

  final GeoCoordinates coordinates;

  /// IANA timezone id of the device when the fix was taken.
  final String timezone;
  final DateTime capturedAt;

  @override
  bool operator ==(Object other) =>
      other is GpsLocationSelection &&
      other.coordinates == coordinates &&
      other.timezone == timezone &&
      other.capturedAt == capturedAt;

  @override
  int get hashCode => Object.hash(coordinates, timezone, capturedAt);
}

/// A location ready for calculations: coordinates, zone and a display source.
@immutable
class ResolvedLocation {
  const ResolvedLocation({
    required this.coordinates,
    required this.timezone,
    this.city,
  });

  final GeoCoordinates coordinates;
  final String timezone;

  /// The selected city, or `null` when the location came from GPS.
  final City? city;

  bool get isGps => city == null;

  @override
  bool operator ==(Object other) =>
      other is ResolvedLocation &&
      other.coordinates == coordinates &&
      other.timezone == timezone &&
      other.city == city;

  @override
  int get hashCode => Object.hash(coordinates, timezone, city);
}
