import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/content_providers.dart';
import '../../core/providers/core_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/content.dart';
import '../../domain/entities/library.dart';
import '../../domain/entities/quran.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/state_views.dart';
import '../duas/dua_category_screen.dart';
import '../hadith/hadith_screens.dart';
import '../quran/providers/quran_providers.dart';
import '../quran/widgets/quran_style.dart';
import '../settings/providers/settings_provider.dart';

/// Everything the user saved, by kind. All stored on the device.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
          title: Text(l10n.featureFavorites),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.favoritesTabQuran),
              Tab(text: l10n.favoritesTabAdhkar),
              Tab(text: l10n.favoritesTabDuas),
              Tab(text: l10n.favoritesTabHadith),
            ],
          ),
        ),
        body: const ResponsiveBody(
          child: TabBarView(
            children: [
              _QuranFavorites(),
              _AdhkarFavorites(),
              _DuaFavorites(),
              _HadithFavorites(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _empty(BuildContext context, String route) => EmptyState(
  icon: Icons.favorite_outline_rounded,
  title: context.l10n.emptyFavoritesTitle,
  message: context.l10n.emptyFavoritesBody,
  actionLabel: context.l10n.actionExplore,
  onAction: () => context.push(route),
);

class _QuranFavorites extends ConsumerWidget {
  const _QuranFavorites();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(favoritesProvider(FavoriteKind.ayah)).value ?? const [];
    if (items.isEmpty) return _empty(context, Routes.quran);
    final meta = ref.watch(quranMetaProvider);
    final quran = ref.watch(quranTextProvider).value;
    final settings = ref.watch(quranSettingsProvider);
    final f = context.formatters;

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenGutter),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final ref0 = AyahRef.tryParse(items[i].key);
        if (ref0 == null || !meta.isValid(ref0)) return const SizedBox.shrink();
        final label = context.l10n.ayahPosition(
          meta.surah(ref0.surah).nameAr,
          f.number(ref0.ayah),
        );
        final text = quran?.ayah(ref0);
        return HadeelCard(
          onTap: () => context.push(Routes.surah(ref0.surah, ayah: ref0.ayah)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label,
                style: context.text.labelMedium!.copyWith(
                  color: context.brand.goldText,
                ),
              ),
              if (text != null)
                Text(
                  text,
                  style: quranTextStyle(
                    settings.copyWith(fontSize: 22, lineHeight: 1.9),
                    context.colors.onSurface,
                  ),
                ),
              if (text != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ContentActions(
                    kind: FavoriteKind.ayah,
                    favoriteKey: items[i].key,
                    shareText: context.l10n.ayahCitation(
                      text,
                      meta.surah(ref0.surah).nameAr,
                      f.number(ref0.ayah),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AdhkarFavorites extends ConsumerWidget {
  const _AdhkarFavorites();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(favoritesProvider(FavoriteKind.dhikr)).value ?? const [];
    if (items.isEmpty) return _empty(context, Routes.azkar);
    return ContentAsync<HisnLibrary>(
      value: ref.watch(hisnProvider),
      data: (lib) => ListView(
        padding: const EdgeInsets.all(AppSpacing.screenGutter),
        children: [
          for (final f in items)
            if (lib.itemByKey(f.key) case final item?) ...[
              DhikrCard(item: item, kind: FavoriteKind.dhikr),
              const SizedBox(height: AppSpacing.sm),
            ],
        ],
      ),
    );
  }
}

class _DuaFavorites extends ConsumerWidget {
  const _DuaFavorites();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(favoritesProvider(FavoriteKind.dua)).value ?? const [];
    if (items.isEmpty) return _empty(context, Routes.duas);
    return ContentAsync<HisnLibrary>(
      value: ref.watch(hisnProvider),
      data: (lib) => ListView(
        padding: const EdgeInsets.all(AppSpacing.screenGutter),
        children: [
          for (final f in items) ...[
            if (QuranDua.tryParseKey(f.key) case final dua?)
              QuranDuaCard(dua: dua)
            else if (lib.itemByKey(f.key) case final item?)
              DhikrCard(item: item, kind: FavoriteKind.dua),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _HadithFavorites extends ConsumerWidget {
  const _HadithFavorites();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(favoritesProvider(FavoriteKind.hadith)).value ?? const [];
    if (items.isEmpty) return _empty(context, Routes.hadith);
    return ContentAsync<HadithLibrary>(
      value: ref.watch(hadithLibraryProvider),
      data: (lib) => ListView(
        padding: const EdgeInsets.all(AppSpacing.screenGutter),
        children: [
          for (final f in items)
            if (lib.byKey(f.key) case final h?)
              if (lib.book(h.bookKey) case final book?) ...[
                HadeelCard(
                  onTap: () =>
                      context.push(Routes.hadithItem(h.bookKey, h.number)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${book.title} · ${context.l10n.hadithNumber(context.formatters.number(h.number))}',
                        style: context.text.labelMedium!.copyWith(
                          color: context.brand.goldText,
                        ),
                      ),
                      Text(
                        h.text,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: contentTextStyle(context, size: 19),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: ContentActions(
                          kind: FavoriteKind.hadith,
                          favoriteKey: h.key,
                          shareText: hadithShareText(context, book, h),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
        ],
      ),
    );
  }
}
