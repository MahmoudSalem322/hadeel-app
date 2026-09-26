import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/content_providers.dart';
import '../../core/providers/core_providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/quran.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/hadeel_bottom_sheet.dart';
import '../quran/widgets/quran_style.dart';
import '../settings/providers/settings_provider.dart';

Future<void> showTafsir(BuildContext context, {required AyahRef ref, required String ayahText}) {
  return showHadeelBottomSheet<void>(
    context: context,
    expand: true,
    builder: (_) => TafsirSheet(ayah: ref, ayahText: ayahText),
  );
}

/// التفسير الميسر for one ayah, with its source stated.
class TafsirSheet extends ConsumerWidget {
  const TafsirSheet({super.key, required this.ayah, required this.ayahText});

  final AyahRef ayah;
  final String ayahText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surah = ref.watch(quranMetaProvider).surah(ayah.surah);
    final settings = ref.watch(quranSettingsProvider);
    final tafsir = ref.watch(tafsirProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
      children: [
        Text(l10n.tafsirTitle, style: context.text.titleLarge),
        Text(
          l10n.ayahPosition(surah.nameAr, context.formatters.number(ayah.ayah)),
          style: context.text.labelMedium!.copyWith(color: context.brand.goldText),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: context.brand.surfaceMuted, borderRadius: AppRadius.lgAll),
          child: Text(
            ayahText,
            style: quranTextStyle(settings.copyWith(fontSize: 22, lineHeight: 1.9), context.colors.onSurface),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        tafsir.when(
          data: (t) => SelectableText(t.ayah(ayah), style: context.text.bodyLarge),
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Text(l10n.tafsirLoadError, style: context.text.bodyMedium),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.tafsirSource, style: context.text.labelSmall),
      ],
    );
  }
}
