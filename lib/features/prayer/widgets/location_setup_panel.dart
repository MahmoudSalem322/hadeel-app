import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/buttons.dart';
import '../providers/location_setup_provider.dart';
import '../providers/prayer_providers.dart';
import 'city_picker_sheet.dart';
import 'location_failure_text.dart';

/// "Use my location" / "Choose city" with status feedback. If GPS fails,
/// the error explains why and the city picker remains one tap away.
class LocationSetupPanel extends ConsumerWidget {
  const LocationSetupPanel({super.key});

  Future<void> _pickCity(BuildContext context, WidgetRef ref) async {
    final city = await showCityPicker(context);
    if (city != null) await ref.read(locationSetupProvider.notifier).chooseCity(city);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final setup = ref.watch(locationSetupProvider);
    final location = ref.watch(resolvedLocationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: l10n.locationUseMine,
          icon: Icons.my_location_rounded,
          loading: setup.locating,
          onPressed: () => ref.read(locationSetupProvider.notifier).useDeviceLocation(),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: setup.failure == null ? l10n.locationChooseCity : l10n.locationChooseCityManually,
          icon: Icons.location_city_rounded,
          onPressed: setup.locating ? null : () => _pickCity(context, ref),
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _Status(
            key: ValueKey('${setup.locating}-${setup.failure}-${location?.city?.id}-${location?.isGps}'),
            locating: setup.locating,
            failureText: setup.failure == null
                ? null
                : '${l10n.locationErrorTitle}\n${setup.failure!.message(l10n)}',
            successText: location == null
                ? null
                : location.isGps
                    ? l10n.locationSelectedGps
                    : l10n.locationSelectedCity(location.city!.localizedName(context.languageCode)),
          ),
        ),
      ],
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({super.key, required this.locating, this.failureText, this.successText});

  final bool locating;
  final String? failureText;
  final String? successText;

  @override
  Widget build(BuildContext context) {
    final (IconData? icon, String? text, Color color) = switch (this) {
      _Status(locating: true) => (null, context.l10n.locationLocating, context.brand.textSecondary),
      _Status(failureText: final String f) => (Icons.info_outline_rounded, f, context.colors.error),
      _Status(successText: final String s) => (Icons.check_circle_rounded, s, context.brand.success),
      _ => (null, null, context.brand.textSecondary),
    };
    if (text == null) return const SizedBox(height: 24);
    return Semantics(
      liveRegion: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: context.text.bodySmall!.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
