import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/responsive_body.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final groups = <List<(IconData, String, String)>>[
      [
        (Icons.explore_outlined, l10n.featureQibla, Routes.qibla),
        (Icons.fingerprint_rounded, l10n.featureTasbeeh, Routes.tasbeeh),
        (Icons.calendar_month_outlined, l10n.featureHijriCalendar, Routes.hijriCalendar),
        (Icons.favorite_outline_rounded, l10n.featureFavorites, Routes.favorites),
        (Icons.volunteer_activism_outlined, l10n.featureDuas, Routes.duas),
        (Icons.format_quote_outlined, l10n.featureHadith, Routes.hadith),
      ],
      [
        (Icons.settings_outlined, l10n.featureSettings, Routes.settings),
        (Icons.info_outline_rounded, l10n.featureAbout, Routes.about),
        (Icons.library_books_outlined, l10n.featureSources, Routes.sources),
        if (kDebugMode) (Icons.palette_outlined, l10n.galleryTitle, Routes.designGallery),
      ],
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureMore)),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenGutter),
          children: [
            for (final group in groups) ...[
              HadeelCard(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Column(
                  children: [
                    for (var i = 0; i < group.length; i++) ...[
                      if (i > 0) const Divider(indent: 56),
                      ListTile(
                        leading: Icon(group[i].$1),
                        title: Text(group[i].$2),
                        trailing: Icon(Icons.chevron_right_rounded, color: context.brand.textSecondary),
                        onTap: () => context.push(group[i].$3),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}
