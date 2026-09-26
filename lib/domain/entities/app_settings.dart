import 'package:meta/meta.dart';

import 'location_selection.dart';
import 'prayer.dart';
import 'prayer_settings.dart';
import 'quran_reading_settings.dart';

enum AppThemeMode { system, light, dark }

/// Which prayers raise a local notification.
@immutable
class NotificationSettings {
  const NotificationSettings({this.enabled = const {}});

  /// All five obligatory prayers on.
  static final NotificationSettings allOn = NotificationSettings(enabled: Prayer.obligatory.toSet());

  final Set<Prayer> enabled;

  bool isOn(Prayer p) => enabled.contains(p);

  NotificationSettings toggled(Prayer p, {required bool on}) =>
      NotificationSettings(enabled: {...enabled.where((e) => e != p), if (on) p});

  @override
  bool operator ==(Object other) =>
      other is NotificationSettings && other.enabled.length == enabled.length && other.enabled.containsAll(enabled);

  @override
  int get hashCode => Object.hashAllUnordered(enabled);
}

@immutable
class TasbeehSettings {
  const TasbeehSettings({this.vibration = true, this.sound = false});

  final bool vibration;
  final bool sound;

  TasbeehSettings copyWith({bool? vibration, bool? sound}) =>
      TasbeehSettings(vibration: vibration ?? this.vibration, sound: sound ?? this.sound);

  @override
  bool operator ==(Object other) => other is TasbeehSettings && other.vibration == vibration && other.sound == sound;

  @override
  int get hashCode => Object.hash(vibration, sound);
}

/// User preferences, persisted on the device.
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.languageCode = 'ar',
    this.onboardingDone = false,
    this.prayer = PrayerSettings.defaults,
    this.quran = const QuranReadingSettings(),
    this.notifications = const NotificationSettings(),
    this.tasbeeh = const TasbeehSettings(),
    this.hijriAdjustment = 0,
    this.location,
  });

  static const List<String> supportedLanguages = ['ar', 'en'];
  static const int maxHijriAdjustment = 2;

  final AppThemeMode themeMode;
  final String languageCode;
  final bool onboardingDone;
  final PrayerSettings prayer;
  final QuranReadingSettings quran;
  final NotificationSettings notifications;
  final TasbeehSettings tasbeeh;

  /// Days added to the Umm al-Qura date to match local moon sighting.
  final int hijriAdjustment;
  final LocationSelection? location;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    String? languageCode,
    bool? onboardingDone,
    PrayerSettings? prayer,
    QuranReadingSettings? quran,
    NotificationSettings? notifications,
    TasbeehSettings? tasbeeh,
    int? hijriAdjustment,
    LocationSelection? location,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      prayer: prayer ?? this.prayer,
      quran: quran ?? this.quran,
      notifications: notifications ?? this.notifications,
      tasbeeh: tasbeeh ?? this.tasbeeh,
      hijriAdjustment: (hijriAdjustment ?? this.hijriAdjustment).clamp(-maxHijriAdjustment, maxHijriAdjustment),
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.languageCode == languageCode &&
      other.onboardingDone == onboardingDone &&
      other.prayer == prayer &&
      other.quran == quran &&
      other.notifications == notifications &&
      other.tasbeeh == tasbeeh &&
      other.hijriAdjustment == hijriAdjustment &&
      other.location == location;

  @override
  int get hashCode => Object.hash(
        themeMode,
        languageCode,
        onboardingDone,
        prayer,
        quran,
        notifications,
        tasbeeh,
        hijriAdjustment,
        location,
      );
}
