import 'package:shared_preferences/shared_preferences.dart';

/// Typed keys over [SharedPreferencesWithCache]. The only place that knows
/// preference key names.
class PreferencesStore {
  PreferencesStore(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static const String keyThemeMode = 'settings.themeMode';
  static const String keyLanguage = 'settings.language';
  static const String keyOnboardingDone = 'onboarding.done';
  static const String keyCalcMethod = 'prayer.method';
  static const String keyMadhab = 'prayer.madhab';
  static const String keyLocationType = 'location.type';
  static const String keyLocationCityId = 'location.cityId';
  static const String keyLocationLat = 'location.lat';
  static const String keyLocationLng = 'location.lng';
  static const String keyLocationTz = 'location.tz';
  static const String keyLocationCapturedAt = 'location.capturedAt';
  static const String keyQuranFontSize = 'quran.fontSize';
  static const String keyQuranLineHeight = 'quran.lineHeight';
  static const String keyQuranFont = 'quran.font';
  static const String keyQuranMode = 'quran.mode';
  static const String keyQuranShowTafsir = 'quran.showTafsir';
  static const String keyNotifyPrayers = 'notify.prayers';
  static const String keyTasbeehVibration = 'tasbeeh.vibration';
  static const String keyTasbeehSound = 'tasbeeh.sound';
  static const String keyTasbeehPhrase = 'tasbeeh.phrase';
  static const String keyHijriAdjustment = 'hijri.adjustment';

  static const Set<String> allKeys = {
    keyThemeMode,
    keyLanguage,
    keyOnboardingDone,
    keyCalcMethod,
    keyMadhab,
    keyLocationType,
    keyLocationCityId,
    keyLocationLat,
    keyLocationLng,
    keyLocationTz,
    keyLocationCapturedAt,
    keyQuranFontSize,
    keyQuranLineHeight,
    keyQuranFont,
    keyQuranMode,
    keyQuranShowTafsir,
    keyNotifyPrayers,
    keyTasbeehVibration,
    keyTasbeehSound,
    keyTasbeehPhrase,
    keyHijriAdjustment,
  };

  static Future<PreferencesStore> open() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(allowList: allKeys),
    );
    return PreferencesStore(prefs);
  }

  String? getString(String key) => _prefs.getString(key);
  bool? getBool(String key) => _prefs.getBool(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  int? getInt(String key) => _prefs.getInt(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<void> setString(String key, String value) => _prefs.setString(key, value);
  Future<void> setBool(String key, {required bool value}) => _prefs.setBool(key, value);
  Future<void> setDouble(String key, double value) => _prefs.setDouble(key, value);
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);
  Future<void> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);
  Future<void> remove(String key) => _prefs.remove(key);
}
