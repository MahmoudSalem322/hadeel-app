import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/responsive_body.dart';

/// «المصادر» — where every piece of religious and reference data comes from.
/// Also fulfils the Tanzil requirement to state the source and link to it.
class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  static const String tanzilUrl = 'https://tanzil.net';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = [
      (Icons.menu_book_rounded, l10n.sourceQuranTitle, l10n.sourceQuranBody, tanzilUrl),
      (Icons.list_alt_rounded, l10n.sourceQuranMetaTitle, l10n.sourceQuranMetaBody, tanzilUrl),
      (Icons.access_time_rounded, l10n.sourcePrayerTitle, l10n.sourcePrayerBody, null),
      (Icons.calendar_month_outlined, l10n.sourceHijriTitle, l10n.sourceHijriBody, null),
      (Icons.font_download_outlined, l10n.sourceFontsTitle, l10n.sourceFontsBody, null),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureSources)),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenGutter),
          children: [
            Text(
              l10n.sourcesIntro,
              style: context.text.bodyMedium!.copyWith(color: context.brand.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final (icon, title, body, url) in entries) ...[
              HadeelCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: context.colors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: context.text.titleSmall),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(body, style: context.text.bodySmall),
                          if (url != null)
                            SelectableText(
                              url,
                              textDirection: TextDirection.ltr,
                              style: context.text.labelMedium!.copyWith(color: context.brand.goldText),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
