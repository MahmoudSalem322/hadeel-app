import 'package:flutter/painting.dart';

/// Raw color tokens for Hadeel.
///
/// Values follow the brand palette, with small adjustments so text reaches
/// WCAG AA contrast (≥ 4.5:1) on its background. Widgets never read these
/// directly — they go through [ColorScheme] or `HadeelColors`.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF087481);
  static const Color primaryDarkTheme = Color(0xFF71E0DA);
  static const Color gold = Color(0xFFFFD083);
  static const Color goldDeep = Color(0xFF965918); // gold for text on light bg
  static const Color goldSoftDark = Color(0xFFFFD083); // gold on dark bg

  // Light theme
  static const Color backgroundLight = Color(0xFFF7F8FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceMutedLight = Color(0xFFEDF1FB);
  static const Color textPrimaryLight = Color(0xFF18223C);
  static const Color textSecondaryLight = Color(0xFF58647C); // AA on bg
  static const Color outlineLight = Color(0xFFDEE4F2);
  static const Color primaryContainerLight = Color(0xFFD9F4F2);

  // Dark theme (designed independently, not inverted)
  static const Color backgroundDark = Color(0xFF101526);
  static const Color surfaceDark = Color(0xFF1B2238);
  static const Color surfaceMutedDark = Color(0xFF252D45);
  static const Color textPrimaryDark = Color(0xFFF4F6FF);
  static const Color textSecondaryDark = Color(0xFFB0BBD5);
  static const Color outlineDark = Color(0xFF37415B);
  static const Color primaryContainerDark = Color(0xFF134651);
  static const Color heroDark = Color(0xFF125A75);

  // Feedback
  static const Color success = Color(0xFF3D8069);
  static const Color successDark = Color(0xFF6DB597);
  static const Color error = Color(0xFFB85C5C);
  static const Color errorDark = Color(0xFFE08A8A);

  // On-hero text (hero card is deep green in both themes)
  static const Color onHero = Color(0xFFF7F8FF);
  static const Color onHeroMuted = Color(0xFFE0F5FF);
}
