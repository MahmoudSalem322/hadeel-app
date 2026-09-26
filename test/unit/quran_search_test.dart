import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/utils/arabic_normalizer.dart';
import 'package:hadeel/domain/entities/quran.dart';
import 'package:hadeel/domain/usecases/search_quran.dart';

import '../helpers/test_harness.dart';

/// Queries are derived from the bundled text itself (never typed from
/// memory), so the tests stay faithful to the source.
void main() {
  final meta = loadQuranMeta();
  final text = loadQuranSearchText();
  final index = QuranSearchIndex(meta, text);

  /// The longest word of an ayah — distinctive enough to find it again.
  String longestWord(AyahRef ref) =>
      text.ayah(ref).split(' ').reduce((a, b) => b.length > a.length ? b : a);

  test('finds an ayah by one of its words', () {
    const target = AyahRef(2, 255);
    final r = index.search(longestWord(target));
    expect(r.ayat.map((h) => h.ref), contains(target));
  });

  test('matches regardless of tashkeel in the query', () {
    const target = AyahRef(18, 10);
    final word = longestWord(target);
    // Insert a fatha after every letter.
    final voweled = word.split('').join('َ');
    expect(index.search(voweled).ayat.map((h) => h.ref), contains(target));
  });

  test('matches regardless of hamza form on alef', () {
    // Find a word that contains a plain alef and swap it for alef-with-hamza.
    final ref = [
      for (var a = 1; a <= meta.surah(36).ayahCount; a++) AyahRef(36, a),
    ].firstWhere((r) => longestWord(r).contains('ا'));
    final word = longestWord(ref).replaceFirst('ا', 'أ');
    expect(index.search(word).ayat.map((h) => h.ref), contains(ref));
  });

  test('highlight ranges point at the matched text', () {
    const target = AyahRef(112, 1);
    final word = longestWord(target);
    // A common word can have hundreds of hits; lift the cap to reach 112:1.
    final hit = index.search(word, limit: 10000).ayat.firstWhere((h) => h.ref == target);
    for (final (start, end) in hit.ranges) {
      expect(normalizeArabic(hit.text.substring(start, end)), normalizeArabic(word));
    }
  });

  test('finds surahs by name, ignoring taa marbuta spelling', () {
    final baqarah = meta.surah(2).nameAr; // from the source metadata
    final loose = baqarah.replaceAll('ة', 'ه');
    expect(index.search(loose).surahs.map((s) => s.number), contains(2));
  });

  test('finds surahs by transliterated name', () {
    expect(index.search('yaseen').surahs.map((s) => s.number), contains(36));
  });

  test('very short queries return nothing', () {
    expect(index.search('ا').isEmpty, isTrue);
    expect(index.search('  ').isEmpty, isTrue);
  });

  test('results are capped but the total is reported', () {
    // The most common word in the whole text guarantees many hits.
    final counts = <String, int>{};
    for (final sura in text.suras) {
      for (final ayah in sura) {
        for (final w in ayah.split(' ')) {
          if (w.length >= 3) counts[w] = (counts[w] ?? 0) + 1;
        }
      }
    }
    final common = counts.entries.reduce((a, b) => b.value > a.value ? b : a).key;
    final r = index.search(common, limit: 10);
    expect(r.ayat.length, 10);
    expect(r.totalAyat, greaterThan(10));
  });

  test('results come back in mushaf order', () {
    final r = index.search(longestWord(const AyahRef(1, 2)).substring(0, 3));
    final refs = r.ayat.map((h) => h.ref).toList();
    final sorted = [...refs]..sort();
    expect(refs, sorted);
  });

  test('a query runs fast enough for type-ahead', () {
    final sw = Stopwatch()..start();
    for (var i = 0; i < 10; i++) {
      index.search(longestWord(AyahRef(2, i + 1)));
    }
    sw.stop();
    expect(sw.elapsedMilliseconds / 10, lessThan(50));
  });
}
