import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/domain/entities/quran_reading_settings.dart';
import 'package:hadeel/features/quran/reader_layout.dart';
import 'package:hadeel/features/quran/widgets/quran_style.dart';

void main() {
  group('verse mode', () {
    const layout = ReaderLayout(ayahCount: 7, mode: QuranReadingMode.verses);

    test('one item per ayah plus header and footer', () {
      expect(layout.itemCount, 9);
      expect(layout.footerIndex, 8);
      expect(layout.indexOfAyah(1), 1);
      expect(layout.indexOfAyah(7), 7);
      expect(layout.ayatOf(3), (3, 3));
    });

    test('header maps to ayah 1 and footer to the last ayah', () {
      expect(layout.ayahAtIndex(0), 1);
      expect(layout.ayahAtIndex(8), 7);
    });

    test('out-of-range ayat are clamped', () {
      expect(layout.indexOfAyah(0), 1);
      expect(layout.indexOfAyah(99), 7);
    });
  });

  group('continuous mode', () {
    const layout = ReaderLayout(ayahCount: 20, mode: QuranReadingMode.continuous, chunkSize: 8);

    test('ayat are grouped into paragraphs', () {
      expect(layout.blockCount, 3);
      expect(layout.ayatOf(1), (1, 8));
      expect(layout.ayatOf(2), (9, 16));
      expect(layout.ayatOf(3), (17, 20));
    });

    test('an ayah maps to its paragraph', () {
      expect(layout.indexOfAyah(8), 1);
      expect(layout.indexOfAyah(9), 2);
      expect(layout.indexOfAyah(20), 3);
      expect(layout.ayahAtIndex(2), 9);
    });
  });

  test('ayah markers use Arabic-Indic digits inside ornate parentheses', () {
    expect(toArabicIndicDigits(2026), '٢٠٢٦');
    expect(ayahEndMarker(12), '﴿١٢﴾');
  });

  test('reading settings clamp to safe ranges', () {
    const s = QuranReadingSettings();
    expect(s.copyWith(fontSize: 100).fontSize, QuranReadingSettings.maxFontSize);
    expect(s.copyWith(lineHeight: 0.5).lineHeight, QuranReadingSettings.minLineHeight);
  });
}
