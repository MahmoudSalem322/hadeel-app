import 'dart:convert';

import '../../domain/entities/quran.dart';

/// JSON mapping for the files produced by `tool/quran/build_quran_assets.dart`.
abstract final class QuranModels {
  static QuranMeta metaFromJson(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    AyahRef ref(Map<String, dynamic> e) => AyahRef(e['sura'] as int, e['aya'] as int);

    return QuranMeta(
      surahs: [
        for (final s in (json['suras'] as List<dynamic>).cast<Map<String, dynamic>>())
          Surah(
            number: s['index'] as int,
            nameAr: s['name'] as String,
            nameTransliterated: s['tname'] as String,
            nameEn: s['ename'] as String,
            ayahCount: s['ayas'] as int,
            startIndex: s['start'] as int,
            revelationType:
                s['type'] == 'Medinan' ? RevelationType.medinan : RevelationType.meccan,
            revelationOrder: s['order'] as int,
          ),
      ],
      juzs: [
        for (final j in (json['juzs'] as List<dynamic>).cast<Map<String, dynamic>>())
          Juz(j['index'] as int, ref(j)),
      ],
      quarterStarts: [
        for (final q in (json['quarters'] as List<dynamic>).cast<Map<String, dynamic>>()) ref(q),
      ],
      sajdas: {
        for (final s in (json['sajdas'] as List<dynamic>).cast<Map<String, dynamic>>()) ref(s),
      },
    );
  }

  /// Top-level so it can run in a background isolate via `compute`.
  static QuranText textFromJson(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return QuranText(
      bismillah: json['bismillah'] as String?,
      suras: [
        for (final sura in json['suras'] as List<dynamic>) (sura as List<dynamic>).cast<String>(),
      ],
    );
  }
}
