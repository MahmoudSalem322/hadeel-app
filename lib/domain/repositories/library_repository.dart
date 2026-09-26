import '../entities/geo.dart';
import '../entities/library.dart';
import '../entities/quran.dart';

/// The user's own data — favorites, bookmarks, reading progress, tasbeeh
/// counters and adhkar progress — stored in the local database.
abstract interface class LibraryRepository {
  // Favorites (shared by Quran, adhkar, duas, hadith)
  Stream<List<FavoriteItem>> watchFavorites(FavoriteKind kind);
  Future<bool> toggleFavorite(FavoriteKind kind, String key);

  // Bookmarks
  Stream<List<Bookmark>> watchBookmarks();
  Future<bool> toggleBookmark(AyahRef ref);

  // Reading progress
  Stream<ReadingPosition?> watchLastPosition();
  Future<void> saveReadingPosition(AyahRef ref, {required DateTime at});
  Future<List<ReadingPosition>> readingHistory({int limit = 30});

  // Tasbeeh
  Future<TasbeehCounter> loadTasbeeh(String phraseKey);
  Future<void> saveTasbeeh(TasbeehCounter counter);

  // Adhkar progress (valid for [day] only)
  Future<AdhkarSession?> loadAdhkarSession(String categoryKey, CalendarDate day);
  Future<void> saveAdhkarSession(AdhkarSession session, CalendarDate day);
}
