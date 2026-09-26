import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/content_actions.dart';
import '../../../shared/widgets/hadeel_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../quran/providers/quran_providers.dart';
import '../../quran/widgets/quran_style.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/daily_content_provider.dart';

/// «زاد اليوم»: one swipeable card with today's ayah, dhikr, hadith and dua.
class DailyContentSection extends ConsumerStatefulWidget {
  const DailyContentSection({super.key});

  @override
  ConsumerState<DailyContentSection> createState() => _DailyContentSectionState();
}

class _DailyContentSectionState extends ConsumerState<DailyContentSection> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final daily = ref.watch(dailyContentProvider).value;
    final quran = ref.watch(quranTextProvider).value;
    if (daily == null || quran == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final meta = ref.watch(quranMetaProvider);
    final f = context.formatters;
    final surah = meta.surah(daily.ayah.from.surah);
    final ayahText = [for (final a in daily.ayah.ayat) quran.ayah(a)].join(' ');
    final ayatLabel = daily.ayah.from.ayah == daily.ayah.to.ayah
        ? f.number(daily.ayah.from.ayah)
        : '${f.number(daily.ayah.from.ayah)}-${f.number(daily.ayah.to.ayah)}';

    final pages = [
      _Page(
        label: l10n.dailyAyah,
        text: ayahText,
        style: quranTextStyle(
          ref.watch(quranSettingsProvider).copyWith(fontSize: 20, lineHeight: 1.8),
          context.colors.onSurface,
        ),
        footer: l10n.quranReference(surah.nameAr, ayatLabel),
        onTap: () => context.push(Routes.surah(daily.ayah.from.surah, ayah: daily.ayah.from.ayah)),
      ),
      _Page(
        label: l10n.dailyDhikr,
        text: daily.dhikr.text,
        style: contentTextStyle(context, size: 19),
        footer: l10n.adhkarSource,
        onTap: () => context.push(Routes.azkarOf('c${daily.dhikr.chapterId}')),
      ),
      _Page(
        label: l10n.dailyHadith,
        text: daily.hadith.text,
        style: contentTextStyle(context, size: 19),
        footer: l10n.hadithNumber(f.number(daily.hadith.number)),
        onTap: () => context.push(Routes.hadithItem(daily.hadith.bookKey, daily.hadith.number)),
      ),
      _Page(
        label: l10n.dailyDua,
        text: daily.dua.text,
        style: contentTextStyle(context, size: 19),
        footer: l10n.adhkarSource,
        onTap: () => context.push(Routes.azkarOf('c${daily.dua.chapterId}')),
      ),
    ];

    final height = 190 + 60 * (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(0.0, 2.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l10n.dailyContent),
        SizedBox(
          height: height,
          child: PageView(
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              for (final p in pages)
                Padding(padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs), child: p),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < pages.length; i++)
                AnimatedContainer(
                  duration: AppMotion.medium,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _page ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _page ? context.brand.gold : context.colors.outlineVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({
    required this.label,
    required this.text,
    required this.style,
    required this.footer,
    required this.onTap,
  });

  final String label;
  final String text;
  final TextStyle style;
  final String footer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HadeelCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: context.text.labelMedium!.copyWith(color: context.brand.goldText)),
          const SizedBox(height: AppSpacing.xxs),
          Expanded(
            child: Text(text, style: style, overflow: TextOverflow.fade),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(footer, style: context.text.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
