import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Favorites across all content kinds (ayah, dhikr, dua, hadith).
@DataClassName('FavoriteRow')
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  TextColumn get itemKey => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {kind, itemKey},
      ];
}

@DataClassName('BookmarkRow')
class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surah => integer()();
  IntColumn get ayah => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {surah, ayah},
      ];
}

/// Single row (id = 1) holding the last reading position.
@DataClassName('ReadingProgressRow')
class ReadingProgress extends Table {
  IntColumn get id => integer()();
  IntColumn get surah => integer()();
  IntColumn get ayah => integer()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Recent reading positions, newest first, trimmed to a small window.
@DataClassName('ReadingHistoryRow')
class ReadingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surah => integer()();
  IntColumn get ayah => integer()();
  DateTimeColumn get readAt => dateTime()();
}

/// Per-phrase tasbeeh counter: current count toward the target, and the
/// lifetime total.
@DataClassName('TasbeehCounterRow')
class TasbeehCounters extends Table {
  TextColumn get phraseKey => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  IntColumn get total => integer().withDefault(const Constant(0))();
  IntColumn get target => integer().withDefault(const Constant(33))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {phraseKey};
}

/// Where the user is in an adhkar category today. Resets on a new day.
@DataClassName('AdhkarProgressRow')
class AdhkarProgress extends Table {
  TextColumn get categoryKey => text()();
  IntColumn get itemIndex => integer()();
  IntColumn get count => integer()();

  /// Local calendar day, `yyyy-mm-dd`.
  TextColumn get day => text()();

  @override
  Set<Column> get primaryKey => {categoryKey};
}

/// The on-device database for user data. Content (Quran, adhkar…) ships as
/// read-only assets; only what the user creates lives here.
@DriftDatabase(
  tables: [Favorites, Bookmarks, ReadingProgress, ReadingHistory, TasbeehCounters, AdhkarProgress],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the persistent database for the current platform.
  factory AppDatabase.open() => AppDatabase(
        driftDatabase(
          name: 'hadeel',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(tasbeehCounters);
            await m.createTable(adhkarProgress);
          }
        },
      );
}
