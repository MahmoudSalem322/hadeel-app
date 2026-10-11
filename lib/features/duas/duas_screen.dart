import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/content_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/content.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/responsive_body.dart';
import '../adhkar/widgets/category_icons.dart';

/// Number of duas in a category: Quranic entries plus Hisn items.
int duaCount(HisnLibrary lib, ContentCategory c) =>
    c.quranDuas.length + lib.itemsOf(c).length;

class DuasScreen extends ConsumerWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(l10n.featureDuas),
      ),
      body: ResponsiveBody(
        child: ContentAsync<HisnLibrary>(
          value: ref.watch(hisnProvider),
          onRetry: () => ref.invalidate(hisnProvider),
          data: (lib) => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenGutter),
            itemCount: lib.duas.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final c = lib.duas[i];
              final title = l10n.duaCategory(c.key);
              final count = l10n.duasCount(duaCount(lib, c));
              return HadeelCard(
                onTap: () => context.push(Routes.duasOf(c.key)),
                semanticLabel: '$title، $count',
                child: ExcludeSemantics(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: context.colors.primaryContainer,
                          borderRadius: AppRadius.mdAll,
                        ),
                        child: Icon(
                          duaCategoryIcon(c.key),
                          color: context.colors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: context.text.titleMedium),
                            Text(count, style: context.text.bodySmall),
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
