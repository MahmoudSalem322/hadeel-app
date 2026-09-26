import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/geo.dart';
import '../../domain/entities/library.dart';
import '../../domain/entities/quran.dart';
import '../../domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl(this._db, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  static const int historyLimit = 100;

  // Favorites ------------------------------------------------------------

  @override
  Stream<List<FavoriteItem>> watchFavorites(FavoriteKind kind) {
    final q = _db.select(_db.favorites)
      ..where((f) => f.kind.equals(kind.name))
      ..orderBy([(f) => OrderingTerm.desc(f.createdAt), (f) => OrderingTerm.desc(f.id)]);
    return q.watch().map((rows) => [
          for (final r in rows) FavoriteItem(kind: kind, key: r.itemKey, createdAt: r.createdAt),
        ]);
  }

  @override
  Future<bool> toggleFavorite(FavoriteKind kind, String key) {
    return _db.transaction(() async {
      final deleted = await (_db.delete(_db.favorites)
            ..where((f) => f.kind.equals(kind.name) & f.itemKey.equals(key)))
          .go();
      if (deleted > 0) return false;
      await _db.into(_db.favorites).insert(
            FavoritesCompanion.insert(kind: kind.name, itemKey: key, createdAt: _now()),
          );
      return true;
    });
  }

  // Bookmarks ------------------------------------------------------------

  @override
  Stream<List<Bookmark>> watchBookmarks() {
    final q = _db.select(_db.bookmarks)
      ..orderBy([(b) => OrderingTerm.desc(b.createdAt), (b) => OrderingTerm.desc(b.id)]);
    return q.watch().map((rows) => [
          for (final r in rows) Bookmark(ref: AyahRef(r.surah, r.ayah), createdAt: r.createdAt),
        ]);
  }

  @override
  Future<bool> toggleBookmark(AyahRef ref) {
    return _db.transaction(() async {
      final deleted = await (_db.delete(_db.bookmarks)
            ..where((b) => b.surah.equals(ref.surah) & b.ayah.equals(ref.ayah)))
          .go();
      if (deleted > 0) return false;
      await _db.into(_db.bookmarks).insert(
            BookmarksCompanion.insert(surah: ref.surah, ayah: ref.ayah, createdAt: _now()),
          );
      return true;
    });
  }

  // Reading progress -----------------------------------------------------

  @override
  Stream<ReadingPosition?> watchLastPosition() {
    return (_db.select(_db.readingProgress)..where((p) => p.id.equals(1)))
        .watchSingleOrNull()
        .map((r) => r == null ? null : ReadingPosition(ref: AyahRef(r.surah, r.ayah), updatedAt: r.updatedAt));
  }

  @override
  Future<void> saveReadingPosition(AyahRef ref, {required DateTime at}) {
    return _db.transaction(() async {
      await _db.into(_db.readingProgress).insertOnConflictUpdate(
            ReadingProgressCompanion.insert(
              id: const Value(1),
              surah: ref.surah,
              ayah: ref.ayah,
              updatedAt: at,
            ),
          );
      await _db.into(_db.readingHistory).insert(
            ReadingHistoryCompanion.insert(surah: ref.surah, ayah: ref.ayah, readAt: at),
          );
      // Keep the history bounded.
      await _db.customStatement(
        'DELETE FROM reading_history WHERE id NOT IN '
        '(SELECT id FROM reading_history ORDER BY read_at DESC, id DESC LIMIT $historyLimit)',
      );
    });
  }

  // Tasbeeh --------------------------------------------------------------

  @override
  Future<TasbeehCounter> loadTasbeeh(String phraseKey) async {
    final row = await (_db.select(_db.tasbeehCounters)..where((t) => t.phraseKey.equals(phraseKey)))
        .getSingleOrNull();
    if (row == null) return TasbeehCounter(phraseKey: phraseKey);
    return TasbeehCounter(phraseKey: phraseKey, count: row.count, total: row.total, target: row.target);
  }

  @override
  Future<void> saveTasbeeh(TasbeehCounter counter) {
    return _db.into(_db.tasbeehCounters).insertOnConflictUpdate(
          TasbeehCountersCompanion.insert(
            phraseKey: counter.phraseKey,
            count: Value(counter.count),
            total: Value(counter.total),
            target: Value(counter.target),
            updatedAt: _now(),
          ),
        );
  }

  // Adhkar progress ------------------------------------------------------

  @override
  Future<AdhkarSession?> loadAdhkarSession(String categoryKey, CalendarDate day) async {
    final row = await (_db.select(_db.adhkarProgress)..where((a) => a.categoryKey.equals(categoryKey)))
        .getSingleOrNull();
    if (row == null || row.day != day.toString()) return null;
    return AdhkarSession(categoryKey: categoryKey, itemIndex: row.itemIndex, count: row.count);
  }

  @override
  Future<void> saveAdhkarSession(AdhkarSession session, CalendarDate day) {
    return _db.into(_db.adhkarProgress).insertOnConflictUpdate(
          AdhkarProgressCompanion.insert(
            categoryKey: session.categoryKey,
            itemIndex: session.itemIndex,
            count: session.count,
            day: day.toString(),
          ),
        );
  }

  @override
  Future<List<ReadingPosition>> readingHistory({int limit = 30}) async {
    final rows = await (_db.select(_db.readingHistory)
          ..orderBy([(h) => OrderingTerm.desc(h.readAt), (h) => OrderingTerm.desc(h.id)])
          ..limit(limit))
        .get();
    return [for (final r in rows) ReadingPosition(ref: AyahRef(r.surah, r.ayah), updatedAt: r.readAt)];
  }
}
