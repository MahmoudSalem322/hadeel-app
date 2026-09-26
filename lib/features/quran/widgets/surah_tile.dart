import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/quran.dart';
import '../../../shared/extensions/context_x.dart';
import 'number_medallion.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({super.key, required this.surah, required this.onTap});

  final Surah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final f = context.formatters;
    final info = '${l10n.revelationType(surah.revelationType.name)} · ${l10n.ayahCount(surah.ayahCount)}';

    return Semantics(
      button: true,
      label: '${l10n.surahTitle(surah.nameAr)}، $info',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              NumberMedallion(label: f.number(surah.number)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(surah.nameAr, style: context.text.titleMedium),
                    Text(info, style: context.text.bodySmall),
                  ],
                ),
              ),
              // Secondary detail: dropped at large text sizes so the Arabic
              // name always has room.
              if (MediaQuery.textScalerOf(context).scale(1) <= 1.3)
                Flexible(
                  child: Text(
                    surah.nameTransliterated,
                    textDirection: TextDirection.ltr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelSmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
