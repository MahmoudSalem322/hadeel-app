import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/content.dart';
import '../../domain/entities/quran.dart';
import '../../domain/repositories/content_repository.dart';
import '../models/content_models.dart';

/// Loads bundled content lazily, decoding large files off the UI thread.
class AssetContentRepository implements ContentRepository {
  AssetContentRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  static const String tafsirAsset = 'assets/tafsir/muyassar.json';
  static const String hisnAsset = 'assets/adhkar/hisn_almuslim.json';
  static const String categoriesAsset = 'assets/adhkar/categories.json';
  static const String hadithAsset = 'assets/hadith/hadith.json';

  @override
  Future<QuranText> loadTafsir() async =>
      compute(ContentModels.tafsirFromJson, await _bundle.loadString(tafsirAsset, cache: false));

  @override
  Future<HisnLibrary> loadHisn() async {
    final hisn = await _bundle.loadString(hisnAsset, cache: false);
    final cats = await _bundle.loadString(categoriesAsset, cache: false);
    return compute(ContentModels.hisnFromJson, (hisn, cats));
  }

  @override
  Future<HadithLibrary> loadHadith() async =>
      compute(ContentModels.hadithFromJson, await _bundle.loadString(hadithAsset, cache: false));
}
