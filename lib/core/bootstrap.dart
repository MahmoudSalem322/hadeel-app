import 'package:flutter_riverpod/misc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;

import '../data/local/preferences_store.dart';
import '../data/repositories/asset_city_repository.dart';
import '../data/repositories/asset_quran_repository.dart';
import 'database/app_database.dart';
import 'providers/core_providers.dart';

/// Everything the first frame needs, all local and fast (tens of ms):
/// timezone db, date symbols, preferences, the city list and Quran
/// metadata. The full Quran text loads lazily when first opened.
Future<List<Override>> bootstrap() async {
  tzdata.initializeTimeZones();

  final storeFuture = PreferencesStore.open();
  final citiesFuture = AssetCityRepository().loadCities();
  final quranMetaFuture = AssetQuranRepository().loadMeta();
  await Future.wait([initializeDateFormatting('ar'), initializeDateFormatting('en')]);

  return [
    preferencesStoreProvider.overrideWithValue(await storeFuture),
    citiesProvider.overrideWithValue(await citiesFuture),
    quranMetaProvider.overrideWithValue(await quranMetaFuture),
    // The database opens lazily on first query.
    appDatabaseProvider.overrideWith((ref) {
      final db = AppDatabase.open();
      ref.onDispose(db.close);
      return db;
    }),
  ];
}
