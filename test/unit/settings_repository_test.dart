import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/data/local/preferences_store.dart';
import 'package:hadeel/data/repositories/settings_repository_impl.dart';
import 'package:hadeel/domain/entities/app_settings.dart';
import 'package:hadeel/domain/entities/geo.dart';
import 'package:hadeel/domain/entities/location_selection.dart';
import 'package:hadeel/domain/entities/prayer_settings.dart';

import '../helpers/test_harness.dart';

void main() {
  test('fresh install loads defaults', () async {
    final repo = SettingsRepositoryImpl(await openTestStore());
    final s = repo.load();
    expect(s.onboardingDone, isFalse);
    expect(s.themeMode, AppThemeMode.system);
    expect(s.prayer.method, CalculationMethodType.egyptian);
    expect(s.prayer.madhab, AsrMadhab.shafi);
    expect(s.location, isNull);
  });

  test('round-trips every setting through storage', () async {
    final store = await openTestStore();
    final repo = SettingsRepositoryImpl(store);
    await repo.saveThemeMode(AppThemeMode.dark);
    await repo.saveOnboardingDone(done: true);
    await repo.savePrayerSettings(
      const PrayerSettings(method: CalculationMethodType.ummAlQura, madhab: AsrMadhab.hanafi),
    );
    await repo.saveLocation(const CityLocationSelection('gaza'));

    // A new repository over the same store simulates an app restart.
    final reloaded = SettingsRepositoryImpl(store).load();
    expect(reloaded.themeMode, AppThemeMode.dark);
    expect(reloaded.onboardingDone, isTrue);
    expect(reloaded.prayer.method, CalculationMethodType.ummAlQura);
    expect(reloaded.prayer.madhab, AsrMadhab.hanafi);
    expect(reloaded.location, const CityLocationSelection('gaza'));
  });

  test('persists a GPS fix with its zone so it works offline later', () async {
    final store = await openTestStore();
    final captured = DateTime.utc(2026, 9, 26, 8);
    final selection = GpsLocationSelection(
      coordinates: const GeoCoordinates(31.9, 35.2),
      timezone: 'Asia/Hebron',
      capturedAt: captured,
    );
    await SettingsRepositoryImpl(store).saveLocation(selection);
    expect(SettingsRepositoryImpl(store).load().location, selection);
  });

  test('unknown stored values fall back to defaults instead of crashing', () async {
    final repo = SettingsRepositoryImpl(
      await openTestStore({
        PreferencesStore.keyThemeMode: 'neon',
        PreferencesStore.keyCalcMethod: 'removed_method',
        PreferencesStore.keyLocationType: 'gps', // missing coordinates
      }),
    );
    final s = repo.load();
    expect(s.themeMode, AppThemeMode.system);
    expect(s.prayer.method, CalculationMethodType.egyptian);
    expect(s.location, isNull);
  });
}
