import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/quran.dart';
import '../../../domain/entities/quran_reading_settings.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/hadeel_bottom_sheet.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/quran_providers.dart';
import 'quran_style.dart';

Future<void> showReadingSettings(BuildContext context) => showHadeelBottomSheet<void>(
      context: context,
      builder: (_) => const ReadingSettingsSheet(),
    );

/// Font, size, spacing, mode and theme — applied live and saved locally.
class ReadingSettingsSheet extends ConsumerWidget {
  const ReadingSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final s = ref.watch(quranSettingsProvider);
    final themeMode = ref.watch(settingsProvider.select((x) => x.themeMode));
    final notifier = ref.read(settingsProvider.notifier);
    // Preview with a real ayah from the bundled text (Al-Fatiha 1:2).
    final sample = ref.watch(quranTextProvider).value?.ayah(const AyahRef(1, 2));

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.readingSettingsTitle, style: context.text.titleLarge),
            if (sample != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.brand.surfaceMuted,
                  borderRadius: AppRadius.lgAll,
                ),
                child: Text(
                  sample,
                  textAlign: TextAlign.center,
                  style: quranTextStyle(s, context.colors.onSurface),
                ),
              ),
            ],
            _Label(l10n.readingFontSize, trailing: context.formatters.number(s.fontSize.round())),
            Slider(
              value: s.fontSize,
              min: QuranReadingSettings.minFontSize,
              max: QuranReadingSettings.maxFontSize,
              divisions: 12,
              label: context.formatters.number(s.fontSize.round()),
              onChanged: (v) => notifier.updateQuranSettings((q) => q.copyWith(fontSize: v)),
            ),
            _Label(l10n.readingLineHeight, trailing: s.lineHeight.toStringAsFixed(1)),
            Slider(
              value: s.lineHeight,
              min: QuranReadingSettings.minLineHeight,
              max: QuranReadingSettings.maxLineHeight,
              divisions: 12,
              onChanged: (v) => notifier.updateQuranSettings((q) => q.copyWith(lineHeight: v)),
            ),
            _Label(l10n.readingFont),
            SegmentedButton<QuranFont>(
              segments: [
                ButtonSegment(value: QuranFont.amiri, label: Text(l10n.readingFontAmiri)),
                ButtonSegment(value: QuranFont.scheherazade, label: Text(l10n.readingFontScheherazade)),
              ],
              selected: {s.font},
              onSelectionChanged: (v) => notifier.updateQuranSettings((q) => q.copyWith(font: v.first)),
            ),
            _Label(l10n.readingMode),
            SegmentedButton<QuranReadingMode>(
              segments: [
                ButtonSegment(value: QuranReadingMode.verses, label: Text(l10n.readingModeVerses)),
                ButtonSegment(value: QuranReadingMode.continuous, label: Text(l10n.readingModeContinuous)),
              ],
              selected: {s.mode},
              onSelectionChanged: (v) => notifier.updateQuranSettings((q) => q.copyWith(mode: v.first)),
            ),
            _Label(l10n.themeModeLabel),
            SegmentedButton<AppThemeMode>(
              segments: [
                ButtonSegment(value: AppThemeMode.light, label: Text(l10n.themeLight)),
                ButtonSegment(value: AppThemeMode.dark, label: Text(l10n.themeDark)),
                ButtonSegment(value: AppThemeMode.system, label: Text(l10n.themeSystem)),
              ],
              selected: {themeMode},
              onSelectionChanged: (v) => notifier.setThemeMode(v.first),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, {this.trailing});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: AppSpacing.lg, bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(text, style: context.text.titleSmall)),
          if (trailing != null) Text(trailing!, style: context.text.labelMedium),
        ],
      ),
    );
  }
}
