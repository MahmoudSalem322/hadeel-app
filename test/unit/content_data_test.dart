import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/utils/arabic_normalizer.dart';
import 'package:hadeel/domain/entities/content.dart';
import 'package:hadeel/domain/entities/quran.dart';
import 'package:xml/xml.dart';

import '../helpers/test_harness.dart';

/// Guards the integrity of bundled religious content: every text must equal
/// its source verbatim, and every Quranic dua reference must point at the
/// ayah it claims to.
void main() {
  String raw(String path) => File(path).readAsStringSync().replaceFirst('﻿', '');

  group('Tafsir al-Muyassar', () {
    final tafsir = loadTafsirText();
    final meta = loadQuranMeta();

    test('is verbatim from the Tanzil source, one entry per ayah', () {
      final doc = XmlDocument.parse(raw('tool/tafsir/raw/ar.muyassar.xml'));
      final suras = doc.findAllElements('sura').toList();
      expect(suras.length, 114);
      for (var s = 0; s < 114; s++) {
        final ayat = [for (final a in suras[s].findElements('aya')) a.getAttribute('text')!];
        expect(tafsir.suras[s], ayat, reason: 'surah ${s + 1}');
        expect(ayat.length, meta.surah(s + 1).ayahCount);
      }
    });
  });

  group('Hisn al-Muslim', () {
    final hisn = loadHisnLibrary();

    test('has all 132 chapters with every item verbatim', () {
      final index = jsonDecode(raw('tool/adhkar/raw/husn_ar.json')) as Map<String, dynamic>;
      final entries = (index.values.first as List<dynamic>).cast<Map<String, dynamic>>();
      expect(hisn.chapters.length, entries.length);
      expect(hisn.chapters.length, 132);

      var items = 0;
      for (final e in entries) {
        final id = e['ID'] as int;
        final body = jsonDecode(raw('tool/adhkar/raw/chapters/$id.json')) as Map<String, dynamic>;
        final source = (body.values.first as List<dynamic>).cast<Map<String, dynamic>>();
        final chapter = hisn.chapter(id)!;
        expect(chapter.title, (e['TITLE'] as String).trim());
        expect(chapter.items.length, source.length, reason: 'chapter $id');
        for (var i = 0; i < source.length; i++) {
          expect(chapter.items[i].text, (source[i]['ARABIC_TEXT'] as String).trim());
          expect(chapter.items[i].repeat, source[i]['REPEAT']);
        }
        items += source.length;
      }
      expect(items, 267);
    });

    test('every configured category resolves to real content', () {
      for (final c in [...hisn.adhkar, ...hisn.duas]) {
        expect(c.chapterIds.isNotEmpty || c.quranDuas.isNotEmpty, isTrue, reason: c.key);
        for (final id in c.chapterIds) {
          expect(hisn.chapter(id), isNotNull, reason: '${c.key} → $id');
        }
      }
      expect(hisn.adhkarCategory('morning_evening'), isNotNull);
      expect(hisn.adhkarCategory('after_prayer'), isNotNull);
      expect(hisn.duaCategory('quranic')!.quranDuas, isNotEmpty);
      expect(hisn.duaCategory('prophets')!.quranDuas, isNotEmpty);
    });

    test('Quranic dua references point at the ayat they claim', () {
      final meta = loadQuranMeta();
      final quran = loadQuranSearchText();
      for (final c in hisn.duas) {
        for (final d in c.quranDuas) {
          expect(d.to.surah, d.from.surah, reason: d.key);
          expect(meta.isValid(d.from) && meta.isValid(d.to), isTrue, reason: d.key);
          final text = normalizeArabic(d.ayat.map(quran.ayah).join(' '));
          expect(text, contains(normalizeArabic(d.check)), reason: '${d.key} should contain "${d.check}"');
        }
      }
    });

    test('dua keys round-trip for favorites', () {
      final d = hisn.duaCategory('quranic')!.quranDuas.first;
      final back = QuranDua.tryParseKey(d.key)!;
      expect(back.from, d.from);
      expect(back.to, d.to);
      expect(QuranDua.tryParseKey('q:0:1-1'), isNull);
      expect(QuranDua.tryParseKey('nonsense'), isNull);
      expect(hisn.itemByKey(hisn.chapters.first.items.first.key), hisn.chapters.first.items.first);
    });
  });

  group('Hadith', () {
    final lib = loadHadithLibrary();

    test('Nawawi 40 has 42 hadith and Riyad as-Salihin 1896, verbatim', () {
      for (final (file, key, count) in [
        ('nawawi40.json', 'nawawi40', 42),
        ('riyad_assalihin.json', 'riyad', 1896),
      ]) {
        final source = jsonDecode(raw('tool/hadith/raw/$file')) as Map<String, dynamic>;
        final hadiths = (source['hadiths'] as List<dynamic>).cast<Map<String, dynamic>>();
        final book = lib.book(key)!;
        expect(book.hadiths.length, count);
        for (var i = 0; i < hadiths.length; i++) {
          expect(book.hadiths[i].text, (hadiths[i]['arabic'] as String).trim());
          expect(book.hadiths[i].number, hadiths[i]['idInBook']);
        }
      }
    });

    test('lookup by favorite key', () {
      final h = lib.byKey('nawawi40:1');
      expect(h, isNotNull);
      expect(h!.number, 1);
      expect(lib.byKey('nawawi40:999'), isNull);
      expect(lib.byKey('unknown:1'), isNull);
    });
  });

  test('ayah refs used by duas are well-formed', () {
    expect(const AyahRef(2, 201).key, '2:201');
  });
}
