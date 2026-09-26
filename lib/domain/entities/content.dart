import 'package:meta/meta.dart';

import 'quran.dart';

/// One dhikr or dua from Hisn al-Muslim.
@immutable
class DhikrItem {
  const DhikrItem({required this.id, required this.chapterId, required this.text, required this.repeat});

  final int id;
  final int chapterId;
  final String text;

  /// How many times it is said, as given by the source (at least 1).
  final int repeat;

  /// Stable key for favorites.
  String get key => 'hisn:$id';
}

@immutable
class HisnChapter {
  const HisnChapter({required this.id, required this.title, required this.items});

  final int id;
  final String title;
  final List<DhikrItem> items;
}

/// A dua taken from the Quran. Only the reference is stored; the text is
/// read from the verified Quran text at display time.
@immutable
class QuranDua {
  const QuranDua({required this.from, required this.to, required this.check, this.prophet});

  final AyahRef from;

  /// Inclusive end, in the same surah as [from].
  final AyahRef to;

  /// A phrase from the ayah (simple-clean spelling) used by tests to verify
  /// the reference.
  final String check;

  /// Prophet key (e.g. `ibrahim`) for duas of the prophets.
  final String? prophet;

  String get key => 'q:${from.key}-${to.ayah}';

  static final RegExp _keyPattern = RegExp(r'^q:(\d+):(\d+)-(\d+)$');

  /// Rebuilds a dua from its favorite [key] (the verification phrase is not
  /// part of the key and isn't needed for display).
  static QuranDua? tryParseKey(String key) {
    final m = _keyPattern.firstMatch(key);
    if (m == null) return null;
    final surah = int.parse(m.group(1)!);
    final first = int.parse(m.group(2)!);
    final last = int.parse(m.group(3)!);
    if (surah < 1 || surah > 114 || first < 1 || last < first) return null;
    return QuranDua(from: AyahRef(surah, first), to: AyahRef(surah, last), check: '');
  }

  List<AyahRef> get ayat => [for (var a = from.ayah; a <= to.ayah; a++) AyahRef(from.surah, a)];
}

/// A browsable category: Hisn chapters and/or Quranic duas.
@immutable
class ContentCategory {
  const ContentCategory({required this.key, this.chapterIds = const [], this.quranDuas = const []});

  final String key;
  final List<int> chapterIds;
  final List<QuranDua> quranDuas;
}

/// Hisn al-Muslim plus the app's category mapping.
class HisnLibrary {
  HisnLibrary({required List<HisnChapter> chapters, required this.adhkar, required this.duas})
      : chapters = List.unmodifiable(chapters),
        _byId = {for (final c in chapters) c.id: c},
        _itemById = {
          for (final c in chapters)
            for (final i in c.items) i.id: i,
        };

  /// All chapters in the book's order.
  final List<HisnChapter> chapters;
  final List<ContentCategory> adhkar;
  final List<ContentCategory> duas;
  final Map<int, HisnChapter> _byId;
  final Map<int, DhikrItem> _itemById;

  HisnChapter? chapter(int id) => _byId[id];

  DhikrItem? itemByKey(String key) {
    if (!key.startsWith('hisn:')) return null;
    return _itemById[int.tryParse(key.substring(5))];
  }

  ContentCategory? adhkarCategory(String key) => _find(adhkar, key);
  ContentCategory? duaCategory(String key) => _find(duas, key);

  /// Items for a category, flattened across its chapters, in order.
  List<DhikrItem> itemsOf(ContentCategory category) => [
        for (final id in category.chapterIds) ...?_byId[id]?.items,
      ];

  static ContentCategory? _find(List<ContentCategory> list, String key) {
    for (final c in list) {
      if (c.key == key) return c;
    }
    return null;
  }
}

@immutable
class Hadith {
  const Hadith({required this.bookKey, required this.number, required this.chapterId, required this.text});

  final String bookKey;
  final int number;
  final int chapterId;

  /// Arabic text as published, including narrator and takhrij.
  final String text;

  String get key => '$bookKey:$number';
}

@immutable
class HadithChapter {
  const HadithChapter(this.id, this.title);

  final int id;
  final String title;
}

class HadithBook {
  HadithBook({
    required this.key,
    required this.title,
    required this.author,
    required this.chapters,
    required this.hadiths,
  });

  final String key;
  final String title;
  final String author;
  final List<HadithChapter> chapters;
  final List<Hadith> hadiths;

  String chapterTitle(int id) {
    for (final c in chapters) {
      if (c.id == id) return c.title;
    }
    return '';
  }
}

class HadithLibrary {
  HadithLibrary(this.books);

  final List<HadithBook> books;

  HadithBook? book(String key) {
    for (final b in books) {
      if (b.key == key) return b;
    }
    return null;
  }

  Hadith? byKey(String key) {
    final i = key.lastIndexOf(':');
    if (i < 0) return null;
    final book = this.book(key.substring(0, i));
    final n = int.tryParse(key.substring(i + 1));
    if (book == null || n == null) return null;
    for (final h in book.hadiths) {
      if (h.number == n) return h;
    }
    return null;
  }
}
