import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/prayer_settings.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/hadeel_bottom_sheet.dart';
import '../../settings/providers/settings_provider.dart';

/// Radio-list sheet for the calculation method.
Future<void> pickCalculationMethod(BuildContext context, WidgetRef ref) {
  return showHadeelBottomSheet<void>(
    context: context,
    builder: (context) => _OptionsSheet<CalculationMethodType>(
      title: context.l10n.prayerMethod,
      values: CalculationMethodType.values,
      selected: ref.read(settingsProvider).prayer.method,
      label: (m) => context.l10n.calcMethodName(m.name),
      onSelected: (m) {
        final s = ref.read(settingsProvider).prayer;
        ref.read(settingsProvider.notifier).setPrayerSettings(s.copyWith(method: m));
      },
    ),
  );
}

/// Radio-list sheet for the Asr madhab.
Future<void> pickMadhab(BuildContext context, WidgetRef ref) {
  return showHadeelBottomSheet<void>(
    context: context,
    builder: (context) => _OptionsSheet<AsrMadhab>(
      title: context.l10n.prayerMadhab,
      values: AsrMadhab.values,
      selected: ref.read(settingsProvider).prayer.madhab,
      label: (m) => context.l10n.madhabName(m.name),
      onSelected: (m) {
        final s = ref.read(settingsProvider).prayer;
        ref.read(settingsProvider.notifier).setPrayerSettings(s.copyWith(madhab: m));
      },
    ),
  );
}

class _OptionsSheet<T> extends StatelessWidget {
  const _OptionsSheet({
    required this.title,
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  final String title;
  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: RadioGroup<T>(
          groupValue: selected,
          onChanged: (v) {
            if (v == null) return;
            onSelected(v);
            Navigator.of(context).pop();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: Text(title, style: context.text.titleLarge),
              ),
              const SizedBox(height: AppSpacing.xs),
              for (final v in values) RadioListTile<T>(value: v, title: Text(label(v))),
            ],
          ),
        ),
      ),
    );
  }
}
