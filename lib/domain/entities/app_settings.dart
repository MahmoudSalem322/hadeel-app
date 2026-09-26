import 'package:meta/meta.dart';

import 'location_selection.dart';
import 'prayer_settings.dart';
import 'quran_reading_settings.dart';

enum AppThemeMode { system, light, dark }

/// User preferences, persisted on the device.
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.onboardingDone = false,
    this.prayer = PrayerSettings.defaults,
    this.quran = const QuranReadingSettings(),
    this.location,
  });

  final AppThemeMode themeMode;
  final bool onboardingDone;
  final PrayerSettings prayer;
  final QuranReadingSettings quran;
  final LocationSelection? location;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    bool? onboardingDone,
    PrayerSettings? prayer,
    QuranReadingSettings? quran,
    LocationSelection? location,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      prayer: prayer ?? this.prayer,
      quran: quran ?? this.quran,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.onboardingDone == onboardingDone &&
      other.prayer == prayer &&
      other.quran == quran &&
      other.location == location;

  @override
  int get hashCode => Object.hash(themeMode, onboardingDone, prayer, quran, location);
}
