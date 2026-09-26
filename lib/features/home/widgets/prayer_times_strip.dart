import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/prayer.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/hadeel_card.dart';
import '../../prayer/providers/prayer_providers.dart';
import '../../prayer/widgets/prayer_icon.dart';

/// Today's six times in a 3 × 2 grid; the next prayer is highlighted.
class PrayerTimesStrip extends ConsumerWidget {
  const PrayerTimesStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(todayPrayerDayProvider);
    if (day == null) return const SizedBox.shrink();
    final next = ref.watch(nextPrayerProvider);
    // Highlight only if the next prayer falls on the displayed day.
    final highlighted = next != null && day.timeOf(next.prayer).isAtSameMomentAs(next.time)
        ? next.prayer
        : null;

    return HadeelCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / 3;
          return Wrap(
            children: [
              for (final entry in day.entries)
                SizedBox(
                  width: cellWidth,
                  child: _PrayerCell(
                    prayer: entry.key,
                    time: entry.value,
                    highlighted: entry.key == highlighted,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PrayerCell extends StatelessWidget {
  const _PrayerCell({required this.prayer, required this.time, required this.highlighted});

  final Prayer prayer;
  final DateTime time;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = l10n.prayerLabel(prayer);
    final timeText = context.formatters.time(time);
    final muted = !prayer.isObligatory;
    final fg = highlighted ? context.colors.primary : context.colors.onSurface;

    return Semantics(
      label: '$name $timeText',
      selected: highlighted,
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: AppMotion.medium,
          margin: const EdgeInsets.all(AppSpacing.xxs),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: highlighted ? context.brand.highlight : null,
            borderRadius: AppRadius.mdAll,
          ),
          child: Column(
            children: [
              Icon(
                prayerIcon(prayer),
                size: 20,
                color: highlighted ? context.colors.primary : context.brand.textSecondary,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                name,
                style: context.text.labelMedium!.copyWith(
                  color: muted ? context.brand.textSecondary : fg,
                  fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              Text(
                timeText,
                style: context.text.titleSmall!.copyWith(
                  color: muted ? context.brand.textSecondary : fg,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
