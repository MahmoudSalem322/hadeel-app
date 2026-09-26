import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/app.dart';
import 'package:hadeel/core/database/app_database.dart';
import 'package:hadeel/core/errors/failures.dart';
import 'package:hadeel/core/providers/core_providers.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/data/local/preferences_store.dart';
import 'package:hadeel/data/models/city_model.dart';
import 'package:hadeel/data/models/content_models.dart';
import 'package:hadeel/data/models/quran_models.dart';
import 'package:hadeel/data/repositories/asset_content_repository.dart';
import 'package:hadeel/data/repositories/asset_quran_repository.dart';
import 'package:hadeel/domain/entities/city.dart';
import 'package:hadeel/domain/entities/content.dart';
import 'package:hadeel/domain/entities/geo.dart';
import 'package:hadeel/domain/entities/quran.dart';
import 'package:hadeel/domain/repositories/content_repository.dart';
import 'package:hadeel/domain/repositories/quran_repository.dart';
import 'package:hadeel/features/prayer/providers/notification_providers.dart';
import 'package:hadeel/features/qibla/qibla_screen.dart';
import 'package:hadeel/services/location/device_timezone_service.dart';
import 'package:hadeel/services/location/location_service.dart';
import 'package:hadeel/services/notifications/notification_service.dart';
import 'package:hadeel/services/sensors/compass_service.dart';
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

// Parsed once per test run; the files are large and immutable.
QuranMeta? _meta;
QuranText? _reading;
QuranText? _search;

QuranMeta loadQuranMeta() =>
    _meta ??= QuranModels.metaFromJson(File(AssetQuranRepository.metaAsset).readAsStringSync());
QuranText loadQuranReadingText() =>
    _reading ??= QuranModels.textFromJson(File(AssetQuranRepository.readingAsset).readAsStringSync());
QuranText loadQuranSearchText() =>
    _search ??= QuranModels.textFromJson(File(AssetQuranRepository.searchAsset).readAsStringSync());

/// Serves the bundled Quran files synchronously from disk — no isolates,
/// so it plays well with widget tests' fake async.
class FileQuranRepository implements QuranRepository {
  const FileQuranRepository();

  @override
  Future<QuranMeta> loadMeta() async => loadQuranMeta();

  @override
  Future<QuranText> loadReadingText() async => loadQuranReadingText();

  @override
  Future<QuranText> loadSearchText() async => loadQuranSearchText();
}

QuranText? _tafsir;
HisnLibrary? _hisn;
HadithLibrary? _hadith;

QuranText loadTafsirText() =>
    _tafsir ??= ContentModels.tafsirFromJson(File(AssetContentRepository.tafsirAsset).readAsStringSync());
HisnLibrary loadHisnLibrary() => _hisn ??= ContentModels.hisnFromJson((
      File(AssetContentRepository.hisnAsset).readAsStringSync(),
      File(AssetContentRepository.categoriesAsset).readAsStringSync(),
    ));
HadithLibrary loadHadithLibrary() =>
    _hadith ??= ContentModels.hadithFromJson(File(AssetContentRepository.hadithAsset).readAsStringSync());

/// Serves bundled content synchronously from disk for tests.
class FileContentRepository implements ContentRepository {
  const FileContentRepository();

  @override
  Future<QuranText> loadTafsir() async => loadTafsirText();

  @override
  Future<HisnLibrary> loadHisn() async => loadHisnLibrary();

  @override
  Future<HadithLibrary> loadHadith() async => loadHadithLibrary();
}

AppDatabase openTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
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

class FakeNotificationService implements NotificationService {
  FakeNotificationService({this.granted = true});

  bool granted;
  int permissionRequests = 0;
  List<NotificationRequest> scheduled = const [];

  @override
  Future<void> init({required String channelName, required String channelDescription}) async {}

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return granted;
  }

  @override
  Future<void> replaceAll(List<NotificationRequest> requests) async => scheduled = requests;
}

class FakeCompassService implements CompassService {
  FakeCompassService([this.stream]);

  /// Null simulates a device without a compass.
  final Stream<CompassReading>? stream;

  @override
  Stream<CompassReading>? get readings => stream;
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
  NotificationService? notifications,
  CompassService? compass,
  bool skipSplash = true,
  List<Override> extraOverrides = const [],
}) async {
  await initTestEnvironment();
  final store = await openTestStore(prefs);
  final db = openTestDatabase();
  final container = ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      preferencesStoreProvider.overrideWithValue(store),
      citiesProvider.overrideWithValue(loadBundledCities()),
      quranMetaProvider.overrideWithValue(loadQuranMeta()),
      quranRepositoryProvider.overrideWithValue(const FileQuranRepository()),
      contentRepositoryProvider.overrideWithValue(const FileContentRepository()),
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(clock),
      locationServiceProvider.overrideWithValue(
        locationService ?? FakeLocationService(const Err(LocationFailure.permissionDenied)),
      ),
      deviceTimezoneServiceProvider.overrideWithValue(const FakeTimezoneService()),
      notificationServiceProvider.overrideWithValue(notifications ?? FakeNotificationService()),
      compassServiceProvider.overrideWithValue(compass ?? FakeCompassService()),
      ...extraOverrides,
    ],
  );
  addTearDown(() async {
    container.dispose();
    await db.close();
  });

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

