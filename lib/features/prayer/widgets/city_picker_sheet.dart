import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/arabic_normalizer.dart';
import '../../../domain/entities/city.dart';
import '../../../domain/entities/location_selection.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/hadeel_bottom_sheet.dart';
import '../../../shared/widgets/search_field.dart';
import '../../settings/providers/settings_provider.dart';

/// Opens the city picker and returns the chosen city (or `null`).
Future<City?> showCityPicker(BuildContext context) {
  return showHadeelBottomSheet<City>(
    context: context,
    expand: true,
    builder: (_) => const CityPickerSheet(),
  );
}

class CityPickerSheet extends ConsumerStatefulWidget {
  const CityPickerSheet({super.key});

  @override
  ConsumerState<CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends ConsumerState<CityPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cities = ref.watch(citiesProvider);
    final selection = ref.watch(settingsProvider.select((s) => s.location));
    final selectedId = selection is CityLocationSelection ? selection.cityId : null;

    final q = normalizeArabic(_query);
    final filtered = q.isEmpty
        ? cities
        : cities
            .where((c) => normalizeArabic(c.nameAr).contains(q) || normalizeArabic(c.nameEn).contains(q))
            .toList();

    // Group by region, preserving the bundled order.
    final groups = <String, List<City>>{};
    for (final c in filtered) {
      groups.putIfAbsent(c.region, () => []).add(c);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: Text(l10n.cityPickerTitle, style: context.text.titleLarge),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: AppSpacing.screenPadding,
          child: SearchField(
            hint: l10n.citySearchHint,
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    l10n.cityNoResults,
                    style: context.text.bodyMedium!.copyWith(color: context.brand.textSecondary),
                  ),
                )
              : ListView(
                  padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xl),
                  children: [
                    for (final entry in groups.entries) ...[
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.xxs,
                        ),
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.cityRegion(entry.key),
                            style: context.text.labelMedium!.copyWith(color: context.brand.goldText),
                          ),
                        ),
                      ),
                      for (final city in entry.value)
                        _CityTile(
                          city: city,
                          selected: city.id == selectedId,
                          onTap: () => Navigator.of(context).pop(city),
                        ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({required this.city, required this.selected, required this.onTap});

  final City city;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      selectedTileColor: context.brand.highlight,
      leading: Icon(selected ? Icons.location_on_rounded : Icons.location_on_outlined),
      title: Text(city.localizedName(context.languageCode)),
      trailing: selected ? Icon(Icons.check_rounded, color: context.colors.primary) : null,
    );
  }
}
