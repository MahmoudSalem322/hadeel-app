import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/next_prayer.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/colorful_hero.dart';
import '../../../shared/widgets/hadeel_card.dart';
import '../../../shared/widgets/progress_ring.dart';
import '../../prayer/providers/location_setup_provider.dart';
import '../../prayer/providers/prayer_providers.dart';
import '../../prayer/widgets/city_picker_sheet.dart';
import '../../prayer/widgets/location_setup_panel.dart';
import '../../prayer/widgets/prayer_icon.dart';

/// The most prominent element on Home: next prayer, its time and a live
/// countdown. Switches to the following prayer automatically.
class NextPrayerCard extends ConsumerWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = ref.watch(nextPrayerProvider);
    if (next == null) return const _MissingLocationCard();
    return _NextPrayerHero(next: next);
  }
}

class _NextPrayerHero extends ConsumerWidget {
  const _NextPrayerHero({required this.next});

  final NextPrayer next;

  Future<void> _changeCity(BuildContext context, WidgetRef ref) async {
    final city = await showCityPicker(context);
    if (city != null) {
      await ref.read(locationSetupProvider.notifier).chooseCity(city);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final brand = context.brand;
    final f = context.formatters;
    final location = ref.watch(resolvedLocationProvider);
    final prayerName = l10n.prayerLabel(next.prayer);
    final timeText = f.time(next.time);
    final locationLabel = location == null || location.isGps
        ? l10n.locationCurrent
        : location.city!.localizedName(context.languageCode);

    return _MinuteSemantics(
      next: next,
      prayerName: prayerName,
      timeText: timeText,
      child: ColorfulHero(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeNextPrayer,
                        style: context.text.labelMedium!.copyWith(
                          color: brand.onHeroMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      AnimatedSwitcher(
                        duration: AppMotion.slow,
                        child: Text(
                          prayerName,
                          key: ValueKey(next.prayer),
                          style: context.text.displaySmall!.copyWith(
                            color: brand.onHero,
                          ),
                        ),
                      ),
                      Text(
                        timeText,
                        style: context.text.titleMedium!.copyWith(
                          color: brand.onHero,
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _ProgressBadge(next: next),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(color: brand.onHero.withValues(alpha: 0.12)),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Text(
                  l10n.homeRemaining,
                  style: context.text.labelMedium!.copyWith(
                    color: brand.onHeroMuted,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                _Countdown(next: next),
                const Spacer(),
                Flexible(
                  flex: 3,
                  child: TextButton.icon(
                    onPressed: () => _changeCity(context, ref),
                    style: TextButton.styleFrom(
                      foregroundColor: brand.onHeroMuted,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                    ),
                    icon: Icon(
                      location?.isGps ?? false
                          ? Icons.my_location_rounded
                          : Icons.location_on_outlined,
                      size: 18,
                    ),
                    label: Text(
                      locationLabel,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelMedium!.copyWith(
                        color: brand.onHeroMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Only this text rebuilds every second.
class _Countdown extends ConsumerWidget {
  const _Countdown({required this.next});

  final NextPrayer next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider);
    return Text(
      context.formatters.countdown(next.remaining(now)),
      textDirection: TextDirection.ltr,
      style: context.text.titleLarge!.copyWith(
        color: context.brand.onHero,
        fontFeatures: AppTypography.tabularFigures,
      ),
    );
  }
}

class _ProgressBadge extends ConsumerWidget {
  const _ProgressBadge({required this.next});

  final NextPrayer next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Minute resolution is plenty for a ring and saves repaints.
    final minute = ref.watch(
      nowProvider.select((n) => n.millisecondsSinceEpoch ~/ 60000),
    );
    final now = DateTime.fromMillisecondsSinceEpoch(minute * 60000);
    final brand = context.brand;
    return ExcludeSemantics(
      child: ProgressRing(
        size: 76,
        strokeWidth: 4,
        progress: next.progress(now),
        color: brand.gold,
        trackColor: brand.onHero.withValues(alpha: 0.14),
        child: Icon(prayerIcon(next.prayer), color: brand.onHero, size: 28),
      ),
    );
  }
}

/// Screen-reader summary that updates once a minute, not every second.
class _MinuteSemantics extends ConsumerWidget {
  const _MinuteSemantics({
    required this.next,
    required this.prayerName,
    required this.timeText,
    required this.child,
  });

  final NextPrayer next;
  final String prayerName;
  final String timeText;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minute = ref.watch(
      nowProvider.select((n) => n.millisecondsSinceEpoch ~/ 60000),
    );
    final remaining = next.remaining(
      DateTime.fromMillisecondsSinceEpoch(minute * 60000),
    );
    final hm = context.formatters.countdown(remaining).substring(0, 5);
    return Semantics(
      container: true,
      label: context.l10n.nextPrayerSemantics(prayerName, timeText, hm),
      child: child,
    );
  }
}

class _MissingLocationCard extends StatelessWidget {
  const _MissingLocationCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return HadeelCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.locationMissingTitle,
                  style: context.text.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.locationMissingBody,
            style: context.text.bodyMedium!.copyWith(
              color: context.brand.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const LocationSetupPanel(),
        ],
      ),
    );
  }
}
