import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/core_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/usecases/search_quran.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/search_field.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/state_views.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/quran_providers.dart';
import 'widgets/number_medallion.dart';
import 'widgets/quran_style.dart';

class QuranSearchScreen extends ConsumerStatefulWidget {
  const QuranSearchScreen({super.key, this.initialQuery = ''});

  /// Pre-filled query, e.g. from global search's "show all".
  final String initialQuery;

  static const Duration debounce = Duration(milliseconds: 250);

  @override
  ConsumerState<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends ConsumerState<QuranSearchScreen> {
  Timer? _debounce;
  late String _query = widget.initialQuery.trim();
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialQuery,
  );

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(QuranSearchScreen.debounce, () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(l10n.featureSearch),
      ),
      body: ResponsiveBody(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: SearchField(
                hint: l10n.quranSearchHint,
                controller: _controller,
                autofocus: widget.initialQuery.isEmpty,
                onChanged: _onChanged,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (query.length < QuranSearchIndex.minQueryLength) {
      return EmptyState(
        icon: Icons.manage_search_rounded,
        title: l10n.searchMinChars,
      );
    }

    final results = ref.watch(quranSearchProvider(query));
    return results.when(
      skipLoadingOnReload: true,
      loading: () => const Align(
        alignment: AlignmentDirectional.topCenter,
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => ErrorState(title: l10n.quranLoadError),
      data: (r) {
        if (r.isEmpty) {
          return EmptyState(
            icon: Icons.search_off_rounded,
            title: l10n.searchNoResults,
            message: l10n.searchNoResultsBody,
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            if (r.surahs.isNotEmpty) ...[
              SectionHeader(title: l10n.searchSurahsSection),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final s in r.surahs)
                    ActionChip(
                      avatar: NumberMedallion(
                        label: context.formatters.number(s.number),
                        size: 24,
                      ),
                      label: Text(s.nameAr),
                      onPressed: () => context.push(Routes.surah(s.number)),
                    ),
                ],
              ),
            ],
            if (r.ayat.isNotEmpty) ...[
              SectionHeader(title: l10n.searchAyatSection(r.totalAyat)),
              for (final hit in r.ayat) _AyahHitTile(hit: hit),
              if (r.totalAyat > r.ayat.length)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(
                    l10n.searchCapped(context.formatters.number(r.ayat.length)),
                    textAlign: TextAlign.center,
                    style: context.text.bodySmall,
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _AyahHitTile extends ConsumerWidget {
  const _AyahHitTile({required this.hit});

  final AyahSearchHit hit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surah = ref.watch(quranMetaProvider).surah(hit.ref.surah);
    final font = ref.watch(quranSettingsProvider.select((s) => s.font));
    final base = TextStyle(
      fontFamily: quranFontFamily(font),
      fontSize: 20,
      height: 1.9,
      color: context.colors.onSurface,
    );
    final mark = TextStyle(
      backgroundColor: context.brand.highlight,
      color: context.colors.primary,
      fontWeight: FontWeight.w700,
    );

    final spans = <TextSpan>[];
    var cursor = 0;
    for (final (start, end) in hit.ranges) {
      if (start > cursor) {
        spans.add(TextSpan(text: hit.text.substring(cursor, start)));
      }
      spans.add(TextSpan(text: hit.text.substring(start, end), style: mark));
      cursor = end;
    }
    if (cursor < hit.text.length) {
      spans.add(TextSpan(text: hit.text.substring(cursor)));
    }

    return InkWell(
      onTap: () =>
          context.push(Routes.surah(hit.ref.surah, ayah: hit.ref.ayah)),
      borderRadius: AppRadius.mdAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xxs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.ayahPosition(
                surah.nameAr,
                context.formatters.number(hit.ref.ayah),
              ),
              style: context.text.labelMedium!.copyWith(
                color: context.brand.goldText,
              ),
            ),
            Text.rich(TextSpan(style: base, children: spans)),
          ],
        ),
      ),
    );
  }
}
