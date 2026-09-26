import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/app_settings.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'hadeel_colors.dart';

abstract final class AppTheme {
  static Color _getSeedColor(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.green:
        return AppColors.primary;
      case AppColorTheme.blue:
        return const Color(0xFF1A5F7A);
      case AppColorTheme.brown:
        return const Color(0xFF795548);
      case AppColorTheme.purple:
        return const Color(0xFF673AB7);
    }
  }

  static ThemeData light([AppColorTheme theme = AppColorTheme.green]) {
    final seed = _getSeedColor(theme);
    final isDefault = theme == AppColorTheme.green;
    return _build(
      brightness: Brightness.light,
      scheme: (isDefault ? const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: AppColors.primaryContainerLight,
        onPrimaryContainer: AppColors.primary,
        secondary: AppColors.goldDeep,
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFF1E3BF),
        onSecondaryContainer: Color(0xFF3A3220),
        error: AppColors.error,
        onError: Color(0xFFFFFFFF),
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        surfaceContainerLowest: AppColors.surfaceLight,
        surfaceContainerLow: Color(0xFFF5F4F0),
        surfaceContainer: AppColors.surfaceMutedLight,
        surfaceContainerHigh: Color(0xFFEBEAE5),
        surfaceContainerHighest: Color(0xFFE3E2DD),
        outline: AppColors.outlineLight,
        outlineVariant: Color(0xFFC7C5BE),
        shadow: Color(0x33000000),
      ) : ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light)),
      background: (isDefault ? AppColors.backgroundLight : ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light).surface),
      brand: HadeelColors.light,
    );
  }

  static ThemeData dark([AppColorTheme theme = AppColorTheme.green]) {
    final seed = _getSeedColor(theme);
    final isDefault = theme == AppColorTheme.green;
    return _build(
      brightness: Brightness.dark,
      scheme: (isDefault ? const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDarkTheme,
        onPrimary: Color(0xFF003828),
        primaryContainer: AppColors.primaryContainerDark,
        onPrimaryContainer: AppColors.primaryDarkTheme,
        secondary: AppColors.goldSoftDark,
        onSecondary: Color(0xFF3A3220),
        secondaryContainer: Color(0xFF3A3220),
        onSecondaryContainer: Color(0xFFF1E3BF),
        error: AppColors.errorDark,
        onError: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        surfaceContainerLowest: AppColors.backgroundDark,
        surfaceContainerLow: Color(0xFF111D1A),
        surfaceContainer: AppColors.surfaceMutedDark,
        surfaceContainerHigh: Color(0xFF203330),
        surfaceContainerHighest: Color(0xFF273C38),
        outline: Color(0xFF3A504A),
        outlineVariant: AppColors.outlineDark,
        shadow: Color(0x66000000),
      ) : ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark)),
      background: (isDefault ? AppColors.backgroundDark : ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark).surface),
      brand: HadeelColors.dark,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color background,
    required HadeelColors brand,
  }) {
    final textTheme = AppTypography.textTheme(scheme.onSurface, brand.textSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: AppTypography.uiFont,
      textTheme: textTheme,
      extensions: [brand],
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      dividerTheme: DividerThemeData(color: brand.divider, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: brand.divider),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        indicatorColor: scheme.primaryContainer,
        indicatorShape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium!.copyWith(
            color: selected ? scheme.onSurface : brand.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? scheme.primary : brand.textSecondary,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: textTheme.labelLarge,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          side: BorderSide(color: scheme.outline),
          foregroundColor: scheme.onSurface,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: scheme.onSurface,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: brand.divider),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        labelStyle: textTheme.labelMedium!.copyWith(color: scheme.onSurface),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
        showCheckmark: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brand.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        hintStyle: textTheme.bodyMedium!.copyWith(color: brand.textSecondary),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: scheme.outline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.onSurface,
        unselectedLabelColor: brand.textSecondary,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
        indicatorColor: scheme.primary,
        dividerColor: brand.divider,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md),
        minVerticalPadding: AppSpacing.sm,
        iconColor: scheme.primary,
        titleTextStyle: textTheme.titleSmall,
        subtitleTextStyle: textTheme.bodySmall,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: brand.surfaceMuted,
        circularTrackColor: brand.surfaceMuted,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        contentTextStyle: textTheme.bodyMedium!.copyWith(color: scheme.surface),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: const {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}



