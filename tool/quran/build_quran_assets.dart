// Converts the Tanzil Project sources in tool/quran/raw/ into the compact
// JSON assets the app loads offline.
//
// The Quran text is copied VERBATIM — no character is added, removed or
// normalized — as required by the Tanzil terms of use. The Tanzil
// copyright block is carried into every generated file.
//
// Run from the project root:
//   dart run tool/quran/build_quran_assets.dart
import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

const _rawDir = 'tool/quran/raw';
const _outDir = 'assets/quran';

void main() {
  Directory(_outDir).createSync(recursive: true);

  final uthmani = _readText('$_rawDir/quran-uthmani.xml');
  final clean = _readText('$_rawDir/quran-simple-clean.xml');
  final meta = XmlDocument.parse(File('$_rawDir/quran-data.xml').readAsStringSync());

  _writeJson('$_outDir/quran_uthmani.json', {
    'source': 'Tanzil Quran Text (Uthmani, Version 1.1) — https://tanzil.net',
    'license': uthmani.license,
    'bismillah': uthmani.bismillah,
    'suras': uthmani.suras,
  });
  _writeJson('$_outDir/quran_simple_clean.json', {
    'source': 'Tanzil Quran Text (Simple Clean, Version 1.1) — https://tanzil.net',
    'license': clean.license,
    'suras': clean.suras,
  });

  final suras = [
    for (final s in meta.findAllElements('sura'))
      {
        'index': int.parse(s.getAttribute('index')!),
        'ayas': int.parse(s.getAttribute('ayas')!),
        'start': int.parse(s.getAttribute('start')!),
        'name': s.getAttribute('name'),
        'tname': s.getAttribute('tname'),
        'ename': s.getAttribute('ename'),
        'type': s.getAttribute('type'),
        'order': int.parse(s.getAttribute('order')!),
      },
  ];
  List<Map<String, int>> positions(String tag) => [
        for (final e in meta.findAllElements(tag))
          {
            'index': int.parse(e.getAttribute('index')!),
            'sura': int.parse(e.getAttribute('sura')!),
            'aya': int.parse(e.getAttribute('aya')!),
          },
      ];

  _writeJson('$_outDir/quran_meta.json', {
    'source': 'Tanzil Quran Metadata (quran-data.xml) — https://tanzil.net, CC BY',
    'suras': suras,
    'juzs': positions('juz'),
    'quarters': positions('quarter'),
    'sajdas': [
      for (final e in meta.findAllElements('sajda'))
        {
          'sura': int.parse(e.getAttribute('sura')!),
          'aya': int.parse(e.getAttribute('aya')!),
          'type': e.getAttribute('type'),
        },
    ],
  });

  final ayahCount = uthmani.suras.fold<int>(0, (n, s) => n + s.length);
  stdout.writeln('Wrote ${uthmani.suras.length} suras, $ayahCount ayat to $_outDir');
}

class _QuranText {
  _QuranText(this.license, this.bismillah, this.suras);

  final String license;
  final String? bismillah;
  final List<List<String>> suras;
}

_QuranText _readText(String path) {
  final doc = XmlDocument.parse(File(path).readAsStringSync());
  final license = doc.children.whereType<XmlComment>().first.value.trim();

  String? bismillah;
  final suras = <List<String>>[];
  for (final sura in doc.findAllElements('sura')) {
    final ayat = <String>[];
    for (final aya in sura.findElements('aya')) {
      ayat.add(aya.getAttribute('text')!);
      bismillah ??= aya.getAttribute('bismillah');
    }
    suras.add(ayat);
  }
  return _QuranText(license, bismillah, suras);
}

void _writeJson(String path, Object data) {
  File(path).writeAsStringSync(const JsonEncoder().convert(data));
}
