import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/content_providers.dart';
import '../../core/providers/core_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/content.dart';
import '../../domain/entities/library.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/state_views.dart';
import '../quran/providers/quran_providers.dart';
import '../quran/widgets/quran_style.dart';
import '../settings/providers/settings_provider.dart';

class DuaCategoryScreen extends ConsumerWidget {
  const DuaCategoryScreen({super.key, required this.categoryKey});

  final String categoryKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(l10n.duaCategory(categoryKey)),
      ),
      body: ResponsiveBody(
        child: ContentAsync<HisnLibrary>(
          value: ref.watch(hisnProvider),
          onRetry: () => ref.invalidate(hisnProvider),
          data: (lib) {
            final category = lib.duaCategory(categoryKey);
            if (category == null) {
              return EmptyState(
                icon: Icons.search_off_rounded,
                title: l10n.contentLoadError,
              );
            }
            final items = lib.itemsOf(category);
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screenGutter),
              children: [
                for (final dua in category.quranDuas) ...[
                  QuranDuaCard(dua: dua),
                  const SizedBox(height: AppSpacing.sm),
                ],
                for (final item in items) ...[
                  DhikrCard(item: item, kind: FavoriteKind.dua),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// A Quranic dua rendered from the verified mushaf text by reference.
class QuranDuaCard extends ConsumerWidget {
  const QuranDuaCard({super.key, required this.dua});

  final QuranDua dua;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surah = ref.watch(quranMetaProvider).surah(dua.from.surah);
    final settings = ref.watch(quranSettingsProvider);
    final quran = ref.watch(quranTextProvider).value;
    final f = context.formatters;

    final ayatLabel = dua.from.ayah == dua.to.ayah
        ? f.number(dua.from.ayah)
        : '${f.number(dua.from.ayah)}-${f.number(dua.to.ayah)}';
    final reference = l10n.quranReference(surah.nameAr, ayatLabel);
    final text = quran == null
        ? null
        : [
            for (final a in dua.ayat)
              '${quran.ayah(a)} ${ayahEndMarker(a.ayah)}',
          ].join(' ');

    return HadeelCard(
      onTap: () =>
          context.push(Routes.surah(dua.from.surah, ayah: dua.from.ayah)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (dua.prophet != null)
            Text(
              l10n.prophetName(dua.prophet!),
              style: context.text.labelMedium!.copyWith(
                color: context.brand.goldText,
              ),
            ),
          if (text == null)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: LinearProgressIndicator(),
            )
          else
            Text(
              text,
              style: quranTextStyle(
                settings.copyWith(fontSize: 22, lineHeight: 2),
                context.colors.onSurface,
              ),
            ),
          Row(
            children: [
              Expanded(child: Text(reference, style: context.text.labelMedium)),
              if (text != null)
                ContentActions(
                  kind: FavoriteKind.dua,
                  favoriteKey: dua.key,
                  shareText: '$text\n$reference',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A Hisn al-Muslim entry with its repetition count and actions.
class DhikrCard extends StatelessWidget {
  const DhikrCard({super.key, required this.item, required this.kind});

  final DhikrItem item;
  final FavoriteKind kind;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return HadeelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(item.text, style: contentTextStyle(context)),
          Row(
            children: [
              if (item.repeat > 1)
                Text(
                  l10n.dhikrRepeat(item.repeat),
                  style: context.text.labelMedium!.copyWith(
                    color: context.brand.goldText,
                  ),
                ),
              const Spacer(),
              ContentActions(
                kind: kind,
                favoriteKey: item.key,
                shareText: '${item.text}\n\n— ${l10n.adhkarSource}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
