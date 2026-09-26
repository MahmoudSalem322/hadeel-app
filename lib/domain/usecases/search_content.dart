import 'package:meta/meta.dart';

import '../../core/utils/arabic_normalizer.dart';
import '../entities/content.dart';

/// A matched text with `[start, end)` ranges to highlight.
@immutable
class TextHit<T> {
  const TextHit({required this.item, required this.text, required this.ranges});

  final T item;
  final String text;
  final List<(int, int)> ranges;
}

@immutable
class ContentSearchResults {
  const ContentSearchResults({
    required this.adhkar,
    required this.adhkarTotal,
    required this.hadith,
    required this.hadithTotal,
  });

  static const empty = ContentSearchResults(adhkar: [], adhkarTotal: 0, hadith: [], hadithTotal: 0);

  final List<TextHit<DhikrItem>> adhkar;
  final int adhkarTotal;
  final List<TextHit<Hadith>> hadith;
  final int hadithTotal;

  bool get isEmpty => adhkarTotal == 0 && hadithTotal == 0;
}

/// Pre-normalized index over Hisn al-Muslim and the hadith books.
class ContentSearchIndex {
  ContentSearchIndex(HisnLibrary hisn, HadithLibrary hadith)
      : _adhkar = [
          for (final c in hisn.chapters)
            for (final i in c.items) (i, normalizeArabicWithMap(i.text)),
        ],
        _hadith = [
          for (final b in hadith.books)
            for (final h in b.hadiths) (h, normalizeArabicWithMap(h.text)),
        ];

  final List<(DhikrItem, NormalizedText)> _adhkar;
  final List<(Hadith, NormalizedText)> _hadith;

  static const int minQueryLength = 2;

  ContentSearchResults search(String query, {int limit = 20}) {
    final q = normalizeArabic(query).replaceAll(RegExp(r'\s+'), ' ');
    if (q.length < minQueryLength) return ContentSearchResults.empty;
    final (adhkar, adhkarTotal) = _scan(_adhkar, q, limit, (i) => i.text);
    final (hadith, hadithTotal) = _scan(_hadith, q, limit, (h) => h.text);
    return ContentSearchResults(adhkar: adhkar, adhkarTotal: adhkarTotal, hadith: hadith, hadithTotal: hadithTotal);
  }

  static (List<TextHit<T>>, int) _scan<T>(
    List<(T, NormalizedText)> entries,
    String q,
    int limit,
    String Function(T) textOf,
  ) {
    final hits = <TextHit<T>>[];
    var total = 0;
    for (final (item, norm) in entries) {
      var from = norm.text.indexOf(q);
      if (from < 0) continue;
      total++;
      if (hits.length >= limit) continue;
      final ranges = <(int, int)>[];
      while (from >= 0) {
        ranges.add(norm.toOriginalRange(from, from + q.length));
        from = norm.text.indexOf(q, from + q.length);
      }
      hits.add(TextHit(item: item, text: textOf(item), ranges: ranges));
    }
    return (hits, total);
  }
}

/// A short window of [text] around its first match, for result lists.
/// Returns the excerpt and the ranges shifted into it.
(String, List<(int, int)>) excerptAround(String text, List<(int, int)> ranges, {int context = 70}) {
  if (ranges.isEmpty || text.length <= context * 2) return (text, ranges);
  final first = ranges.first.$1;
  var start = (first - context).clamp(0, text.length);
  var end = (first + context).clamp(0, text.length);
  // Snap to word boundaries so words aren't cut mid-way.
  while (start > 0 && text[start - 1] != ' ') {
    start--;
  }
  while (end < text.length && text[end] != ' ') {
    end++;
  }
  final prefix = start > 0 ? '… ' : '';
  final suffix = end < text.length ? ' …' : '';
  final shifted = [
    for (final (s, e) in ranges)
      if (s >= start && e <= end) (s - start + prefix.length, e - start + prefix.length),
  ];
  return ('$prefix${text.substring(start, end)}$suffix', shifted);
}
