// Builds the offline content assets (tafsir, adhkar/duas, hadith) from the
// raw sources in tool/*/raw/. Texts are copied verbatim; only the container
// format changes. Chapter titles referenced in categories.json must exist in
// the source, otherwise the build fails.
//
// Run from the project root:
//   dart run tool/content/build_content_assets.dart
import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

void main() {
  _buildTafsir();
  final chapterIds = _buildHisn();
  _buildCategories(chapterIds);
  _buildHadith();
}

String _read(String path) => File(path).readAsStringSync().replaceFirst('﻿', '');

void _write(String path, Object data) {
  File(path)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder().convert(data));
  stdout.writeln('wrote $path');
}

void _buildTafsir() {
  final doc = XmlDocument.parse(_read('tool/tafsir/raw/ar.muyassar.xml'));
  final suras = [
    for (final sura in doc.findAllElements('sura'))
      [for (final aya in sura.findElements('aya')) aya.getAttribute('text')!],
  ];
  _write('assets/tafsir/muyassar.json', {
    'source': 'التفسير الميسر — مجمع الملك فهد لطباعة المصحف الشريف، عبر مشروع تنزيل (tanzil.net, ar.muyassar)',
    'suras': suras,
  });
}

/// Returns chapter title → id.
Map<String, int> _buildHisn() {
  final index = jsonDecode(_read('tool/adhkar/raw/husn_ar.json')) as Map<String, dynamic>;
  final entries = (index.values.first as List<dynamic>).cast<Map<String, dynamic>>();
  final chapters = <Map<String, Object?>>[];
  final ids = <String, int>{};
  for (final e in entries) {
    final id = e['ID'] as int;
    final title = (e['TITLE'] as String).trim();
    final body = jsonDecode(_read('tool/adhkar/raw/chapters/$id.json')) as Map<String, dynamic>;
    final items = (body.values.first as List<dynamic>).cast<Map<String, dynamic>>();
    ids[title] = id;
    chapters.add({
      'id': id,
      'title': title,
      'items': [
        for (final it in items)
          {
            'id': it['ID'] as int,
            'text': (it['ARABIC_TEXT'] as String).trim(),
            'repeat': (it['REPEAT'] as int?) ?? 1,
          },
      ],
    });
  }
  _write('assets/adhkar/hisn_almuslim.json', {
    'source': 'حصن المسلم من أذكار الكتاب والسنة — سعيد بن علي بن وهف القحطاني (hisnmuslim.com)',
    'chapters': chapters,
  });
  return ids;
}

void _buildCategories(Map<String, int> chapterIds) {
  final config = jsonDecode(_read('tool/content/categories.json')) as Map<String, dynamic>;

  List<int> resolve(List<dynamic> titles) => [
        for (final t in titles.cast<String>())
          chapterIds[t.trim()] ?? (throw StateError('Hisn chapter not found: "$t"')),
      ];

  Map<String, Object?> category(Map<String, dynamic> c) => {
        'key': c['key'],
        if (c['chapters'] != null) 'chapters': resolve(c['chapters'] as List<dynamic>),
        if (c['quran'] != null) 'quran': c['quran'],
      };

  _write('assets/adhkar/categories.json', {
    'adhkar': [for (final c in (config['adhkar'] as List<dynamic>).cast<Map<String, dynamic>>()) category(c)],
    'duas': [for (final c in (config['duas'] as List<dynamic>).cast<Map<String, dynamic>>()) category(c)],
  });
}

void _buildHadith() {
  Map<String, Object?> book(String file, String key) {
    final json = jsonDecode(_read('tool/hadith/raw/$file')) as Map<String, dynamic>;
    final meta = (json['metadata'] as Map<String, dynamic>)['arabic'] as Map<String, dynamic>;
    return {
      'key': key,
      'title': meta['title'],
      'author': meta['author'],
      'chapters': [
        for (final c in (json['chapters'] as List<dynamic>).cast<Map<String, dynamic>>())
          {'id': c['id'], 'title': (c['arabic'] as String).trim()},
      ],
      'hadiths': [
        for (final h in (json['hadiths'] as List<dynamic>).cast<Map<String, dynamic>>())
          {
            'n': h['idInBook'],
            'chapter': h['chapterId'],
            'text': (h['arabic'] as String).trim(),
          },
      ],
    };
  }

  _write('assets/hadith/hadith.json', {
    'source': 'Sunnah.com (via github.com/AhmedBaset/hadith-json)',
    'books': [book('nawawi40.json', 'nawawi40'), book('riyad_assalihin.json', 'riyad')],
  });
}
