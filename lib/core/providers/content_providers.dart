import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/content.dart';
import '../../domain/entities/library.dart';
import '../../domain/entities/quran.dart';
import 'core_providers.dart';

/// التفسير الميسر — loaded on first use.
final tafsirProvider = FutureProvider<QuranText>((ref) => ref.watch(contentRepositoryProvider).loadTafsir());

/// حصن المسلم and the app's adhkar/dua categories — loaded on first use.
final hisnProvider = FutureProvider<HisnLibrary>((ref) => ref.watch(contentRepositoryProvider).loadHisn());

/// Hadith books — loaded on first use.
final hadithLibraryProvider = FutureProvider<HadithLibrary>(
  (ref) => ref.watch(contentRepositoryProvider).loadHadith(),
);

/// Favorites of one kind, newest first.
final favoritesProvider = StreamProvider.family<List<FavoriteItem>, FavoriteKind>(
  (ref, kind) => ref.watch(libraryRepositoryProvider).watchFavorites(kind),
);

final favoriteKeysProvider = Provider.family<Set<String>, FavoriteKind>((ref, kind) {
  final list = ref.watch(favoritesProvider(kind)).value ?? const [];
  return {for (final f in list) f.key};
});
