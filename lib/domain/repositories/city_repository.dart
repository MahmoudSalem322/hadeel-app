import '../entities/city.dart';

/// Bundled, offline list of selectable cities.
abstract interface class CityRepository {
  Future<List<City>> loadCities();
}
