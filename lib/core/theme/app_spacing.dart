import 'package:flutter/widgets.dart';

/// Spacing scale: 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  /// Horizontal gutter for screen content.
  static const double screenGutter = md;

  /// Minimum interactive size (Material / Apple HIG guidance).
  static const double minTouchTarget = 48;

  /// Content width cap for tablets / landscape so lines stay readable.
  static const double maxContentWidth = 640;

  static const EdgeInsetsDirectional screenPadding =
      EdgeInsetsDirectional.symmetric(horizontal: screenGutter);
}

/// Corner radius scale: 8 · 12 · 16 · 20.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
}

/// Motion tokens — short, calm, never bouncy.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Curve curve = Curves.easeOutCubic;
}
