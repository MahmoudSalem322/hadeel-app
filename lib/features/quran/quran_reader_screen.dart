import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/providers/content_providers.dart';
import '../../core/providers/core_providers.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/quran.dart';
import '../../domain/entities/quran_reading_settings.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/state_views.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/quran_providers.dart';
import 'reader_layout.dart';
import 'widgets/ayah_actions_sheet.dart';
import 'widgets/number_medallion.dart';
import 'widgets/quran_style.dart';
import 'widgets/reading_settings_sheet.dart';

class QuranReaderScreen extends ConsumerStatefulWidget {
  const QuranReaderScreen({
    super.key,
    required this.surahNumber,
    this.initialAyah,
  });

  final int surahNumber;
  final int? initialAyah;

  @override
  ConsumerState<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends ConsumerState<QuranReaderScreen> {
  ItemPositionsListener _positions = ItemPositionsListener.create();
  QuranReadingMode? _mode;
  ReaderLayout? _layout;
  int? _highlightAyah;
  Timer? _highlightTimer;
  late final ReadingRecorder _recorder;

  @override
  void initState() {
    super.initState();
    // Keep the recorder alive for this screen's lifetime.
    ref.listenManual(readingRecorderProvider, (_, _) {});
    _recorder = ref.read(readingRecorderProvider.notifier);
    _highlightAyah = widget.initialAyah;
    _highlightTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _highlightAyah = null);
    });
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    _positions.itemPositions.removeListener(_onPositionsChanged);
    _recorder.flush(); // save where the reader stopped, right away
    super.dispose();
  }

  void _onPositionsChanged() {
    final layout = _layout;
    if (layout == null) return;
    final visible = _positions.itemPositions.value.where(
      (p) => p.itemTrailingEdge > 0.15,
    );
    if (visible.isEmpty) return;
    final top = visible.map((p) => p.index).reduce((a, b) => a < b ? a : b);
    _recorder.report(AyahRef(widget.surahNumber, layout.ayahAtIndex(top)));
  }

  /// Rebuilds the list (and its position listener) when the mode changes,
  /// keeping the reader on the same ayah.
  int _initialIndexFor(ReaderLayout layout, QuranReadingMode mode) {
    final recorded = ref.read(readingRecorderProvider);
    final ayah = recorded != null && recorded.surah == widget.surahNumber
        ? recorded.ayah
        : widget.initialAyah ?? 1;
    if (_mode != null && _mode != mode) {
      _positions.itemPositions.removeListener(_onPositionsChanged);
      _positions = ItemPositionsListener.create();
    }
    if (_mode != mode) {
      _positions.itemPositions.addListener(_onPositionsChanged);
    }
    _mode = mode;
    return layout.indexOfAyah(ayah);
  }

  @override
  Widget build(BuildContext context) {
    final meta = ref.watch(quranMetaProvider);
    final l10n = context.l10n;

    if (widget.surahNumber < 1 || widget.surahNumber > meta.surahs.length) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        ),
        body: ErrorState(title: l10n.quranLoadError),
      );
    }

    final surah = meta.surah(widget.surahNumber);
    final settings = ref.watch(quranSettingsProvider);
    final textAsync = ref.watch(quranTextProvider);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(l10n.surahTitle(surah.nameAr)),
        actions: [
          IconButton(
            tooltip: l10n.readingSettingsTitle,
            icon: const Icon(Icons.text_fields_rounded),
            onPressed: () => showReadingSettings(context),
          ),
        ],
      ),
      body: textAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(
          title: l10n.quranLoadError,
          actionLabel: l10n.actionRetry,
          onAction: () => ref.invalidate(quranTextProvider),
        ),
        data: (text) {
          final layout = ReaderLayout(
            ayahCount: surah.ayahCount,
            mode: settings.mode,
          );
          _layout = layout;
          final initialIndex = _initialIndexFor(layout, settings.mode);
          return ScrollablePositionedList.builder(
            key: ValueKey(settings.mode),
            itemCount: layout.itemCount,
            initialScrollIndex: initialIndex,
            initialAlignment: initialIndex == 0 ? 0 : 0.02,
            itemPositionsListener: _positions,
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _SurahHeader(
                  surah: surah,
                  basmala: showsBasmalaHeader(surah.number)
                      ? text.bismillah
                      : null,
                );
              }
              if (index == layout.footerIndex) return _Footer(surah: surah);
              final (first, last) = layout.ayatOf(index);
              if (settings.mode == QuranReadingMode.verses) {
                return _AyahBlock(
                  ayah: AyahRef(surah.number, first),
                  text: text.ayah(AyahRef(surah.number, first)),
                  highlighted: _highlightAyah == first,
                );
              }
              return _ContinuousBlock(
                surah: surah.number,
                first: first,
                ayat: [
                  for (var a = first; a <= last; a++)
                    text.ayah(AyahRef(surah.number, a)),
                ],
                highlightAyah: _highlightAyah,
              );
            },
          );
        },
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({required this.surah, this.basmala});

  final Surah surah;
  final String? basmala;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: LiquidGlass(
        tint: context.brand.hero,
        radius: 36,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.md,
        ),
        child: Column(
          children: [
            Text(
              l10n.surahTitle(surah.nameAr),
              style: context.text.headlineSmall!.copyWith(
                color: context.brand.onHero,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '${l10n.revelationType(surah.revelationType.name)} · ${l10n.ayahCount(surah.ayahCount)}',
              style: context.text.labelMedium!.copyWith(
                color: context.brand.onHeroMuted,
              ),
            ),
            if (basmala != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                basmala!,
                textAlign: TextAlign.center,
                style: quranTextStyle(
                  const QuranReadingSettings(fontSize: 24, lineHeight: 1.8),
                  context.brand.gold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AyahBlock extends ConsumerWidget {
  const _AyahBlock({
    required this.ayah,
    required this.text,
    required this.highlighted,
  });

  final AyahRef ayah;
  final String text;
  final bool highlighted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(quranSettingsProvider);
    final bookmarked = ref.watch(
      bookmarkedRefsProvider.select((s) => s.contains(ayah)),
    );
    final favorite = ref.watch(
      favoriteAyahRefsProvider.select((s) => s.contains(ayah)),
    );
    final sajda = ref.watch(quranMetaProvider).sajdas.contains(ayah);
    final number = context.formatters.number(ayah.ayah);

    return Semantics(
      button: true,
      label: context.l10n.ayahNumberLabel(number),
      child: InkWell(
        onTap: () => showAyahActions(context, ref: ayah, text: text),
        onLongPress: () => showAyahActions(context, ref: ayah, text: text),
        child: AnimatedContainer(
          duration: AppMotion.slow,
          color: highlighted ? context.brand.highlight : Colors.transparent,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  NumberMedallion(label: number, size: 34),
                  const Spacer(),
                  if (sajda) ...[
                    Text(
                      context.l10n.sajdaMark,
                      style: context.text.labelSmall!.copyWith(
                        color: context.brand.goldText,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  if (favorite)
                    Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: context.brand.goldText,
                    ),
                  if (bookmarked)
                    Icon(
                      Icons.bookmark_rounded,
                      size: 18,
                      color: context.brand.goldText,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                text,
                textAlign: TextAlign.start,
                style: quranTextStyle(settings, context.colors.onSurface),
              ),
              if (settings.showTafsir) _InlineTafsir(ayah: ayah),
              const SizedBox(height: AppSpacing.xs),
              Divider(color: context.brand.divider),
            ],
          ),
        ),
      ),
    );
  }
}

/// التفسير الميسر under an ayah, in a quieter style than the Quran text.
class _InlineTafsir extends ConsumerWidget {
  const _InlineTafsir({required this.ayah});

  final AyahRef ayah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(tafsirProvider).value?.ayah(ayah);
    if (text == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.brand.surfaceMuted,
        borderRadius: AppRadius.mdAll,
      ),
      child: Text(
        text,
        style: context.text.bodyMedium!.copyWith(
          color: context.brand.textSecondary,
        ),
      ),
    );
  }
}

/// A paragraph of ayat with inline end-of-ayah markers. Each ayah is tappable.
class _ContinuousBlock extends ConsumerStatefulWidget {
  const _ContinuousBlock({
    required this.surah,
    required this.first,
    required this.ayat,
    required this.highlightAyah,
  });

  final int surah;
  final int first;
  final List<String> ayat;
  final int? highlightAyah;

  @override
  ConsumerState<_ContinuousBlock> createState() => _ContinuousBlockState();
}

class _ContinuousBlockState extends ConsumerState<_ContinuousBlock> {
  final List<TapGestureRecognizer> _recognizers = [];

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(quranSettingsProvider);
    final bookmarks = ref.watch(bookmarkedRefsProvider);
    final base = quranTextStyle(settings, context.colors.onSurface);
    _disposeRecognizers();

    final spans = <InlineSpan>[];
    for (var i = 0; i < widget.ayat.length; i++) {
      final ref = AyahRef(widget.surah, widget.first + i);
      final text = widget.ayat[i];
      final recognizer = TapGestureRecognizer()
        ..onTap = () => showAyahActions(context, ref: ref, text: text);
      _recognizers.add(recognizer);
      final highlighted = widget.highlightAyah == ref.ayah;
      spans
        ..add(
          TextSpan(
            text: text,
            recognizer: recognizer,
            style: highlighted
                ? TextStyle(backgroundColor: context.brand.highlight)
                : null,
          ),
        )
        ..add(
          TextSpan(
            text: ' ${ayahEndMarker(ref.ayah)} ',
            recognizer: recognizer,
            style: TextStyle(
              color: bookmarks.contains(ref)
                  ? context.colors.primary
                  : context.brand.goldText,
            ),
          ),
        );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text.rich(
        TextSpan(style: base, children: spans),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class _Footer extends ConsumerWidget {
  const _Footer({required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (surah.number >= 114) return const SizedBox(height: AppSpacing.xl);
    final next = ref.watch(quranMetaProvider).surah(surah.number + 1);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SecondaryButton(
        label: '${context.l10n.nextSurah} · ${next.nameAr}',
        icon: Icons.arrow_forward_rounded, // mirrors to point left in RTL
        onPressed: () => context.pushReplacement(Routes.surah(next.number)),
      ),
    );
  }
}
