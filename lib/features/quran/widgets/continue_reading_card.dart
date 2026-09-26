import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/hadeel_card.dart';
import '../providers/quran_providers.dart';

class ContinueReadingCard extends ConsumerWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final f = context.formatters;
    final progress = ref.watch(readingProgressProvider);

    final title = progress == null ? l10n.homeStartReading : l10n.homeContinueReading;
    final subtitle = progress == null
        ? l10n.homeStartReadingBody
        : l10n.homeReadingPosition(progress.surahName, f.number(progress.ayahNumber));
    void open() => progress == null
        ? context.go(Routes.quran)
        : context.push(Routes.surah(progress.surahNumber, ayah: progress.ayahNumber));

    return HadeelCard(
      onTap: open,
      semanticLabel: '$title. $subtitle',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colors.secondaryContainer,
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Icon(Icons.menu_book_rounded, color: context.brand.goldText),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.text.titleMedium),
                      Text(subtitle, style: context.text.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.chevron_right_rounded, color: context.brand.textSecondary),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: AppRadius.smAll,
                child: LinearProgressIndicator(value: progress.fraction, minHeight: 4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
