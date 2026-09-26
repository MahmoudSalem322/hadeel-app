import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/city_repository.dart';
import '../models/city_model.dart';

/// Reads the city list bundled with the app — available offline from first launch.
class AssetCityRepository implements CityRepository {
  AssetCityRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  @override
  Future<List<City>> loadCities() async {
    final raw = await _bundle.loadString(AppConstants.citiesAsset);
    return CityModel.listFromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
