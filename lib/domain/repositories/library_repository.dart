import '../entities/library.dart';
import '../entities/quran.dart';

/// The user's own data — favorites, bookmarks, reading progress — stored in
/// the local database.
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
}
