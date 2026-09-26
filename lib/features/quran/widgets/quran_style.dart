import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/quran_reading_settings.dart';

String quranFontFamily(QuranFont font) => switch (font) {
      QuranFont.amiri => AppTypography.quranFont,
      QuranFont.scheherazade => AppTypography.quranFontAlt,
    };

TextStyle quranTextStyle(QuranReadingSettings s, Color color) => AppTypography.quran(
      color: color,
      fontSize: s.fontSize,
      height: s.lineHeight,
      family: quranFontFamily(s.font),
    );

const _arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

/// Ayah markers inside Quran text use Arabic-Indic digits, as in the
/// printed mushaf. UI chrome elsewhere uses the app's digit style.
String toArabicIndicDigits(int value) =>
    value.toString().split('').map((d) => _arabicIndic[int.parse(d)]).join();

/// End-of-ayah marker for continuous reading, e.g. `﴿١٢﴾`.
String ayahEndMarker(int ayah) => '﴿${toArabicIndicDigits(ayah)}﴾';
