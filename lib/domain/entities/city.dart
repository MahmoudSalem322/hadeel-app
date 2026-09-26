import 'package:meta/meta.dart';

import 'geo.dart';

/// A selectable city with the data needed for local prayer calculation.
@immutable
class City {
  const City({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.coordinates,
    required this.timezone,
    required this.region,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final GeoCoordinates coordinates;

  /// IANA timezone id, e.g. `Asia/Hebron`.
  final String timezone;

  /// Grouping key, e.g. `west_bank`, `gaza_strip`, `interior`.
  final String region;

  String localizedName(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;

  @override
  bool operator ==(Object other) => other is City && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
