import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/prayer.dart';
import '../../../domain/usecases/plan_prayer_notifications.dart';
import '../../../services/notifications/notification_service.dart';
import '../../settings/providers/settings_provider.dart';
import 'prayer_providers.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => LocalNotificationService());

/// Keeps scheduled prayer notifications in sync with the location, method,
/// enabled prayers and language. Watched once from the app root.
final prayerNotificationSyncProvider = Provider<void>((ref) {
  final location = ref.watch(resolvedLocationProvider);
  final prayerSettings = ref.watch(settingsProvider.select((s) => s.prayer));
  final enabled = ref.watch(settingsProvider.select((s) => s.notifications.enabled));
  final language = ref.watch(settingsProvider.select((s) => s.languageCode));
  final service = ref.watch(notificationServiceProvider);
  final clock = ref.watch(clockProvider);
  final calculator = ref.watch(prayerCalculatorProvider);

  Future<void> sync() async {
    final l10n = lookupAppLocalizations(Locale(language));
    await service.init(
      channelName: l10n.notificationChannelName,
      channelDescription: l10n.notificationChannelDescription,
    );
    if (location == null) {
      await service.replaceAll(const []);
      return;
    }
    final f = AppFormatters(language);
    final place = location.city?.localizedName(language) ?? l10n.locationCurrent;
    final planned = planPrayerNotifications(
      now: clock.now(),
      location: location,
      settings: prayerSettings,
      enabled: enabled,
      calculator: calculator,
    );
    await service.replaceAll([
      for (final p in planned)
        NotificationRequest(
          planned: p,
          title: l10n.notificationTitle(l10n.prayerName(p.prayer.name)),
          body: l10n.notificationBody(place, f.time(p.time)),
          zone: location.timezone,
        ),
    ]);
  }

  // Errors here must never affect the UI; notifications are best-effort.
  unawaited(sync().catchError((Object _) {}));
});

/// Turns a prayer's notification on or off, asking for permission the first
/// time one is enabled. Returns false if the OS refused.
Future<bool> setPrayerNotification(WidgetRef ref, Prayer prayer, {required bool on}) async {
  if (on && !await ref.read(notificationServiceProvider).requestPermission()) return false;
  await ref.read(settingsProvider.notifier).setPrayerNotification(prayer, on: on);
  return true;
}

Future<bool> setAllPrayerNotifications(WidgetRef ref, {required bool on}) async {
  if (on && !await ref.read(notificationServiceProvider).requestPermission()) return false;
  await ref.read(settingsProvider.notifier).setAllPrayerNotifications(on: on);
  return true;
}
