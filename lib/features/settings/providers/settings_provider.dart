import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/location_selection.dart';
import '../../../domain/entities/prayer_settings.dart';
import '../../../domain/repositories/settings_repository.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

/// Holds user preferences in memory and writes every change through to disk.
class SettingsNotifier extends Notifier<AppSettings> {
  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

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
}

final themeModeProvider = Provider<ThemeMode>((ref) {
  return switch (ref.watch(settingsProvider.select((s) => s.themeMode))) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
});
