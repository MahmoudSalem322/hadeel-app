import 'package:meta/meta.dart';

/// Where the reader stopped in the Quran. Populated from Phase 4 onwards.
@immutable
class ReadingProgress {
  const ReadingProgress({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.fraction,
  }) : assert(fraction >= 0 && fraction <= 1);

  final int surahNumber;

  /// Name as stored in the bundled Quran metadata.
  final String surahName;
  final int ayahNumber;

  /// Share of the whole mushaf read, in `[0, 1]`.
  final double fraction;
}
