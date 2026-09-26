import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/content_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/arabic_normalizer.dart';
import '../../domain/entities/content.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/search_field.dart';
import '../../shared/widgets/section_header.dart';
import 'widgets/category_icons.dart';

/// الأذكار: daily categories first, then every chapter of Hisn al-Muslim.
class AdhkarHomeScreen extends ConsumerStatefulWidget {
  const AdhkarHomeScreen({super.key});

  @override
  ConsumerState<AdhkarHomeScreen> createState() => _AdhkarHomeScreenState();
}

class _AdhkarHomeScreenState extends ConsumerState<AdhkarHomeScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureAdhkar)),
      body: ResponsiveBody(
        child: ContentAsync<HisnLibrary>(
          value: ref.watch(hisnProvider),
          onRetry: () => ref.invalidate(hisnProvider),
          data: (lib) {
            final q = normalizeArabic(_query);
            final chapters = q.isEmpty
                ? lib.chapters
                : lib.chapters.where((c) => normalizeArabic(c.title).contains(q)).toList();

            return CustomScrollView(
              slivers: [
                if (q.isEmpty) ...[
                  SliverPadding(
                    padding: AppSpacing.screenPadding,
                    sliver: SliverToBoxAdapter(child: SectionHeader(title: l10n.adhkarDaily)),
                  ),
                  SliverPadding(
                    padding: AppSpacing.screenPadding,
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        // Grows with the user's text size so labels never clip.
                        mainAxisExtent: 72 + 40 * MediaQuery.textScalerOf(context).scale(1),
                        crossAxisSpacing: AppSpacing.sm,
                        mainAxisSpacing: AppSpacing.sm,
                      ),
                      itemCount: lib.adhkar.length,
                      itemBuilder: (context, i) => _CategoryCard(category: lib.adhkar[i], library: lib),
                    ),
                  ),
                ],
                SliverPadding(
                  padding: AppSpacing.screenPadding,
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SectionHeader(title: l10n.adhkarAllChapters),
                        SearchField(
                          hint: l10n.adhkarSearchHint,
                          onChanged: (v) => setState(() => _query = v),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                      ],
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: chapters.length,
                  itemBuilder: (context, i) {
                    final c = chapters[i];
                    return ListTile(
                      title: Text(c.title),
                      subtitle: Text(l10n.itemsCount(c.items.length)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push(Routes.azkarOf('c${c.id}')),
                    );
                  },
                ),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md + context.navBarInset)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.library});

  final ContentCategory category;
  final HisnLibrary library;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = l10n.adhkarCategory(category.key);
    final count = library.itemsOf(category).length;
    return HadeelCard(
      onTap: () => context.push(Routes.azkarOf(category.key)),
      semanticLabel: '$title، ${l10n.itemsCount(count)}',
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: context.colors.primaryContainer, shape: BoxShape.circle),
              child: Icon(adhkarCategoryIcon(category.key), size: 20, color: context.colors.primary),
            ),
            const Spacer(),
            Text(title, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(l10n.itemsCount(count), style: context.text.labelSmall),
          ],
        ),
      ),
    );
  }
}
