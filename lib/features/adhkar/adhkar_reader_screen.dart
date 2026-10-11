import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/content_providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/content.dart';
import '../../domain/entities/library.dart';
import '../../domain/usecases/adhkar_counter.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/progress_ring.dart';
import '../../shared/widgets/state_views.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/adhkar_providers.dart';

/// Reads a category one dhikr at a time with a large counter button.
/// Finishing a dhikr's repetitions moves to the next automatically.
class AdhkarReaderScreen extends ConsumerStatefulWidget {
  const AdhkarReaderScreen({super.key, required this.categoryKey});

  final String categoryKey;

  @override
  ConsumerState<AdhkarReaderScreen> createState() => _AdhkarReaderScreenState();
}

class _AdhkarReaderScreenState extends ConsumerState<AdhkarReaderScreen> {
  PageController? _pages;

  @override
  void dispose() {
    _pages?.dispose();
    super.dispose();
  }

  String _title(HisnLibrary? lib) {
    final key = widget.categoryKey;
    if (key.startsWith('c') && lib != null) {
      return lib.chapter(int.tryParse(key.substring(1)) ?? -1)?.title ??
          context.l10n.featureAdhkar;
    }
    return context.l10n.adhkarCategory(key);
  }

  void _syncPage(int index) {
    final pages = _pages;
    if (pages == null || !pages.hasClients) return;
    if ((pages.page ?? 0).round() == index) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      pages.jumpToPage(index);
    } else {
      pages.animateToPage(
        index,
        duration: AppMotion.slow,
        curve: AppMotion.curve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = adhkarSessionProvider(widget.categoryKey);
    final session = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    ref.listen(provider, (prev, next) {
      final index = next.value?.counter.index;
      if (index != null && index != prev?.value?.counter.index) {
        _syncPage(index);
      }
    });

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(_title(ref.watch(hisnProvider).value)),
        actions: [
          if (session.value != null)
            IconButton(
              tooltip: l10n.actionRestart,
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: notifier.restart,
            ),
        ],
      ),
      body: ContentAsync<AdhkarSessionState?>(
        value: session,
        onRetry: () => ref.invalidate(provider),
        data: (state) {
          if (state == null) {
            return EmptyState(
              icon: Icons.search_off_rounded,
              title: l10n.contentLoadError,
            );
          }
          _pages ??= PageController(initialPage: state.counter.index);
          final c = state.counter;

          if (c.completed) {
            return EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: l10n.adhkarCompletedTitle,
              message: l10n.adhkarCompletedBody,
              actionLabel: l10n.actionRestart,
              onAction: () {
                notifier.restart();
                _pages?.jumpToPage(0);
              },
            );
          }

          return Column(
            children: [
              LinearProgressIndicator(value: c.overallProgress, minHeight: 3),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.dhikrPosition(
                        context.formatters.number(c.index + 1),
                        context.formatters.number(c.total),
                      ),
                      style: context.text.titleSmall,
                    ),
                    const Spacer(),
                    Text(l10n.adhkarSource, style: context.text.labelSmall),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pages,
                  itemCount: state.items.length,
                  onPageChanged: (i) {
                    if (i != ref.read(provider).value?.counter.index) {
                      notifier.goTo(i);
                    }
                  },
                  itemBuilder: (context, i) => _DhikrPage(item: state.items[i]),
                ),
              ),
              _CounterBar(
                counter: c,
                onTap: () {
                  final settings = ref.read(settingsProvider).tasbeeh;
                  if (settings.vibration) HapticFeedback.lightImpact();
                  if (settings.sound) SystemSound.play(SystemSoundType.click);
                  notifier.tap();
                },
                onPrevious: c.isFirst ? null : notifier.previous,
                onNext: notifier.next,
                onReset: c.count == 0 ? null : notifier.resetItem,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DhikrPage extends StatelessWidget {
  const _DhikrPage({required this.item});

  final DhikrItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(item.text, style: contentTextStyle(context, size: 22)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.repeat_rounded,
                size: 18,
                color: context.brand.goldText,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                l10n.dhikrRepeat(item.repeat),
                style: context.text.labelMedium!.copyWith(
                  color: context.brand.goldText,
                ),
              ),
              const Spacer(),
              ContentActions(
                kind: FavoriteKind.dhikr,
                favoriteKey: item.key,
                shareText: '${item.text}\n\n— ${l10n.adhkarSource}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterBar extends StatelessWidget {
  const _CounterBar({
    required this.counter,
    required this.onTap,
    required this.onPrevious,
    required this.onNext,
    required this.onReset,
  });

  final AdhkarCounter counter;
  final VoidCallback onTap;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final f = context.formatters;
    final count = counter.count;
    final target = counter.target;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border(top: BorderSide(color: context.brand.divider)),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: onPrevious,
                    icon: const Icon(Icons.chevron_left_rounded),
                    label: Text(l10n.actionPrevious),
                  ),
                  TextButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.actionReset),
                  ),
                ],
              ),
            ),
            Semantics(
              button: true,
              label:
                  '${l10n.dhikrCounterButton}، ${l10n.dhikrCountSemantics(f.number(count), f.number(target))}',
              excludeSemantics: true,
              child: SizedBox.square(
                dimension: 112,
                child: Material(
                  color: context.brand.hero,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: ProgressRing(
                        progress: count / target,
                        size: 100,
                        strokeWidth: 4,
                        color: context.brand.gold,
                        trackColor: context.brand.onHero.withValues(
                          alpha: 0.15,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              f.number(count),
                              textScaler: TextScaler.noScaling,
                              style: context.text.headlineMedium!.copyWith(
                                color: context.brand.onHero,
                                fontFeatures: AppTypography.tabularFigures,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              l10n.dhikrCounterButton,
                              textScaler: TextScaler.noScaling,
                              style: context.text.labelSmall!.copyWith(
                                color: context.brand.onHeroMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                child: TextButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right_rounded),
                  label: Text(l10n.actionNext),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
