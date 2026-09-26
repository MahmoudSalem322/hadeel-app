import '../entities/quran.dart';

/// Read-only access to the bundled, verified Quran data. Always offline.
abstract interface class QuranRepository {
  Future<QuranMeta> loadMeta();

  /// Uthmani script, for reading.
  Future<QuranText> loadReadingText();

  /// Simple-clean script (no diacritics), for search.
  Future<QuranText> loadSearchText();
}
