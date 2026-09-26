import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/app_settings.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/hadeel_bottom_sheet.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/hadeel_logo.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../shared/widgets/search_field.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/state_views.dart';
import '../settings/providers/settings_provider.dart';

/// Debug-only living spec of the design system: every token and component
/// in the current theme, with a theme switch to review light and dark.
class DesignGalleryScreen extends ConsumerWidget {
  const DesignGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mode = ref.watch(settingsProvider.select((s) => s.themeMode));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.galleryTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenGutter),
        children: [
          SegmentedButton<AppThemeMode>(
            segments: [
              ButtonSegment(value: AppThemeMode.light, label: Text(l10n.themeLight)),
              ButtonSegment(value: AppThemeMode.dark, label: Text(l10n.themeDark)),
              ButtonSegment(value: AppThemeMode.system, label: Text(l10n.themeSystem)),
            ],
            selected: {mode},
            onSelectionChanged: (s) => ref.read(settingsProvider.notifier).setThemeMode(s.first),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HadeelLogo(size: 72),
              const SizedBox(width: AppSpacing.md),
              HadeelLogo(size: 72, withBackground: false, markColor: context.colors.primary),
              const SizedBox(width: AppSpacing.md),
              const HadeelLogo(size: 36),
            ],
          ),
          SectionHeader(title: l10n.galleryColors),
          const _Swatches(),
          SectionHeader(title: l10n.galleryTypography),
          const _TypeScale(),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.gallerySampleAyahLabel, style: context.text.labelMedium),
          Text(
            l10n.appTagline,
            textAlign: TextAlign.center,
            style: AppTypography.quran(color: context.colors.onSurface),
          ),
          SectionHeader(title: l10n.galleryComponents),
          PrimaryButton(label: l10n.actionStartNow, onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(label: l10n.locationChooseCity, icon: Icons.location_city_rounded, onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(label: l10n.actionContinue, loading: true, onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          Center(child: TextButton(onPressed: () {}, child: Text(l10n.actionSkip))),
          const SizedBox(height: AppSpacing.md),
          SearchField(hint: l10n.gallerySearchHint),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              ChoiceChip(label: Text(l10n.featureAdhkar), selected: true, onSelected: (_) {}),
              ChoiceChip(label: Text(l10n.featureDuas), selected: false, onSelected: (_) {}),
              ChoiceChip(label: Text(l10n.featureHadith), selected: false, onSelected: (_) {}),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          HadeelCard(
            onTap: () {},
            child: Row(
              children: [
                ProgressRing(
                  progress: 0.66,
                  color: context.brand.gold,
                  trackColor: context.brand.surfaceMuted,
                  size: 56,
                  child: Text(context.formatters.number(22), style: context.text.titleSmall),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(l10n.gallerySampleText, style: context.text.bodyMedium)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => showHadeelBottomSheet<void>(
                    context: context,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        0,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      child: Text(l10n.gallerySampleText, style: context.text.bodyLarge),
                    ),
                  ),
                  child: const Icon(Icons.vertical_align_top_rounded),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.galleryTitle),
                      content: Text(l10n.gallerySampleText),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.actionClose),
                        ),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const LinearProgressIndicator(value: 0.4),
          SectionHeader(title: l10n.galleryStates),
          EmptyState(
            icon: Icons.favorite_outline_rounded,
            title: l10n.emptyFavoritesTitle,
            message: l10n.emptyFavoritesBody,
            actionLabel: l10n.actionExplore,
            onAction: () {},
          ),
          ErrorState(
            icon: Icons.location_off_outlined,
            title: l10n.locationErrorTitle,
            message: l10n.locationErrorDenied,
            actionLabel: l10n.locationChooseCityManually,
            onAction: () {},
            secondaryActionLabel: l10n.actionRetry,
            onSecondaryAction: () {},
          ),
        ],
      ),
    );
  }
}

class _Swatches extends StatelessWidget {
  const _Swatches();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final b = context.brand;
    final swatches = <(String, Color)>[
      ('primary', c.primary),
      ('gold', b.gold),
      ('hero', b.hero),
      ('background', context.theme.scaffoldBackgroundColor),
      ('surface', c.surface),
      ('muted', b.surfaceMuted),
      ('text', c.onSurface),
      ('text 2', b.textSecondary),
      ('success', b.success),
      ('error', c.error),
    ];
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final (name, color) in swatches)
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: b.divider),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(name, style: context.text.labelSmall, textDirection: TextDirection.ltr),
            ],
          ),
      ],
    );
  }
}

class _TypeScale extends StatelessWidget {
  const _TypeScale();

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    final sample = context.l10n.appTagline;
    final styles = <(String, TextStyle?)>[
      ('displaySmall', t.displaySmall),
      ('headlineSmall', t.headlineSmall),
      ('titleLarge', t.titleLarge),
      ('titleMedium', t.titleMedium),
      ('bodyLarge', t.bodyLarge),
      ('bodyMedium', t.bodyMedium),
      ('bodySmall', t.bodySmall),
      ('labelMedium', t.labelMedium),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, style) in styles) ...[
          Text(
            '$name · ${style?.fontSize?.toStringAsFixed(0)}',
            style: t.labelSmall,
            textDirection: TextDirection.ltr,
          ),
          Text(sample, style: style),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}
