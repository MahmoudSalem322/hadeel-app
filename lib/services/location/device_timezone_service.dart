import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

/// Resolves the device's IANA timezone id, offline.
abstract interface class DeviceTimezoneService {
  Future<String> localTimezone();
}

class FlutterDeviceTimezoneService implements DeviceTimezoneService {
  const FlutterDeviceTimezoneService();

  @override
  Future<String> localTimezone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.getLocation(info.identifier); // throws if unknown to the bundled db
      return info.identifier;
    } catch (_) {
      return fallbackForOffset(DateTime.now().timeZoneOffset);
    }
  }

  /// When the platform can't name its zone (e.g. some web browsers), pick a
  /// bundled zone whose current offset matches the device, preferring the
  /// zones used in Palestine.
  static String fallbackForOffset(Duration offset, {DateTime? at}) {
    final now = at ?? DateTime.now();
    const preferred = ['Asia/Hebron', 'Asia/Gaza', 'Asia/Jerusalem', 'Asia/Amman', 'Asia/Riyadh'];
    bool matches(String id) =>
        tz.TZDateTime.from(now, tz.getLocation(id)).timeZoneOffset == offset;

    for (final id in preferred) {
      if (matches(id)) return id;
    }
    for (final id in tz.timeZoneDatabase.locations.keys) {
      if (id.contains('/') && matches(id)) return id;
    }
    return 'UTC';
  }
}
