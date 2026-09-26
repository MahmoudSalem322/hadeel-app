import 'package:flutter/material.dart';

/// Arabic-first type scale built on IBM Plex Sans Arabic.
///
/// Arabic glyphs have tall ascenders/descenders and diacritics, so line
/// heights are generous (1.5–1.7) and letter spacing is always 0 — tracking
/// breaks cursive joining. Body text never goes below 16sp.
abstract final class AppTypography {
  static const String uiFont = 'IBMPlexSansArabic';
  static const String quranFont = 'AmiriQuran';

  static TextTheme textTheme(Color primary, Color secondary) {
    TextStyle style(double size, FontWeight weight, double height, Color color) {
      return TextStyle(
        fontFamily: uiFont,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: 0,
        color: color,
      );
    }

    return TextTheme(
      displayLarge: style(44, FontWeight.w600, 1.25, primary),
      displayMedium: style(36, FontWeight.w600, 1.3, primary),
      displaySmall: style(30, FontWeight.w600, 1.3, primary),
      headlineLarge: style(28, FontWeight.w600, 1.35, primary),
      headlineMedium: style(24, FontWeight.w600, 1.4, primary),
      headlineSmall: style(21, FontWeight.w600, 1.4, primary),
      titleLarge: style(19, FontWeight.w600, 1.45, primary),
      titleMedium: style(17, FontWeight.w600, 1.5, primary),
      titleSmall: style(15, FontWeight.w600, 1.5, primary),
      bodyLarge: style(17, FontWeight.w400, 1.7, primary),
      bodyMedium: style(16, FontWeight.w400, 1.65, primary),
      bodySmall: style(14, FontWeight.w400, 1.6, secondary),
      labelLarge: style(16, FontWeight.w600, 1.4, primary),
      labelMedium: style(14, FontWeight.w500, 1.4, secondary),
      labelSmall: style(12, FontWeight.w500, 1.4, secondary),
    );
  }

  /// Quran reading style — size and line height are user-adjustable later.
  static TextStyle quran({
    required Color color,
    double fontSize = 26,
    double height = 2.0,
  }) {
    return TextStyle(
      fontFamily: quranFont,
      fontSize: fontSize,
      height: height,
      letterSpacing: 0,
      color: color,
    );
  }

  /// Tabular figures keep the countdown from jittering as digits change.
  static const List<FontFeature> tabularFigures = [FontFeature.tabularFigures()];
}
