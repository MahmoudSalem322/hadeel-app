import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/app.dart';
import 'package:hadeel/core/errors/failures.dart';
import 'package:hadeel/core/providers/core_providers.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/data/local/preferences_store.dart';
import 'package:hadeel/data/models/city_model.dart';
import 'package:hadeel/domain/entities/city.dart';
import 'package:hadeel/domain/entities/geo.dart';
import 'package:hadeel/services/location/device_timezone_service.dart';
import 'package:hadeel/services/location/location_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

bool _initialized = false;

/// One-time, offline setup shared by all tests: tz db and date symbols.
Future<void> initTestEnvironment() async {
  if (_initialized) return;
  tzdata.initializeTimeZones();
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  _initialized = true;
}

/// Fresh in-memory preferences for each test.
Future<PreferencesStore> openTestStore([Map<String, Object> initial = const {}]) async {
  SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.withData(initial);
  return PreferencesStore.open();
}

List<City> loadBundledCities() {
  final raw = File('assets/data/cities_ps.json').readAsStringSync();
  return CityModel.listFromJson(jsonDecode(raw) as Map<String, dynamic>);
}

/// An instant given as wall-clock time in [zone].
DateTime zoned(String zone, int y, int m, int d, [int h = 0, int min = 0, int s = 0]) =>
    tz.TZDateTime(tz.getLocation(zone), y, m, d, h, min, s);

class FakeLocationService implements LocationService {
  FakeLocationService(this.result);

  Result<GeoCoordinates, LocationFailure> result;
  int calls = 0;

  @override
  Future<Result<GeoCoordinates, LocationFailure>> currentPosition() async {
    calls++;
    return result;
  }
}

class FakeTimezoneService implements DeviceTimezoneService {
  const FakeTimezoneService([this.zone = 'Asia/Hebron']);

  final String zone;

  @override
  Future<String> localTimezone() async => zone;
}

/// Pumps the whole app with offline fakes. Returns the container so tests
/// can read providers.
Future<ProviderContainer> pumpHadeelApp(
  WidgetTester tester, {
  required ManualClock clock,
  Map<String, Object> prefs = const {},
  LocationService? locationService,
  bool skipSplash = true,
  List<Override> extraOverrides = const [],
}) async {
  await initTestEnvironment();
  final store = await openTestStore(prefs);
  final container = ProviderContainer(
    overrides: [
      preferencesStoreProvider.overrideWithValue(store),
      citiesProvider.overrideWithValue(loadBundledCities()),
      clockProvider.overrideWithValue(clock),
      locationServiceProvider.overrideWithValue(
        locationService ?? FakeLocationService(const Err(LocationFailure.permissionDenied)),
      ),
      deviceTimezoneServiceProvider.overrideWithValue(const FakeTimezoneService()),
      ...extraOverrides,
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const HadeelApp()));
  if (skipSplash) {
    await advance(tester, clock, const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }
  return container;
}

/// Moves the fake clock and the test's fake time together.
Future<void> advance(WidgetTester tester, ManualClock clock, Duration by) async {
  clock.advance(by);
  await tester.pump(by);
}

/// Preferences for a user who finished onboarding and picked [cityId].
Map<String, Object> onboardedWithCity(String cityId) => {
      PreferencesStore.keyOnboardingDone: true,
      PreferencesStore.keyLocationType: 'city',
      PreferencesStore.keyLocationCityId: cityId,
    };

/// Sets a phone-sized surface and text scale for layout tests.
void setSurface(WidgetTester tester, Size size, {double textScale = 1}) {
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

