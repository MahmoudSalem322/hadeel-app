import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/library.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/hadeel_bottom_sheet.dart';
import '../../shared/widgets/progress_ring.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/tasbeeh_provider.dart';

class TasbeehScreen extends ConsumerWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final counter = ref.watch(tasbeehProvider);
    final phrase = ref.watch(settingsProvider.select((s) => s.tasbeeh.phraseKey));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureTasbeeh),
        actions: [
          IconButton(
            tooltip: l10n.featureSettings,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: ContentAsync<TasbeehCounter>(
        value: counter,
        onRetry: () => ref.invalidate(tasbeehProvider),
        data: (c) => LayoutBuilder(
          builder: (context, constraints) {
            final ring = (constraints.maxWidth * 0.72).clamp(200.0, 320.0);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenGutter),
              child: Column(
                children: [
                  Text(
                    l10n.tasbeehPhrase(phrase),
                    textAlign: TextAlign.center,
                    style: contentTextStyle(context, size: 30).copyWith(height: 1.6),
                  ),
                  TextButton.icon(
                    onPressed: () => _pickPhrase(context, ref),
                    icon: const Icon(Icons.swap_horiz_rounded),
                    label: Text(l10n.tasbeehChangeDhikr),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _CounterButton(counter: c, size: ring),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${l10n.tasbeehTotal(context.formatters.number(c.total))}'
                    '${c.hasTarget ? '  ·  ${l10n.tasbeehRounds(context.formatters.number(c.rounds))}' : ''}',
                    style: context.text.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(l10n.tasbeehTarget, style: context.text.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  SegmentedButton<int>(
                    segments: [
                      for (final t in TasbeehCounter.targets)
                        ButtonSegment(
                          value: t,
                          label: Text(t == 0 ? l10n.tasbeehUnlimited : context.formatters.number(t)),
                        ),
                    ],
                    selected: {c.target},
                    onSelectionChanged: (v) => ref.read(tasbeehProvider.notifier).setTarget(v.first),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: c.count == 0 ? null : () => ref.read(tasbeehProvider.notifier).reset(),
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text(l10n.tasbeehReset),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _pickPhrase(BuildContext context, WidgetRef ref) {
    final current = ref.read(settingsProvider).tasbeeh.phraseKey;
    showHadeelBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: RadioGroup<String>(
            groupValue: current,
            onChanged: (v) {
              if (v == null) return;
              ref.read(tasbeehProvider.notifier).selectPhrase(v);
              Navigator.of(context).pop();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: AppSpacing.screenPadding,
                  child: Text(context.l10n.tasbeehChangeDhikr, style: context.text.titleLarge),
                ),
                for (final key in TasbeehSettings.phrases)
                  RadioListTile<String>(
                    value: key,
                    title: Text(context.l10n.tasbeehPhrase(key), style: contentTextStyle(context, size: 20)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showHadeelBottomSheet<void>(context: context, builder: (_) => const TasbeehSettingsSheet());
  }
}

class TasbeehSettingsSheet extends ConsumerWidget {
  const TasbeehSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final s = ref.watch(settingsProvider.select((x) => x.tasbeeh));
    final notifier = ref.read(settingsProvider.notifier);
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text(l10n.tasbeehVibration),
            value: s.vibration,
            onChanged: (v) => notifier.setTasbeehSettings(s.copyWith(vibration: v)),
          ),
          SwitchListTile(
            title: Text(l10n.tasbeehSound),
            value: s.sound,
            onChanged: (v) => notifier.setTasbeehSettings(s.copyWith(sound: v)),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _CounterButton extends ConsumerWidget {
  const _CounterButton({required this.counter, required this.size});

  final TasbeehCounter counter;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final f = context.formatters;
    final brand = context.brand;

    void tap() {
      final s = ref.read(settingsProvider).tasbeeh;
      final completesRound = counter.hasTarget && counter.count + 1 == counter.target;
      if (s.vibration) {
        completesRound ? HapticFeedback.heavyImpact() : HapticFeedback.selectionClick();
      }
      if (s.sound) SystemSound.play(SystemSoundType.click);
      ref.read(tasbeehProvider.notifier).increment();
    }

    return Semantics(
      button: true,
      label: '${l10n.tasbeehTapHint}، ${f.number(counter.count)}',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: Material(
          color: brand.hero,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: tap,
            child: Padding(
              padding: EdgeInsets.all(size * 0.05),
              child: ProgressRing(
                progress: counter.progress,
                size: size * 0.9,
                strokeWidth: 6,
                color: brand.gold,
                trackColor: brand.onHero.withValues(alpha: 0.14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: AppMotion.fast,
                      transitionBuilder: (child, a) => ScaleTransition(
                        scale: Tween<double>(begin: 0.85, end: 1).animate(a),
                        child: FadeTransition(opacity: a, child: child),
                      ),
                      child: Text(
                        f.number(counter.count),
                        key: ValueKey(counter.count),
                        textScaler: TextScaler.noScaling,
                        style: context.text.displayLarge!.copyWith(
                          color: brand.onHero,
                          fontSize: size * 0.24,
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                    ),
                    if (counter.hasTarget)
                      Text(
                        '/ ${f.number(counter.target)}',
                        textScaler: TextScaler.noScaling,
                        style: context.text.titleMedium!.copyWith(color: brand.onHeroMuted),
                      ),
                    Text(
                      l10n.tasbeehTapHint,
                      textScaler: TextScaler.noScaling,
                      style: context.text.labelMedium!.copyWith(color: brand.onHeroMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
