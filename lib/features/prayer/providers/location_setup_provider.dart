import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/core_providers.dart';
import '../../../domain/entities/city.dart';
import '../../../domain/entities/location_selection.dart';
import '../../settings/providers/settings_provider.dart';

@immutable
class LocationSetupState {
  const LocationSetupState({this.locating = false, this.failure});

  final bool locating;
  final LocationFailure? failure;
}

final locationSetupProvider =
    NotifierProvider.autoDispose<LocationSetupNotifier, LocationSetupState>(LocationSetupNotifier.new);

/// Drives "use my location" / "choose city". A failed GPS attempt leaves a
/// [LocationFailure] for the UI to explain, with manual city as the way out.
class LocationSetupNotifier extends Notifier<LocationSetupState> {
  @override
  LocationSetupState build() => const LocationSetupState();

  /// Returns `true` when a GPS location was saved.
  Future<bool> useDeviceLocation() async {
    if (state.locating) return false;
    state = const LocationSetupState(locating: true);

    final result = await ref.read(locationServiceProvider).currentPosition();
    if (!ref.mounted) return false;

    switch (result) {
      case Ok(:final value):
        final timezone = await ref.read(deviceTimezoneServiceProvider).localTimezone();
        if (!ref.mounted) return false;
        await ref.read(settingsProvider.notifier).setLocation(
              GpsLocationSelection(
                coordinates: value,
                timezone: timezone,
                capturedAt: ref.read(clockProvider).now().toUtc(),
              ),
            );
        if (ref.mounted) state = const LocationSetupState();
        return true;
      case Err(:final error):
        state = LocationSetupState(failure: error);
        return false;
    }
  }

  Future<void> chooseCity(City city) async {
    await ref.read(settingsProvider.notifier).setLocation(CityLocationSelection(city.id));
    if (ref.mounted) state = const LocationSetupState();
  }
}
