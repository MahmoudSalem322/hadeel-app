import '../../domain/entities/app_settings.dart';
import '../../domain/entities/geo.dart';
import '../../domain/entities/location_selection.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../local/preferences_store.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._store);

  final PreferencesStore _store;

  static const String _typeCity = 'city';
  static const String _typeGps = 'gps';

  @override
  AppSettings load() {
    return AppSettings(
      themeMode: _enumByName(
        AppThemeMode.values,
        _store.getString(PreferencesStore.keyThemeMode),
        AppThemeMode.system,
      ),
      onboardingDone: _store.getBool(PreferencesStore.keyOnboardingDone) ?? false,
      prayer: PrayerSettings(
        method: _enumByName(
          CalculationMethodType.values,
          _store.getString(PreferencesStore.keyCalcMethod),
          PrayerSettings.defaults.method,
        ),
        madhab: _enumByName(
          AsrMadhab.values,
          _store.getString(PreferencesStore.keyMadhab),
          PrayerSettings.defaults.madhab,
        ),
      ),
      location: _loadLocation(),
    );
  }

  LocationSelection? _loadLocation() {
    switch (_store.getString(PreferencesStore.keyLocationType)) {
      case _typeCity:
        final id = _store.getString(PreferencesStore.keyLocationCityId);
        return id == null ? null : CityLocationSelection(id);
      case _typeGps:
        final lat = _store.getDouble(PreferencesStore.keyLocationLat);
        final lng = _store.getDouble(PreferencesStore.keyLocationLng);
        final tzId = _store.getString(PreferencesStore.keyLocationTz);
        final captured = _store.getInt(PreferencesStore.keyLocationCapturedAt);
        if (lat == null || lng == null || tzId == null) return null;
        return GpsLocationSelection(
          coordinates: GeoCoordinates(lat, lng),
          timezone: tzId,
          capturedAt: DateTime.fromMillisecondsSinceEpoch(captured ?? 0, isUtc: true),
        );
      default:
        return null;
    }
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) =>
      _store.setString(PreferencesStore.keyThemeMode, mode.name);

  @override
  Future<void> saveOnboardingDone({required bool done}) =>
      _store.setBool(PreferencesStore.keyOnboardingDone, value: done);

  @override
  Future<void> savePrayerSettings(PrayerSettings settings) async {
    await _store.setString(PreferencesStore.keyCalcMethod, settings.method.name);
    await _store.setString(PreferencesStore.keyMadhab, settings.madhab.name);
  }

  @override
  Future<void> saveLocation(LocationSelection selection) async {
    switch (selection) {
      case CityLocationSelection(:final cityId):
        await _store.setString(PreferencesStore.keyLocationType, _typeCity);
        await _store.setString(PreferencesStore.keyLocationCityId, cityId);
      case GpsLocationSelection(:final coordinates, :final timezone, :final capturedAt):
        await _store.setString(PreferencesStore.keyLocationType, _typeGps);
        await _store.setDouble(PreferencesStore.keyLocationLat, coordinates.latitude);
        await _store.setDouble(PreferencesStore.keyLocationLng, coordinates.longitude);
        await _store.setString(PreferencesStore.keyLocationTz, timezone);
        await _store.setInt(
          PreferencesStore.keyLocationCapturedAt,
          capturedAt.toUtc().millisecondsSinceEpoch,
        );
    }
  }

  static T _enumByName<T extends Enum>(List<T> values, String? name, T fallback) {
    if (name == null) return fallback;
    for (final v in values) {
      if (v.name == name) return v;
    }
    return fallback;
  }
}
