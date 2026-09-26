import 'package:meta/meta.dart';

import 'quran.dart';

/// What a favorite points to. Keys are stable ids within each kind
/// (e.g. `2:255` for an ayah).
enum FavoriteKind { ayah, dhikr, dua, hadith }

@immutable
class FavoriteItem {
  const FavoriteItem({required this.kind, required this.key, required this.createdAt});

  final FavoriteKind kind;
  final String key;
  final DateTime createdAt;
}

@immutable
class Bookmark {
  const Bookmark({required this.ref, required this.createdAt});

  final AyahRef ref;
  final DateTime createdAt;
}

/// Last place the reader stopped.
@immutable
class ReadingPosition {
  const ReadingPosition({required this.ref, required this.updatedAt});

  final AyahRef ref;
  final DateTime updatedAt;
}
