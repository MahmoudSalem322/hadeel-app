import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/quran.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/state_views.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/quran_providers.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/number_medallion.dart';
import 'widgets/quran_style.dart';
import 'widgets/surah_tile.dart';

class QuranHomeScreen extends StatelessWidget {
  const QuranHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.featureQuran),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56 + 48 + AppSpacing.sm),
            child: Column(
              children: [
                Padding(
                  padding: AppSpacing.screenPadding,
                  child: _SearchLauncher(onTap: () => context.push(Routes.quranSearch)),
                ),
                const SizedBox(height: AppSpacing.sm),
                TabBar(
                  tabs: [
                    Tab(text: l10n.quranTabSurahs),
                    Tab(text: l10n.quranTabJuz),
                    Tab(text: l10n.quranTabFavorites),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const ResponsiveBody(
          child: TabBarView(children: [_SurahsTab(), _JuzTab(), _FavoritesTab()]),
        ),
      ),
    );
  }
}

/// Looks like a search field; opens the dedicated search screen.
class _SearchLauncher extends StatelessWidget {
  const _SearchLauncher({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.quranSearchHint,
      excludeSemantics: true,
      child: Material(
        color: context.brand.surfaceMuted,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.search_rounded, color: context.brand.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    context.l10n.quranSearchHint,
                    style: context.text.bodyMedium!.copyWith(color: context.brand.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SurahsTab extends ConsumerWidget {
  const _SurahsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahs = ref.watch(quranMetaProvider).surahs;
    final hasProgress = ref.watch(readingProgressProvider) != null;
    final offset = hasProgress ? 1 : 0;

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: surahs.length + offset,
      itemBuilder: (context, index) {
        if (hasProgress && index == 0) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
            child: ContinueReadingCard(),
          );
        }
        final surah = surahs[index - offset];
        return SurahTile(
          surah: surah,
          onTap: () => context.push(Routes.surah(surah.number)),
        );
      },
    );
  }
}

class _JuzTab extends ConsumerWidget {
  const _JuzTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = ref.watch(quranMetaProvider);
    final l10n = context.l10n;
    final f = context.formatters;

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: meta.juzs.length,
      itemBuilder: (context, index) {
        final juz = meta.juzs[index];
        final start = meta.surah(juz.start.surah);
        return ListTile(
          leading: NumberMedallion(label: f.number(juz.number)),
          title: Text(l10n.juzTitle(f.number(juz.number))),
          subtitle: Text(l10n.ayahPosition(start.nameAr, f.number(juz.start.ayah))),
          onTap: () => context.push(Routes.surah(juz.start.surah, ayah: juz.start.ayah)),
        );
      },
    );
  }
}

class _FavoritesTab extends ConsumerWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bookmarks = ref.watch(bookmarksProvider).value ?? const [];
    final favorites = ref.watch(favoriteAyatProvider).value ?? const [];
    final favoriteRefs = [for (final f in favorites) ?AyahRef.tryParse(f.key)];

    if (bookmarks.isEmpty && favoriteRefs.isEmpty) {
      return EmptyState(
        icon: Icons.bookmark_border_rounded,
        title: l10n.quranFavoritesEmptyTitle,
        message: l10n.quranFavoritesEmptyBody,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
      children: [
        if (bookmarks.isNotEmpty) ...[
          SectionHeader(title: l10n.quranBookmarksSection),
          for (final b in bookmarks) _SavedAyahTile(ayah: b.ref, icon: Icons.bookmark_rounded),
        ],
        if (favoriteRefs.isNotEmpty) ...[
          SectionHeader(title: l10n.quranFavoritesSection),
          for (final r in favoriteRefs) _SavedAyahTile(ayah: r, icon: Icons.favorite_rounded),
        ],
      ],
    );
  }
}

class _SavedAyahTile extends ConsumerWidget {
  const _SavedAyahTile({required this.ayah, required this.icon});

  final AyahRef ayah;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = ref.watch(quranMetaProvider);
    if (!meta.isValid(ayah)) return const SizedBox.shrink();
    final surah = meta.surah(ayah.surah);
    final text = ref.watch(quranTextProvider).value?.ayah(ayah);
    final font = ref.watch(quranSettingsProvider.select((s) => s.font));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        tileColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: context.brand.divider),
        ),
        leading: Icon(icon, color: context.brand.goldText),
        title: Text(context.l10n.ayahPosition(surah.nameAr, context.formatters.number(ayah.ayah))),
        subtitle: text == null
            ? null
            : Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: quranFontFamily(font), fontSize: 18, height: 1.8),
              ),
        onTap: () => context.push(Routes.surah(ayah.surah, ayah: ayah.ayah)),
      ),
    );
  }
}
