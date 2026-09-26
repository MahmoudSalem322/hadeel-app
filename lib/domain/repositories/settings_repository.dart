import '../entities/app_settings.dart';
import '../entities/location_selection.dart';
import '../entities/prayer_settings.dart';
import '../entities/quran_reading_settings.dart';

/// Local persistence of user preferences. No network involved.
abstract interface class SettingsRepository {
  AppSettings load();

  Future<void> saveThemeMode(AppThemeMode mode);

  Future<void> saveLanguage(String code);

  Future<void> saveOnboardingDone({required bool done});

  Future<void> savePrayerSettings(PrayerSettings settings);

  Future<void> saveLocation(LocationSelection selection);

  Future<void> saveQuranSettings(QuranReadingSettings settings);

  Future<void> saveNotificationSettings(NotificationSettings settings);

  Future<void> saveTasbeehSettings(TasbeehSettings settings);

  Future<void> saveHijriAdjustment(int days);
}
