import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/content_providers.dart';
import '../../core/providers/core_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/usecases/search_content.dart';
import '../../domain/usecases/search_quran.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/highlighted_text.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/search_field.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/state_views.dart';
import '../quran/providers/quran_providers.dart';

final contentSearchIndexProvider = FutureProvider<ContentSearchIndex>((ref) async {
  final hisn = await ref.watch(hisnProvider.future);
  final hadith = await ref.watch(hadithLibraryProvider.future);
  return ContentSearchIndex(hisn, hadith);
});

final contentSearchProvider = FutureProvider.autoDispose.family<ContentSearchResults, String>((ref, q) async {
  if (q.trim().length < ContentSearchIndex.minQueryLength) return ContentSearchResults.empty;
  final index = await ref.watch(contentSearchIndexProvider.future);
  return index.search(q);
});

/// One search box for the Quran, adhkar, duas and hadith — all offline.
class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureSearch)),
      body: ResponsiveBody(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xs),
              child: SearchField(
                hint: l10n.globalSearchHint,
                autofocus: true,
                onChanged: (v) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    if (mounted) setState(() => _query = v.trim());
                  });
                },
              ),
            ),
            Expanded(child: _Results(query: _query)),
          ],
        ),
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query});

  final String query;

  static const int quranPreview = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (query.length < 2) return EmptyState(icon: Icons.manage_search_rounded, title: l10n.searchMinChars);

    final quran = ref.watch(quranSearchProvider(query));
    final content = ref.watch(contentSearchProvider(query));
    if (quran.isLoading || content.isLoading) {
      return const Align(alignment: AlignmentDirectional.topCenter, child: LinearProgressIndicator());
    }
    final q = quran.value ?? QuranSearchResults.empty;
    final c = content.value ?? ContentSearchResults.empty;
    if (q.isEmpty && c.isEmpty) {
      return EmptyState(icon: Icons.search_off_rounded, title: l10n.searchNoResults, message: l10n.searchNoResultsBody);
    }

    final meta = ref.watch(quranMetaProvider);
    final f = context.formatters;
    final small = contentTextStyle(context, size: 18);

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xxl),
      children: [
        if (!q.isEmpty) ...[
          SectionHeader(
            title: '${l10n.searchSectionQuran} · ${f.number(q.totalAyat + q.surahs.length)}',
            action: TextButton(
              onPressed: () => context.push(Routes.quranSearchFor(query)),
              child: Text(l10n.searchShowAll),
            ),
          ),
          for (final s in q.surahs)
            ListTile(
              leading: const Icon(Icons.menu_book_rounded),
              title: Text(l10n.surahTitle(s.nameAr)),
              onTap: () => context.push(Routes.surah(s.number)),
            ),
          for (final hit in q.ayat.take(quranPreview))
            _HitTile(
              label: l10n.ayahPosition(meta.surah(hit.ref.surah).nameAr, f.number(hit.ref.ayah)),
              text: hit.text,
              ranges: hit.ranges,
              style: small,
              onTap: () => context.push(Routes.surah(hit.ref.surah, ayah: hit.ref.ayah)),
            ),
        ],
        if (c.adhkarTotal > 0) ...[
          SectionHeader(title: '${l10n.searchSectionAdhkar} · ${f.number(c.adhkarTotal)}'),
          for (final hit in c.adhkar)
            _HitTile(
              label: ref.watch(hisnProvider).value?.chapter(hit.item.chapterId)?.title ?? '',
              text: hit.text,
              ranges: hit.ranges,
              style: small,
              onTap: () => context.push(Routes.azkarOf('c${hit.item.chapterId}')),
            ),
        ],
        if (c.hadithTotal > 0) ...[
          SectionHeader(title: '${l10n.searchSectionHadith} · ${f.number(c.hadithTotal)}'),
          for (final hit in c.hadith)
            _HitTile(
              label:
                  '${ref.watch(hadithLibraryProvider).value?.book(hit.item.bookKey)?.title ?? ''} · ${l10n.hadithNumber(f.number(hit.item.number))}',
              text: hit.text,
              ranges: hit.ranges,
              style: small,
              onTap: () => context.push(Routes.hadithItem(hit.item.bookKey, hit.item.number)),
            ),
        ],
      ],
    );
  }
}

class _HitTile extends StatelessWidget {
  const _HitTile({
    required this.label,
    required this.text,
    required this.ranges,
    required this.style,
    required this.onTap,
  });

  final String label;
  final String text;
  final List<(int, int)> ranges;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (excerpt, shifted) = excerptAround(text, ranges);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xxs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.text.labelMedium!.copyWith(color: context.brand.goldText)),
            HighlightedText(text: excerpt, ranges: shifted, style: style, maxLines: 4),
          ],
        ),
      ),
    );
  }
}
