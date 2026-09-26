import '../../domain/entities/city.dart';
import '../../domain/entities/geo.dart';

/// JSON mapping for entries in `assets/data/cities_*.json`.
abstract final class CityModel {
  static City fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      coordinates: GeoCoordinates(
        (json['lat'] as num).toDouble(),
        (json['lng'] as num).toDouble(),
      ),
      timezone: json['tz'] as String,
      region: json['region'] as String,
    );
  }

  static List<City> listFromJson(Map<String, dynamic> json) {
    final raw = json['cities'] as List<dynamic>;
    return [for (final e in raw) fromJson(e as Map<String, dynamic>)];
  }
}
