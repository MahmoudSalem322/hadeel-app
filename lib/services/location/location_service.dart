import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/geo.dart';

/// Obtains the device position. Works without internet (GNSS only).
abstract interface class LocationService {
  Future<Result<GeoCoordinates, LocationFailure>> currentPosition();
}

/// [LocationService] backed by `geolocator`. Never throws: every failure is
/// mapped to a [LocationFailure] so the UI can offer manual city selection.
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService({this.timeLimit = const Duration(seconds: 20)});

  final Duration timeLimit;

  @override
  Future<Result<GeoCoordinates, LocationFailure>> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const Err(LocationFailure.serviceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      switch (permission) {
        case LocationPermission.denied:
          return const Err(LocationFailure.permissionDenied);
        case LocationPermission.deniedForever:
          return const Err(LocationFailure.permissionDeniedForever);
        case LocationPermission.whileInUse:
        case LocationPermission.always:
        case LocationPermission.unableToDetermine:
          break;
      }

      // Prayer times need city-level accuracy only; medium is faster and
      // kinder to the battery than best.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: timeLimit,
        ),
      );
      return Ok(GeoCoordinates(position.latitude, position.longitude));
    } on TimeoutException {
      return const Err(LocationFailure.timeout);
    } on PermissionDeniedException {
      return const Err(LocationFailure.permissionDenied);
    } on LocationServiceDisabledException {
      return const Err(LocationFailure.serviceDisabled);
    } catch (_) {
      return const Err(LocationFailure.unknown);
    }
  }
}
