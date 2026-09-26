import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/preferences_store.dart';
import '../../data/repositories/asset_content_repository.dart';
import '../../data/repositories/asset_quran_repository.dart';
import '../../data/repositories/library_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/quran.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/library_repository.dart';
import '../../domain/repositories/prayer_time_calculator.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../services/location/device_timezone_service.dart';
import '../../services/location/location_service.dart';
import '../../services/prayer/adhan_prayer_calculator.dart';
import '../database/app_database.dart';
import '../utils/clock.dart';

/// Opened once at startup (see `bootstrap.dart`) and injected via override.
final preferencesStoreProvider = Provider<PreferencesStore>(
  (ref) => throw UnimplementedError('preferencesStoreProvider must be overridden at bootstrap'),
);

/// Bundled city list, loaded once at startup — local data needs no loading UI.
final citiesProvider = Provider<List<City>>(
  (ref) => throw UnimplementedError('citiesProvider must be overridden at bootstrap'),
);

/// Structural Quran metadata (~24 KB), loaded once at startup.
final quranMetaProvider = Provider<QuranMeta>(
  (ref) => throw UnimplementedError('quranMetaProvider must be overridden at bootstrap'),
);

/// Local SQLite database for user data. Overridden at bootstrap (and with an
/// in-memory database in tests).
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('appDatabaseProvider must be overridden at bootstrap'),
);

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final clock = ref.watch(clockProvider);
  return LibraryRepositoryImpl(ref.watch(appDatabaseProvider), now: clock.now);
});

final quranRepositoryProvider = Provider<QuranRepository>((ref) => AssetQuranRepository());

final contentRepositoryProvider = Provider<ContentRepository>((ref) => AssetContentRepository());

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.watch(preferencesStoreProvider)),
);

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final prayerCalculatorProvider = Provider<PrayerTimeCalculator>(
  (ref) => const AdhanPrayerCalculator(),
);

final locationServiceProvider = Provider<LocationService>(
  (ref) => const GeolocatorLocationService(),
);

final deviceTimezoneServiceProvider = Provider<DeviceTimezoneService>(
  (ref) => const FlutterDeviceTimezoneService(),
);

/// Emits the current time every second. Only widgets that display seconds
/// (the countdown) should watch this directly.
final tickerProvider = StreamProvider<DateTime>((ref) async* {
  final clock = ref.watch(clockProvider);
  yield clock.now();
  yield* Stream<DateTime>.periodic(const Duration(seconds: 1), (_) => clock.now());
});

/// Latest tick, falling back to the clock before the first emission.
final nowProvider = Provider<DateTime>((ref) {
  return ref.watch(tickerProvider).value ?? ref.watch(clockProvider).now();
});
