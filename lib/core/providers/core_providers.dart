import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/preferences_store.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/prayer_time_calculator.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../services/location/device_timezone_service.dart';
import '../../services/location/location_service.dart';
import '../../services/prayer/adhan_prayer_calculator.dart';
import '../utils/clock.dart';

/// Opened once at startup (see `bootstrap.dart`) and injected via override.
final preferencesStoreProvider = Provider<PreferencesStore>(
  (ref) => throw UnimplementedError('preferencesStoreProvider must be overridden at bootstrap'),
);

/// Bundled city list, loaded once at startup — local data needs no loading UI.
final citiesProvider = Provider<List<City>>(
  (ref) => throw UnimplementedError('citiesProvider must be overridden at bootstrap'),
);

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
