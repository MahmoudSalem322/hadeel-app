import 'package:meta/meta.dart';

import 'location_selection.dart';
import 'prayer_settings.dart';

enum AppThemeMode { system, light, dark }

/// User preferences, persisted on the device.
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.onboardingDone = false,
    this.prayer = PrayerSettings.defaults,
    this.location,
  });

  final AppThemeMode themeMode;
  final bool onboardingDone;
  final PrayerSettings prayer;
  final LocationSelection? location;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    bool? onboardingDone,
    PrayerSettings? prayer,
    LocationSelection? location,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      prayer: prayer ?? this.prayer,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.onboardingDone == onboardingDone &&
      other.prayer == prayer &&
      other.location == location;

  @override
  int get hashCode => Object.hash(themeMode, onboardingDone, prayer, location);
}
