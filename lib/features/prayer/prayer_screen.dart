import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/core_providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/prayer.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/liquid_glass.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/section_header.dart';
import '../home/providers/home_providers.dart';
import '../home/widgets/next_prayer_card.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/location_setup_provider.dart';
import 'providers/notification_providers.dart';
import 'providers/prayer_providers.dart';
import 'widgets/city_picker_sheet.dart';
import 'widgets/location_failure_text.dart';
import 'widgets/prayer_icon.dart';
import 'widgets/prayer_settings_pickers.dart';

/// مواقيت الصلاة: today's timeline, next prayer, location and method.
class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final f = context.formatters;
    final hasLocation = ref.watch(resolvedLocationProvider) != null;
    final hijri = ref.watch(todayHijriProvider);
    final today = ref.watch(todayDateProvider);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const LiquidGlass(radius: 0, child: SizedBox.expand()),
        title: Text(l10n.featurePrayerTimes),
      ),
      body: ResponsiveBody(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenGutter,
            0,
            AppSpacing.screenGutter,
            AppSpacing.lg + context.navBarInset,
          ),
          children: [
            Text(
              l10n.hijriLabel(hijri, f),
              style: context.text.titleSmall!.copyWith(
                color: context.brand.goldText,
              ),
            ),
            Text(f.gregorianDate(today), style: context.text.bodySmall),
            const SizedBox(height: AppSpacing.md),
            const NextPrayerCard(),
            if (hasLocation) ...[
              SectionHeader(title: l10n.homeTodayPrayerTimes),
              const _Timeline(),
              SectionHeader(title: l10n.settingsLocation),
              const _LocationCard(),
              SectionHeader(title: l10n.prayerMethod),
              const _MethodCard(),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.prayerCalcNote,
                style: context.text.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Timeline extends ConsumerWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(todayPrayerDayProvider);
    if (day == null) return const SizedBox.shrink();
    final next = ref.watch(nextPrayerProvider);
    // Minute resolution is enough to grey out passed prayers.
    final minute = ref.watch(
      nowProvider.select((n) => n.millisecondsSinceEpoch ~/ 60000),
    );
    final now = DateTime.fromMillisecondsSinceEpoch(minute * 60000);
    final enabled = ref.watch(
      settingsProvider.select((s) => s.notifications.enabled),
    );
    final entries = day.entries;

    return HadeelCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            _TimelineRow(
              prayer: entries[i].key,
              time: entries[i].value,
              isNext:
                  next != null &&
                  next.prayer == entries[i].key &&
                  next.time.isAtSameMomentAs(entries[i].value),
              passed: !entries[i].value.isAfter(now),
              first: i == 0,
              last: i == entries.length - 1,
              notify: enabled.contains(entries[i].key),
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends ConsumerWidget {
  const _TimelineRow({
    required this.prayer,
    required this.time,
    required this.isNext,
    required this.passed,
    required this.first,
    required this.last,
    required this.notify,
  });

  final Prayer prayer;
  final DateTime time;
  final bool isNext;
  final bool passed;
  final bool first;
  final bool last;
  final bool notify;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name = l10n.prayerLabel(prayer);
    final timeText = context.formatters.time(time);
    final muted = passed && !isNext;
    final fg = isNext
        ? context.colors.primary
        : muted
        ? context.brand.textSecondary
        : context.colors.onSurface;
    final lineColor = context.brand.divider;

    return Semantics(
      label: '$name $timeText',
      selected: isNext,
      child: AnimatedContainer(
        duration: AppMotion.medium,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: isNext ? context.brand.highlight : null,
          borderRadius: AppRadius.mdAll,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.sm),
              // Timeline rail with a node per prayer.
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 2,
                        color: first ? Colors.transparent : lineColor,
                      ),
                    ),
                    Container(
                      width: isNext ? 14 : 10,
                      height: isNext ? 14 : 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isNext
                            ? context.brand.gold
                            : (muted ? lineColor : context.colors.primary),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: last ? Colors.transparent : lineColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(prayerIcon(prayer), size: 20, color: fg),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Text(
                    name,
                    style: context.text.titleMedium!.copyWith(
                      color: fg,
                      fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Text(
                timeText,
                style: context.text.titleMedium!.copyWith(
                  color: fg,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
              if (prayer.isObligatory)
                IconButton(
                  tooltip: l10n.notificationForPrayer(name),
                  isSelected: notify,
                  icon: Icon(
                    notify
                        ? Icons.notifications_active_rounded
                        : Icons.notifications_none_rounded,
                    color: notify
                        ? context.brand.goldText
                        : context.brand.textSecondary,
                  ),
                  onPressed: () async {
                    final ok = await setPrayerNotification(
                      ref,
                      prayer,
                      on: !notify,
                    );
                    if (!ok && context.mounted) {
                      showToast(context, l10n.notificationsDenied);
                    }
                  },
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends ConsumerWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final location = ref.watch(resolvedLocationProvider)!;
    final setup = ref.watch(locationSetupProvider);
    final label = location.isGps
        ? l10n.locationGpsLabel
        : location.city!.localizedName(context.languageCode);

    return HadeelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                location.isGps
                    ? Icons.my_location_rounded
                    : Icons.location_on_outlined,
                color: context.colors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: context.text.titleMedium)),
            ],
          ),
          if (setup.failure != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                setup.failure!.message(l10n),
                style: context.text.bodySmall!.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              OutlinedButton.icon(
                onPressed: setup.locating
                    ? null
                    : () => ref
                          .read(locationSetupProvider.notifier)
                          .useDeviceLocation(),
                icon: setup.locating
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location_rounded, size: 18),
                label: Text(l10n.locationUpdate),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final city = await showCityPicker(context);
                  if (city != null) {
                    await ref
                        .read(locationSetupProvider.notifier)
                        .chooseCity(city);
                  }
                },
                icon: const Icon(Icons.location_city_rounded, size: 18),
                label: Text(l10n.locationChangeCity),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends ConsumerWidget {
  const _MethodCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final s = ref.watch(settingsProvider.select((x) => x.prayer));
    return HadeelCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.calculate_outlined),
            title: Text(l10n.prayerMethod),
            subtitle: Text(l10n.calcMethodName(s.method.name)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => pickCalculationMethod(context, ref),
          ),
          const Divider(indent: 56),
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: Text(l10n.prayerMadhab),
            subtitle: Text(l10n.madhabName(s.madhab.name)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => pickMadhab(context, ref),
          ),
        ],
      ),
    );
  }
}
