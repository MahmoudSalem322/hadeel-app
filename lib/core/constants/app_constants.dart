abstract final class AppConstants {
  static const String citiesAsset = 'assets/data/cities_ps.json';

  /// City used to pre-select the picker; never applied silently.
  static const String suggestedCityId = 'jerusalem';

  /// How long the in-app splash stays visible at minimum.
  static const Duration splashMinDuration = Duration(milliseconds: 900);
}
