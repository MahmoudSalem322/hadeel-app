import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../core/theme/app_spacing.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/geo.dart';
import '../../domain/entities/hijri_date.dart';
import '../../services/hijri/hijri_converter.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/responsive_body.dart';
import '../home/providers/home_providers.dart';
import '../prayer/providers/prayer_providers.dart';
import '../settings/providers/settings_provider.dart';

/// Month view of the Hijri (Umm al-Qura) calendar with Gregorian dates.
class HijriCalendarScreen extends ConsumerStatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  ConsumerState<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends ConsumerState<HijriCalendarScreen> {
  (int, int)? _month; // (year, month); null = current month
  HijriDate? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final f = context.formatters;
    final converter = ref.watch(hijriConverterProvider);
    final todayG = ref.watch(todayDateProvider);
    final todayH = ref.watch(todayHijriProvider);
    final (year, month) = _month ?? (todayH.year, todayH.month);
    final selected = _selected ?? todayH;

    final length = converter.monthLength(year, month);
    final firstG = converter.toGregorian(HijriDate(year, month, 1));
    // Weeks start on Saturday. DateTime.weekday: Mon=1 … Sat=6, Sun=7.
    final firstWeekday = DateTime(firstG.year, firstG.month, firstG.day).weekday;
    final leading = (firstWeekday - DateTime.saturday) % 7;

    final weekdayFormat = DateFormat.E(context.languageCode);
    final weekdayNames = [
      for (var i = 0; i < 7; i++) weekdayFormat.format(DateTime(2026, 1, 3).add(Duration(days: i))), // a Saturday
    ];

    void shift(int delta) => setState(() => _month = HijriConverter.shiftMonth(year, month, delta));

    final selectedG = converter.toGregorian(selected);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureHijriCalendar),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _month = null;
              _selected = null;
            }),
            child: Text(l10n.hijriToday),
          ),
        ],
      ),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenGutter),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: l10n.previousMonth,
                  onPressed: () => shift(-1),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        l10n.hijriMonthTitle(
                          l10n.hijriMonth('m$month'),
                          f.number(year).replaceAll(RegExp(r'[,٬]'), ''),
                        ),
                        style: context.text.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _gregorianSpan(context, firstG, converter.toGregorian(HijriDate(year, month, length))),
                        style: context.text.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.nextMonth,
                  onPressed: () => shift(1),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            HadeelCard(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                children: [
                  Row(
                    children: [
                      for (final w in weekdayNames)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                            child: Text(w, textAlign: TextAlign.center, style: context.text.labelSmall),
                          ),
                        ),
                    ],
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisExtent: 44 + 12 * MediaQuery.textScalerOf(context).scale(1),
                    ),
                    itemCount: leading + length,
                    itemBuilder: (context, i) {
                      if (i < leading) return const SizedBox.shrink();
                      final day = i - leading + 1;
                      final h = HijriDate(year, month, day);
                      final g = firstG.addDays(day - 1);
                      return _DayCell(
                        hijriDay: f.number(day),
                        gregorianDay: f.number(g.day),
                        isToday: g == todayG,
                        isSelected: h == selected,
                        semantics: '${l10n.hijriLabel(h, f)}، ${f.gregorianDate(g)}',
                        onTap: () => setState(() => _selected = h),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            HadeelCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.hijriLabel(selected, f), style: context.text.titleMedium),
                  Text(f.gregorianDate(selectedG), style: context.text.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _AdjustmentCard(),
          ],
        ),
      ),
    );
  }

  String _gregorianSpan(BuildContext context, CalendarDate a, CalendarDate b) {
    final fmt = DateFormat.yMMMM(context.languageCode)..useNativeDigits = false;
    final first = fmt.format(DateTime(a.year, a.month));
    final last = fmt.format(DateTime(b.year, b.month));
    return first == last ? first : '$first – $last';
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.hijriDay,
    required this.gregorianDay,
    required this.isToday,
    required this.isSelected,
    required this.semantics,
    required this.onTap,
  });

  final String hijriDay;
  final String gregorianDay;
  final bool isToday;
  final bool isSelected;
  final String semantics;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final bg = isToday
        ? brand.hero
        : isSelected
        ? brand.highlight
        : null;
    final fg = isToday ? brand.onHero : context.colors.onSurface;
    return Semantics(
      button: true,
      selected: isSelected,
      label: semantics,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(color: bg, borderRadius: AppRadius.mdAll),
          // A 7-column grid can't grow wider; very large text scales down to fit.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(hijriDay, style: context.text.titleSmall!.copyWith(color: fg)),
                Text(
                  gregorianDay,
                  style: context.text.labelSmall!.copyWith(color: isToday ? brand.onHeroMuted : brand.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdjustmentCard extends ConsumerWidget {
  const _AdjustmentCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final days = ref.watch(settingsProvider.select((s) => s.hijriAdjustment));
    final notifier = ref.read(settingsProvider.notifier);
    final label = days == 0 ? l10n.hijriNoAdjustment : l10n.hijriAdjustmentValue(days > 0 ? '+$days' : '$days');
    return HadeelCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.hijriAdjustment, style: context.text.titleSmall),
                Text(l10n.hijriAdjustmentHint, style: context.text.bodySmall),
              ],
            ),
          ),
          IconButton(
            onPressed: days <= -AppSettings.maxHijriAdjustment ? null : () => notifier.setHijriAdjustment(days - 1),
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
          Text(label, style: context.text.labelLarge, textDirection: TextDirection.ltr),
          IconButton(
            onPressed: days >= AppSettings.maxHijriAdjustment ? null : () => notifier.setHijriAdjustment(days + 1),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
    );
  }
}
