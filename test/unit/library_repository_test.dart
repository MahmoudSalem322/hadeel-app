import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/database/app_database.dart';
import 'package:hadeel/data/repositories/library_repository_impl.dart';
import 'package:hadeel/domain/entities/library.dart';
import 'package:hadeel/domain/entities/quran.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late LibraryRepositoryImpl repo;
  var clock = DateTime.utc(2026, 9, 26, 8);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = DateTime.utc(2026, 9, 26, 8);
    repo = LibraryRepositoryImpl(db, now: () => clock = clock.add(const Duration(seconds: 1)));
  });
  tearDown(() => db.close());

  group('favorites', () {
    test('toggle adds then removes', () async {
      expect(await repo.toggleFavorite(FavoriteKind.ayah, '2:255'), isTrue);
      expect((await repo.watchFavorites(FavoriteKind.ayah).first).map((f) => f.key), ['2:255']);

      expect(await repo.toggleFavorite(FavoriteKind.ayah, '2:255'), isFalse);
      expect(await repo.watchFavorites(FavoriteKind.ayah).first, isEmpty);
    });

    test('kinds are independent and newest comes first', () async {
      await repo.toggleFavorite(FavoriteKind.ayah, '1:1');
      await repo.toggleFavorite(FavoriteKind.dhikr, 'morning-1');
      await repo.toggleFavorite(FavoriteKind.ayah, '112:1');

      final ayat = await repo.watchFavorites(FavoriteKind.ayah).first;
      expect(ayat.map((f) => f.key), ['112:1', '1:1']);
      expect((await repo.watchFavorites(FavoriteKind.dhikr).first).single.key, 'morning-1');
    });

    test('stream emits on change', () async {
      final emissions = <int>[];
      final sub = repo.watchFavorites(FavoriteKind.hadith).listen((l) => emissions.add(l.length));
      await pumpEventQueue();
      await repo.toggleFavorite(FavoriteKind.hadith, 'nawawi-1');
      await pumpEventQueue();
      await sub.cancel();
      expect(emissions, [0, 1]);
    });
  });

  group('bookmarks', () {
    test('toggle is idempotent per ayah', () async {
      expect(await repo.toggleBookmark(const AyahRef(18, 10)), isTrue);
      expect(await repo.toggleBookmark(const AyahRef(36, 1)), isTrue);
      expect((await repo.watchBookmarks().first).map((b) => b.ref),
          [const AyahRef(36, 1), const AyahRef(18, 10)]);
      expect(await repo.toggleBookmark(const AyahRef(18, 10)), isFalse);
      expect((await repo.watchBookmarks().first).single.ref, const AyahRef(36, 1));
    });
  });

  group('reading progress', () {
    test('starts empty', () async {
      expect(await repo.watchLastPosition().first, isNull);
    });

    test('keeps only the latest position and records history', () async {
      await repo.saveReadingPosition(const AyahRef(2, 1), at: DateTime.utc(2026, 9, 26, 9));
      await repo.saveReadingPosition(const AyahRef(2, 45), at: DateTime.utc(2026, 9, 26, 10));

      final last = await repo.watchLastPosition().first;
      expect(last!.ref, const AyahRef(2, 45));
      expect(last.updatedAt.isAtSameMomentAs(DateTime.utc(2026, 9, 26, 10)), isTrue);

      final history = await repo.readingHistory();
      expect(history.map((h) => h.ref), [const AyahRef(2, 45), const AyahRef(2, 1)]);
    });

    test('history is bounded', () async {
      for (var i = 1; i <= LibraryRepositoryImpl.historyLimit + 20; i++) {
        await repo.saveReadingPosition(AyahRef(2, i), at: DateTime.utc(2026, 1, 1).add(Duration(minutes: i)));
      }
      final all = await repo.readingHistory(limit: 1000);
      expect(all.length, LibraryRepositoryImpl.historyLimit);
      expect(all.first.ref, const AyahRef(2, LibraryRepositoryImpl.historyLimit + 20));
    });
  });
}
