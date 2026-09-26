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

/// The on-device database for user data. Content (Quran, adhkar…) ships as
/// read-only assets; only what the user creates lives here.
@DriftDatabase(tables: [Favorites, Bookmarks, ReadingProgress, ReadingHistory])
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
  int get schemaVersion => 1;
}
