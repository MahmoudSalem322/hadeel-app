import 'dart:convert';

import '../../domain/entities/content.dart';
import '../../domain/entities/quran.dart';

/// JSON mapping for the files produced by `tool/content/build_content_assets.dart`.
/// Parsers take the raw strings so they can run in a background isolate.
abstract final class ContentModels {
  static QuranText tafsirFromJson(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return QuranText(
      suras: [
        for (final sura in json['suras'] as List<dynamic>) (sura as List<dynamic>).cast<String>(),
      ],
    );
  }

  /// [raws] = (hisn_almuslim.json, categories.json).
  static HisnLibrary hisnFromJson((String, String) raws) {
    final hisn = jsonDecode(raws.$1) as Map<String, dynamic>;
    final cats = jsonDecode(raws.$2) as Map<String, dynamic>;

    final chapters = [
      for (final c in (hisn['chapters'] as List<dynamic>).cast<Map<String, dynamic>>())
        HisnChapter(
          id: c['id'] as int,
          title: c['title'] as String,
          items: [
            for (final i in (c['items'] as List<dynamic>).cast<Map<String, dynamic>>())
              DhikrItem(
                id: i['id'] as int,
                chapterId: c['id'] as int,
                text: i['text'] as String,
                repeat: ((i['repeat'] as int?) ?? 1).clamp(1, 1000),
              ),
          ],
        ),
    ];

    AyahRef ref(String s) => AyahRef.tryParse(s) ?? (throw FormatException('Bad ayah ref $s'));

    List<ContentCategory> categories(String key) => [
          for (final c in (cats[key] as List<dynamic>).cast<Map<String, dynamic>>())
            ContentCategory(
              key: c['key'] as String,
              chapterIds: ((c['chapters'] as List<dynamic>?) ?? const []).cast<int>(),
              quranDuas: [
                for (final q in ((c['quran'] as List<dynamic>?) ?? const []).cast<Map<String, dynamic>>())
                  QuranDua(
                    from: ref(q['from'] as String),
                    to: ref((q['to'] ?? q['from']) as String),
                    check: q['check'] as String,
                    prophet: q['prophet'] as String?,
                  ),
              ],
            ),
        ];

    return HisnLibrary(chapters: chapters, adhkar: categories('adhkar'), duas: categories('duas'));
  }

  static HadithLibrary hadithFromJson(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return HadithLibrary([
      for (final b in (json['books'] as List<dynamic>).cast<Map<String, dynamic>>())
        HadithBook(
          key: b['key'] as String,
          title: b['title'] as String,
          author: b['author'] as String,
          chapters: [
            for (final c in (b['chapters'] as List<dynamic>).cast<Map<String, dynamic>>())
              HadithChapter(c['id'] as int, c['title'] as String),
          ],
          hadiths: [
            for (final h in (b['hadiths'] as List<dynamic>).cast<Map<String, dynamic>>())
              Hadith(
                bookKey: b['key'] as String,
                number: h['n'] as int,
                chapterId: h['chapter'] as int,
                text: h['text'] as String,
              ),
          ],
        ),
    ]);
  }
}
