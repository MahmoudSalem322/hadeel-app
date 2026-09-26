import 'dart:math' as math;

import '../entities/geo.dart';

/// The Kaaba, Makkah.
const GeoCoordinates kaaba = GeoCoordinates(21.4225241, 39.8261818);

const double _earthRadiusKm = 6371.0088;

double _rad(double deg) => deg * math.pi / 180;
double _deg(double rad) => rad * 180 / math.pi;

/// Initial great-circle bearing from [from] to the Kaaba, in degrees
/// clockwise from true north, `[0, 360)`.
double qiblaBearing(GeoCoordinates from) {
  final phi1 = _rad(from.latitude);
  final phi2 = _rad(kaaba.latitude);
  final dLambda = _rad(kaaba.longitude - from.longitude);
  final y = math.sin(dLambda) * math.cos(phi2);
  final x = math.cos(phi1) * math.sin(phi2) - math.sin(phi1) * math.cos(phi2) * math.cos(dLambda);
  return (_deg(math.atan2(y, x)) + 360) % 360;
}

/// Great-circle (haversine) distance to the Kaaba in kilometres.
double distanceToKaabaKm(GeoCoordinates from) {
  final dPhi = _rad(kaaba.latitude - from.latitude);
  final dLambda = _rad(kaaba.longitude - from.longitude);
  final a = math.pow(math.sin(dPhi / 2), 2) +
      math.cos(_rad(from.latitude)) * math.cos(_rad(kaaba.latitude)) * math.pow(math.sin(dLambda / 2), 2);
  return 2 * _earthRadiusKm * math.asin(math.min(1, math.sqrt(a)));
}

/// Signed turn from the phone's [heading] to the qibla [bearing], in
/// `(-180, 180]`. Positive means turn clockwise (right).
double turnToQibla({required double heading, required double bearing}) {
  var diff = (bearing - heading) % 360;
  if (diff > 180) diff -= 360;
  return diff;
}
