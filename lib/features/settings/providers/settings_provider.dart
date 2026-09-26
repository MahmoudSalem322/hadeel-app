import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/location_selection.dart';
import '../../../domain/entities/prayer.dart';
import '../../../domain/entities/prayer_settings.dart';
import '../../../domain/entities/quran_reading_settings.dart';
import '../../../domain/repositories/settings_repository.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

/// Holds user preferences in memory and writes every change through to disk.
class SettingsNotifier extends Notifier<AppSettings> {
  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> setColorTheme(AppColorTheme theme) async {
    state = state.copyWith(appColorTheme: theme);
    await _repo.saveColorTheme(theme);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repo.saveThemeMode(mode);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingDone: true);
    await _repo.saveOnboardingDone(done: true);
  }

  Future<void> setPrayerSettings(PrayerSettings settings) async {
    state = state.copyWith(prayer: settings);
    await _repo.savePrayerSettings(settings);
  }

  Future<void> setLocation(LocationSelection selection) async {
    state = state.copyWith(location: selection);
    await _repo.saveLocation(selection);
  }

  Future<void> updateQuranSettings(QuranReadingSettings Function(QuranReadingSettings) change) async {
    final next = change(state.quran);
    if (next == state.quran) return;
    state = state.copyWith(quran: next);
    await _repo.saveQuranSettings(next);
  }

  Future<void> setLanguage(String code) async {
    if (!AppSettings.supportedLanguages.contains(code)) return;
    state = state.copyWith(languageCode: code);
    await _repo.saveLanguage(code);
  }

  Future<void> setPrayerNotification(Prayer prayer, {required bool on}) async {
    final next = state.notifications.toggled(prayer, on: on);
    state = state.copyWith(notifications: next);
    await _repo.saveNotificationSettings(next);
  }

  Future<void> setAllPrayerNotifications({required bool on}) async {
    final next = on ? NotificationSettings.allOn : const NotificationSettings();
    state = state.copyWith(notifications: next);
    await _repo.saveNotificationSettings(next);
  }

  Future<void> setTasbeehSettings(TasbeehSettings settings) async {
    state = state.copyWith(tasbeeh: settings);
    await _repo.saveTasbeehSettings(settings);
  }

  Future<void> setHijriAdjustment(int days) async {
    state = state.copyWith(hijriAdjustment: days);
    await _repo.saveHijriAdjustment(state.hijriAdjustment);
  }
}

final localeProvider = Provider<Locale>(
  (ref) => Locale(ref.watch(settingsProvider.select((s) => s.languageCode))),
);

final quranSettingsProvider = Provider<QuranReadingSettings>(
  (ref) => ref.watch(settingsProvider.select((s) => s.quran)),
);

final colorThemeProvider = Provider<AppColorTheme>(
  (ref) => ref.watch(settingsProvider.select((s) => s.appColorTheme)),
);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return switch (ref.watch(settingsProvider.select((s) => s.themeMode))) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
});


