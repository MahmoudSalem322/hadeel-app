import '../entities/content.dart';
import '../entities/quran.dart';

/// Bundled, verified religious content beyond the Quran text. Offline only.
abstract interface class ContentRepository {
  /// التفسير الميسر, indexed like the Quran text.
  Future<QuranText> loadTafsir();

  /// حصن المسلم with the app's adhkar and dua categories.
  Future<HisnLibrary> loadHisn();

  /// الأربعون النووية and رياض الصالحين.
  Future<HadithLibrary> loadHadith();
}
