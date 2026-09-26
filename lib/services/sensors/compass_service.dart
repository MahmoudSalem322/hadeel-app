import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';

@immutable
class CompassReading {
  const CompassReading({required this.heading, this.accuracy});

  /// Degrees clockwise from north, or null when the sensor gives no value.
  final double? heading;

  /// Estimated error in degrees, when the platform reports it.
  final double? accuracy;
}

/// Device heading from the magnetometer. Works offline.
abstract interface class CompassService {
  /// Null when the device has no compass sensor.
  Stream<CompassReading>? get readings;
}

class FlutterCompassService implements CompassService {
  const FlutterCompassService();

  @override
  Stream<CompassReading>? get readings {
    if (kIsWeb) return null;
    return FlutterCompass.events?.map((e) => CompassReading(heading: e.heading, accuracy: e.accuracy));
  }
}
