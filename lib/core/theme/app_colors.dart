import 'package:flutter/painting.dart';

/// Raw color tokens for Hadeel.
///
/// Values follow the brand palette, with small adjustments so text reaches
/// WCAG AA contrast (≥ 4.5:1) on its background. Widgets never read these
/// directly — they go through [ColorScheme] or `HadeelColors`.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF123C35);
  static const Color primaryDarkTheme = Color(0xFF6FB8A2);
  static const Color gold = Color(0xFFC9A85D);
  static const Color goldDeep = Color(0xFF8F7030); // gold for text on light bg
  static const Color goldSoftDark = Color(0xFFD4B774); // gold on dark bg

  // Light theme
  static const Color backgroundLight = Color(0xFFF8F7F2);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceMutedLight = Color(0xFFF0EEE6);
  static const Color textPrimaryLight = Color(0xFF17201D);
  static const Color textSecondaryLight = Color(0xFF5B6560); // AA on bg
  static const Color outlineLight = Color(0xFFE3E0D6);
  static const Color primaryContainerLight = Color(0xFFDCEAE4);

  // Dark theme (designed independently, not inverted)
  static const Color backgroundDark = Color(0xFF0D1715);
  static const Color surfaceDark = Color(0xFF14211E);
  static const Color surfaceMutedDark = Color(0xFF1B2B27);
  static const Color textPrimaryDark = Color(0xFFEDEBE4);
  static const Color textSecondaryDark = Color(0xFFA9B2AD);
  static const Color outlineDark = Color(0xFF263833);
  static const Color primaryContainerDark = Color(0xFF1A3C35);
  static const Color heroDark = Color(0xFF16332D);

  // Feedback
  static const Color success = Color(0xFF3D8069);
  static const Color successDark = Color(0xFF6DB597);
  static const Color error = Color(0xFFB85C5C);
  static const Color errorDark = Color(0xFFE08A8A);

  // On-hero text (hero card is deep green in both themes)
  static const Color onHero = Color(0xFFF8F7F2);
  static const Color onHeroMuted = Color(0xFFBFD0C9);
}
