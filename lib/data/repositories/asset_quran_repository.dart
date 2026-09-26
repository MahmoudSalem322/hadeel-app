import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/quran.dart';
import '../../domain/repositories/quran_repository.dart';
import '../models/quran_models.dart';

/// Loads the Tanzil-derived assets bundled with the app. Large texts are
/// decoded off the UI thread and only when first needed.
class AssetQuranRepository implements QuranRepository {
  AssetQuranRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  static const String metaAsset = 'assets/quran/quran_meta.json';
  static const String readingAsset = 'assets/quran/quran_uthmani.json';
  static const String searchAsset = 'assets/quran/quran_simple_clean.json';

  @override
  Future<QuranMeta> loadMeta() async =>
      QuranModels.metaFromJson(await _bundle.loadString(metaAsset));

  @override
  Future<QuranText> loadReadingText() => _loadText(readingAsset);

  @override
  Future<QuranText> loadSearchText() => _loadText(searchAsset);

  Future<QuranText> _loadText(String asset) async {
    final raw = await _bundle.loadString(asset, cache: false);
    return compute(QuranModels.textFromJson, raw, debugLabel: 'decode $asset');
  }
}
