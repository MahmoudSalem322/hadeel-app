import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Brand tokens that don't map onto Material's [ColorScheme].
@immutable
class HadeelColors extends ThemeExtension<HadeelColors> {
  const HadeelColors({
    required this.gold,
    required this.goldText,
    required this.hero,
    required this.onHero,
    required this.onHeroMuted,
    required this.surfaceMuted,
    required this.textSecondary,
    required this.divider,
    required this.success,
    required this.highlight,
  });

  /// Accent gold for icons, rings and small marks — use sparingly.
  final Color gold;

  /// Gold that is legible as text on the current background.
  final Color goldText;

  /// Background of the hero surface (next-prayer card, splash accents).
  final Color hero;
  final Color onHero;
  final Color onHeroMuted;

  final Color surfaceMuted;
  final Color textSecondary;
  final Color divider;
  final Color success;

  /// Subtle fill for the currently highlighted row (e.g. next prayer).
  final Color highlight;

  static const HadeelColors light = HadeelColors(
    gold: AppColors.gold,
    goldText: AppColors.goldDeep,
    hero: AppColors.primary,
    onHero: AppColors.onHero,
    onHeroMuted: AppColors.onHeroMuted,
    surfaceMuted: AppColors.surfaceMutedLight,
    textSecondary: AppColors.textSecondaryLight,
    divider: AppColors.outlineLight,
    success: AppColors.success,
    highlight: AppColors.primaryContainerLight,
  );

  static const HadeelColors dark = HadeelColors(
    gold: AppColors.gold,
    goldText: AppColors.goldSoftDark,
    hero: AppColors.heroDark,
    onHero: AppColors.textPrimaryDark,
    onHeroMuted: AppColors.textSecondaryDark,
    surfaceMuted: AppColors.surfaceMutedDark,
    textSecondary: AppColors.textSecondaryDark,
    divider: AppColors.outlineDark,
    success: AppColors.successDark,
    highlight: AppColors.primaryContainerDark,
  );

  @override
  HadeelColors copyWith({
    Color? gold,
    Color? goldText,
    Color? hero,
    Color? onHero,
    Color? onHeroMuted,
    Color? surfaceMuted,
    Color? textSecondary,
    Color? divider,
    Color? success,
    Color? highlight,
  }) {
    return HadeelColors(
      gold: gold ?? this.gold,
      goldText: goldText ?? this.goldText,
      hero: hero ?? this.hero,
      onHero: onHero ?? this.onHero,
      onHeroMuted: onHeroMuted ?? this.onHeroMuted,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      textSecondary: textSecondary ?? this.textSecondary,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  HadeelColors lerp(HadeelColors? other, double t) {
    if (other == null) return this;
    return HadeelColors(
      gold: Color.lerp(gold, other.gold, t)!,
      goldText: Color.lerp(goldText, other.goldText, t)!,
      hero: Color.lerp(hero, other.hero, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
      onHeroMuted: Color.lerp(onHeroMuted, other.onHeroMuted, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
    );
  }
}
