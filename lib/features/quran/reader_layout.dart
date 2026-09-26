import '../../domain/entities/quran_reading_settings.dart';

/// Maps a surah's ayat onto list items for the reader:
/// `[header, block…, footer]`. In verse mode each block is one ayah; in
/// continuous mode each block is a paragraph of [chunkSize] ayat, which
/// keeps long surahs virtualized instead of one giant text layout.
class ReaderLayout {
  const ReaderLayout({required this.ayahCount, required this.mode, this.chunkSize = 8})
      : assert(ayahCount > 0),
        assert(chunkSize > 0);

  final int ayahCount;
  final QuranReadingMode mode;
  final int chunkSize;

  int get _perBlock => mode == QuranReadingMode.verses ? 1 : chunkSize;

  int get blockCount => (ayahCount + _perBlock - 1) ~/ _perBlock;

  /// Header + blocks + footer.
  int get itemCount => blockCount + 2;

  int get footerIndex => itemCount - 1;

  bool isBlock(int index) => index >= 1 && index <= blockCount;

  /// List index of the block containing [ayah] (1-based).
  int indexOfAyah(int ayah) {
    final a = ayah.clamp(1, ayahCount);
    return 1 + (a - 1) ~/ _perBlock;
  }

  /// First and last ayah (inclusive) shown by block [index].
  (int, int) ayatOf(int index) {
    assert(isBlock(index));
    final first = (index - 1) * _perBlock + 1;
    final last = (first + _perBlock - 1).clamp(1, ayahCount);
    return (first, last);
  }

  /// The ayah a reader is "at" when item [index] is the top visible item.
  int ayahAtIndex(int index) {
    if (index <= 0) return 1;
    if (index >= footerIndex) return ayahCount;
    return ayatOf(index).$1;
  }
}
