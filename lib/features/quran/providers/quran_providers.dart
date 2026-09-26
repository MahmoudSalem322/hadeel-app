import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/utils/clock.dart';
import '../../../domain/entities/library.dart';
import '../../../domain/entities/quran.dart';
import '../../../domain/entities/reading_progress.dart';
import '../../../domain/repositories/library_repository.dart';
import '../../../domain/usecases/search_quran.dart';

/// Uthmani text for reading. Decoded once, on first use, off the UI thread.
final quranTextProvider = FutureProvider<QuranText>(
  (ref) => ref.watch(quranRepositoryProvider).loadReadingText(),
);

/// Search index over the simple-clean text. Built on first search only.
final quranSearchIndexProvider = FutureProvider<QuranSearchIndex>((ref) async {
  final text = await ref.watch(quranRepositoryProvider).loadSearchText();
  return QuranSearchIndex(ref.watch(quranMetaProvider), text);
});

final quranSearchProvider = FutureProvider.autoDispose.family<QuranSearchResults, String>((ref, query) async {
  if (query.trim().length < QuranSearchIndex.minQueryLength) return QuranSearchResults.empty;
  final index = await ref.watch(quranSearchIndexProvider.future);
  return index.search(query);
});

// User library -----------------------------------------------------------

final bookmarksProvider = StreamProvider<List<Bookmark>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchBookmarks(),
);

final bookmarkedRefsProvider = Provider<Set<AyahRef>>((ref) {
  final list = ref.watch(bookmarksProvider).value ?? const [];
  return {for (final b in list) b.ref};
});

final favoriteAyatProvider = StreamProvider<List<FavoriteItem>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchFavorites(FavoriteKind.ayah),
);

final favoriteAyahRefsProvider = Provider<Set<AyahRef>>((ref) {
  final list = ref.watch(favoriteAyatProvider).value ?? const [];
  return {for (final f in list) ?AyahRef.tryParse(f.key)};
});

final lastReadingPositionProvider = StreamProvider<ReadingPosition?>(
  (ref) => ref.watch(libraryRepositoryProvider).watchLastPosition(),
);

/// Last reading position enriched for display (surah name, overall share).
final readingProgressProvider = Provider<ReadingProgress?>((ref) {
  final position = ref.watch(lastReadingPositionProvider).value;
  if (position == null) return null;
  final meta = ref.watch(quranMetaProvider);
  if (!meta.isValid(position.ref)) return null;
  final surah = meta.surah(position.ref.surah);
  return ReadingProgress(
    surahNumber: surah.number,
    surahName: surah.nameAr,
    ayahNumber: position.ref.ayah,
    fraction: (meta.globalIndex(position.ref) + 1) / meta.totalAyat,
  );
});

/// Records where the reader is, debounced so scrolling doesn't hammer the
/// database. Pending positions are flushed when the reader closes.
final readingRecorderProvider = NotifierProvider.autoDispose<ReadingRecorder, AyahRef?>(ReadingRecorder.new);

class ReadingRecorder extends Notifier<AyahRef?> {
  static const Duration debounce = Duration(milliseconds: 1200);

  Timer? _timer;
  AyahRef? _pending;
  AyahRef? _saved;
  late LibraryRepository _repo;
  late Clock _clock;

  @override
  AyahRef? build() {
    // Captured up front: `ref` can't be used inside onDispose.
    _repo = ref.read(libraryRepositoryProvider);
    _clock = ref.read(clockProvider);
    ref.onDispose(() {
      _timer?.cancel();
      _write();
    });
    return null;
  }

  void report(AyahRef position) {
    if (position == _pending || (position == _saved && _pending == null)) return;
    _pending = position;
    state = position;
    _timer?.cancel();
    _timer = Timer(debounce, _write);
  }

  /// Writes any pending position now (e.g. when the reader closes).
  void flush() {
    _timer?.cancel();
    _timer = null;
    _write();
  }

  void _write() {
    final position = _pending;
    if (position == null) return;
    _pending = null;
    _saved = position;
    unawaited(_repo.saveReadingPosition(position, at: _clock.now()));
  }
}
