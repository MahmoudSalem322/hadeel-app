import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/content_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/arabic_normalizer.dart';
import '../../domain/entities/content.dart';
import '../../domain/entities/library.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/search_field.dart';
import '../../shared/widgets/state_views.dart';
import '../quran/widgets/number_medallion.dart';

/// Share/copy text for a hadith, with its source.
String hadithShareText(BuildContext context, HadithBook book, Hadith h) =>
    '${h.text}\n\n— ${book.title}، ${context.l10n.hadithNumber(context.formatters.number(h.number))}';

class HadithBooksScreen extends ConsumerWidget {
  const HadithBooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(l10n.featureHadith),
      ),
      body: ResponsiveBody(
        child: ContentAsync<HadithLibrary>(
          value: ref.watch(hadithLibraryProvider),
          onRetry: () => ref.invalidate(hadithLibraryProvider),
          data: (lib) => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenGutter),
            itemCount: lib.books.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final b = lib.books[i];
              return HadeelCard(
                onTap: () => context.push(Routes.hadithBook(b.key)),
                semanticLabel:
                    '${b.title}، ${l10n.hadithCount(b.hadiths.length)}',
                child: ExcludeSemantics(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.colors.secondaryContainer,
                          borderRadius: AppRadius.mdAll,
                        ),
                        child: Icon(
                          Icons.format_quote_rounded,
                          color: context.brand.goldText,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.title, style: context.text.titleMedium),
                            Text(b.author, style: context.text.bodySmall),
                            Text(
                              l10n.hadithCount(b.hadiths.length),
                              style: context.text.labelSmall!.copyWith(
                                color: context.brand.goldText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.brand.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HadithBookScreen extends ConsumerStatefulWidget {
  const HadithBookScreen({super.key, required this.bookKey});

  final String bookKey;

  @override
  ConsumerState<HadithBookScreen> createState() => _HadithBookScreenState();
}

class _HadithBookScreenState extends ConsumerState<HadithBookScreen> {
  String _query = '';
  int? _chapter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lib = ref.watch(hadithLibraryProvider);
    final book = lib.value?.book(widget.bookKey);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(book?.title ?? l10n.featureHadith),
      ),
      body: ResponsiveBody(
        child: ContentAsync<HadithLibrary>(
          value: lib,
          onRetry: () => ref.invalidate(hadithLibraryProvider),
          data: (_) {
            if (book == null) {
              return EmptyState(
                icon: Icons.search_off_rounded,
                title: l10n.contentLoadError,
              );
            }
            final q = normalizeArabic(_query);
            final hadiths = book.hadiths
                .where((h) => _chapter == null || h.chapterId == _chapter)
                .where(
                  (h) => q.length < 2 || normalizeArabic(h.text).contains(q),
                )
                .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  child: SearchField(
                    hint: l10n.hadithSearchHint,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                if (book.chapters.length > 1)
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      children: [
                        _chip(
                          l10n.hadithAllChapters,
                          _chapter == null,
                          () => setState(() => _chapter = null),
                        ),
                        for (final c in book.chapters)
                          _chip(
                            c.title,
                            _chapter == c.id,
                            () => setState(() => _chapter = c.id),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: hadiths.isEmpty
                      ? EmptyState(
                          icon: Icons.search_off_rounded,
                          title: l10n.searchNoResults,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.xs,
                            AppSpacing.md,
                            AppSpacing.xl,
                          ),
                          itemCount: hadiths.length,
                          separatorBuilder: (_, _) => const Divider(),
                          itemBuilder: (context, i) {
                            final h = hadiths[i];
                            return InkWell(
                              onTap: () => context.push(
                                Routes.hadithItem(book.key, h.number),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.sm,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NumberMedallion(
                                      label: context.formatters.number(
                                        h.number,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        h.text,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.text.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
    padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    ),
  );
}

class HadithDetailScreen extends ConsumerWidget {
  const HadithDetailScreen({
    super.key,
    required this.bookKey,
    required this.number,
  });

  final String bookKey;
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final f = context.formatters;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(l10n.hadithNumber(f.number(number))),
      ),
      body: ResponsiveBody(
        child: ContentAsync<HadithLibrary>(
          value: ref.watch(hadithLibraryProvider),
          onRetry: () => ref.invalidate(hadithLibraryProvider),
          data: (lib) {
            final book = lib.book(bookKey);
            final hadith = lib.byKey('$bookKey:$number');
            if (book == null || hadith == null) {
              return EmptyState(
                icon: Icons.search_off_rounded,
                title: l10n.contentLoadError,
              );
            }
            final chapter = book.chapterTitle(hadith.chapterId);
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screenGutter),
              children: [
                HadeelCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SelectableText(
                    hadith.text,
                    style: contentTextStyle(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.hadithSourceLine(book.title, book.author),
                  style: context.text.titleSmall,
                ),
                if (chapter.isNotEmpty && chapter != book.title)
                  Text(chapter, style: context.text.bodySmall),
                Text(
                  l10n.hadithNumber(f.number(hadith.number)),
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ContentActions(
                    kind: FavoriteKind.hadith,
                    favoriteKey: hadith.key,
                    shareText: hadithShareText(context, book, hadith),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
