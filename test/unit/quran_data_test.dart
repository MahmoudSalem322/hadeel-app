import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/domain/entities/quran.dart';
import 'package:xml/xml.dart';

import '../helpers/test_harness.dart';

/// Guards the integrity of the bundled Quran: every ayah must equal the
/// Tanzil source character for character, in the original order.
void main() {
  final meta = loadQuranMeta();
  final reading = loadQuranReadingText();
  final search = loadQuranSearchText();

  List<List<String>> rawAyat(String file) {
    final doc = XmlDocument.parse(File('tool/quran/raw/$file').readAsStringSync());
    return [
      for (final sura in doc.findAllElements('sura'))
        [for (final aya in sura.findElements('aya')) aya.getAttribute('text')!],
    ];
  }

  test('Uthmani text is verbatim from Tanzil', () {
    final raw = rawAyat('quran-uthmani.xml');
    expect(reading.suras.length, raw.length);
    for (var s = 0; s < raw.length; s++) {
      expect(reading.suras[s], raw[s], reason: 'surah ${s + 1}');
    }
  });

  test('search text is verbatim from Tanzil Simple Clean', () {
    final raw = rawAyat('quran-simple-clean.xml');
    for (var s = 0; s < raw.length; s++) {
      expect(search.suras[s], raw[s], reason: 'surah ${s + 1}');
    }
  });

  test('Basmala header comes from the source attribute', () {
    final doc = XmlDocument.parse(File('tool/quran/raw/quran-uthmani.xml').readAsStringSync());
    final attr = doc.findAllElements('aya').map((a) => a.getAttribute('bismillah')).whereType<String>().first;
    expect(reading.bismillah, attr);
    // Al-Fatiha's first ayah is the Basmala itself, so no separate header there.
    expect(reading.ayah(const AyahRef(1, 1)), attr);
    expect(showsBasmalaHeader(1), isFalse);
    expect(showsBasmalaHeader(9), isFalse);
    expect(showsBasmalaHeader(2), isTrue);
  });

  test('structure: 114 surahs, 6236 ayat, counts agree everywhere', () {
    expect(meta.surahs.length, 114);
    expect(meta.totalAyat, 6236);
    var start = 0;
    for (final s in meta.surahs) {
      expect(s.startIndex, start, reason: 'start of ${s.number}');
      expect(reading.surah(s.number).length, s.ayahCount, reason: 'reading ${s.number}');
      expect(search.surah(s.number).length, s.ayahCount, reason: 'search ${s.number}');
      start += s.ayahCount;
    }
  });

  test('metadata: 30 juz, 240 quarters, 15 sajdas, 86 Meccan / 28 Medinan', () {
    expect(meta.juzs.length, 30);
    expect(meta.juzs.first.start, const AyahRef(1, 1));
    expect(meta.quarterStarts.length, 240);
    expect(meta.sajdas.length, 15);
    expect(meta.surahs.where((s) => s.revelationType == RevelationType.meccan).length, 86);
    expect(meta.surahs.where((s) => s.revelationType == RevelationType.medinan).length, 28);
    for (final j in meta.juzs) {
      expect(meta.isValid(j.start), isTrue);
    }
  });

  test('assets carry the Tanzil copyright notice', () {
    for (final f in ['quran_uthmani.json', 'quran_simple_clean.json']) {
      final json = jsonDecode(File('assets/quran/$f').readAsStringSync()) as Map<String, dynamic>;
      expect(json['license'] as String, contains('Tanzil Project'));
      expect(json['license'] as String, contains('CHANGING IT IS NOT ALLOWED'));
      expect(json['source'] as String, contains('tanzil.net'));
    }
  });

  group('QuranMeta helpers', () {
    test('globalIndex and juzOf', () {
      expect(meta.globalIndex(const AyahRef(1, 1)), 0);
      expect(meta.globalIndex(const AyahRef(114, 6)), 6235);
      expect(meta.juzOf(const AyahRef(1, 1)).number, 1);
      expect(meta.juzOf(meta.juzs[1].start).number, 2);
      expect(meta.juzOf(const AyahRef(114, 6)).number, 30);
    });

    test('isValid rejects ayat past the end of a surah', () {
      expect(meta.isValid(const AyahRef(1, 7)), isTrue);
      expect(meta.isValid(const AyahRef(1, 8)), isFalse);
    });

    test('AyahRef keys round-trip and reject junk', () {
      expect(AyahRef.tryParse(const AyahRef(2, 255).key), const AyahRef(2, 255));
      expect(AyahRef.tryParse('115:1'), isNull);
      expect(AyahRef.tryParse('x'), isNull);
      expect(AyahRef.tryParse('2:0'), isNull);
    });
  });
}
