import 'package:meta/meta.dart';

import '../../core/utils/arabic_normalizer.dart';
import '../entities/quran.dart';

@immutable
class AyahSearchHit {
  const AyahSearchHit({required this.ref, required this.text, required this.ranges});

  final AyahRef ref;

  /// The ayah in the search script (simple-clean), for the result snippet.
  final String text;

  /// Matched `[start, end)` ranges within [text], for highlighting.
  final List<(int, int)> ranges;
}

@immutable
class QuranSearchResults {
  const QuranSearchResults({required this.surahs, required this.ayat, required this.totalAyat});

  static const empty = QuranSearchResults(surahs: [], ayat: [], totalAyat: 0);

  final List<Surah> surahs;
  final List<AyahSearchHit> ayat;

  /// All matching ayat, which may exceed the returned [ayat] when capped.
  final int totalAyat;

  bool get isEmpty => surahs.isEmpty && ayat.isEmpty;
}

/// Pre-normalized, in-memory index over the whole Quran (~6k short strings).
/// Built once; each query is a linear scan that takes a few milliseconds.
class QuranSearchIndex {
  QuranSearchIndex(this.meta, QuranText searchText)
      : _normalized = [
          for (final sura in searchText.suras)
            for (final ayah in sura) normalizeArabicWithMap(ayah),
        ],
        _source = [
          for (final sura in searchText.suras) ...sura,
        ],
        _surahNames = [
          for (final s in meta.surahs)
            (normalizeArabic(s.nameAr), normalizeArabic(s.nameTransliterated)),
        ];

  final QuranMeta meta;
  final List<NormalizedText> _normalized;
  final List<String> _source;
  final List<(String, String)> _surahNames;

  static const int minQueryLength = 2;

  QuranSearchResults search(String query, {int limit = 200}) {
    final q = normalizeArabic(query).replaceAll(RegExp(r'\s+'), ' ');
    if (q.length < minQueryLength) return QuranSearchResults.empty;

    final surahs = <Surah>[
      for (var i = 0; i < _surahNames.length; i++)
        if (_surahNames[i].$1.contains(q) || _surahNames[i].$2.contains(q)) meta.surahs[i],
    ];

    final hits = <AyahSearchHit>[];
    var total = 0;
    var surahIdx = 0;
    for (var g = 0; g < _normalized.length; g++) {
      final norm = _normalized[g];
      var from = norm.text.indexOf(q);
      if (from < 0) continue;
      total++;
      if (hits.length >= limit) continue;

      final ranges = <(int, int)>[];
      while (from >= 0) {
        ranges.add(norm.toOriginalRange(from, from + q.length));
        from = norm.text.indexOf(q, from + q.length);
      }
      while (surahIdx < 113 && meta.surahs[surahIdx + 1].startIndex <= g) {
        surahIdx++;
      }
      final surah = meta.surahs[surahIdx];
      hits.add(AyahSearchHit(
        ref: AyahRef(surah.number, g - surah.startIndex + 1),
        text: _source[g],
        ranges: ranges,
      ));
    }
    return QuranSearchResults(surahs: surahs, ayat: hits, totalAyat: total);
  }
}
