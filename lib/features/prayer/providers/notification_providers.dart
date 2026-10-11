import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/content.dart';
import '../../../domain/entities/prayer.dart';
import '../../../domain/usecases/plan_prayer_notifications.dart';
import '../../../domain/usecases/plan_reminder_notifications.dart';
import '../../../services/notifications/notification_service.dart';
import '../../settings/providers/settings_provider.dart';
import 'prayer_providers.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => LocalNotificationService(),
);
const List<int> kHourlyDhikrHours = [
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  0,
];

/// Serialises replacements so an older asynchronous sync cannot overwrite a
/// newer settings change. Invalidated providers discard work before scheduling.
final notificationQueueProvider = Provider<NotificationSyncQueue>(
  (ref) => NotificationSyncQueue(),
);

class NotificationSyncQueue {
  Future<void> _tail = Future.value();
  void enqueue(Future<void> Function() work) {
    _tail = _tail.then((_) => work()).catchError((
      Object error,
      StackTrace stack,
    ) {
      debugPrint('Notification scheduling failed: $error');
    });
  }
}

final prayerNotificationSyncProvider = Provider<void>((ref) {
  final location = ref.watch(resolvedLocationProvider);
  final settings = ref.watch(settingsProvider);
  final service = ref.watch(notificationServiceProvider);
  final clock = ref.watch(clockProvider);
  final calculator = ref.watch(prayerCalculatorProvider);
  final timezone = ref.watch(deviceTimezoneServiceProvider);
  final content = ref.watch(contentRepositoryProvider);
  var active = true;
  ref.onDispose(() => active = false);

  ref.read(notificationQueueProvider).enqueue(() async {
    if (!active) return;
    final language = settings.languageCode;
    final l10n = lookupAppLocalizations(Locale(language));
    await service.init(
      channelName: l10n.notificationChannelName,
      channelDescription: l10n.notificationChannelDescription,
    );
    final zone = await timezone.localTimezone();
    final requests = <NotificationRequest>[];
    if (location != null) {
      final f = AppFormatters(language);
      final place =
          location.city?.localizedName(language) ?? l10n.locationCurrent;
      for (final p in planPrayerNotifications(
        now: clock.now(),
        location: location,
        settings: settings.prayer,
        enabled: settings.notifications.enabled,
        calculator: calculator,
      )) {
        requests.add(
          NotificationRequest(
            id: p.id,
            time: p.time,
            title: l10n.notificationTitle(l10n.prayerName(p.prayer.name)),
            body: l10n.notificationBody(place, f.time(p.time)),
            zone: location.timezone,
          ),
        );
      }
    }
    var dhikr = <String>[];
    var hadith = <String>[];
    if (settings.notifications.dailyContent) {
      try {
        final hisn = await content.loadHisn();
        final library = await content.loadHadith();
        // General tasbih and istighfar only, with complete source text.
        dhikr = [
          for (final id in [129, 130, 131])
            for (final item in hisn.chapter(id)?.items ?? const <DhikrItem>[]) item.text,
        ];
        hadith = [
          for (final book in library.books)
            for (final item in book.hadiths)
              if (item.text.length <= 700) item.text,
        ];
      } catch (error) {
        debugPrint('Daily notification content unavailable: $error');
      }
    }
    requests.addAll(
      planReminderNotifications(
        now: clock.now(),
        zone: zone,
        settings: settings.notifications,
        language: language,
        dhikr: dhikr,
        hadith: hadith,
        days: !LocalNotificationService.supported || defaultTargetPlatform != TargetPlatform.android ? 5 : 30,
      ),
    );
    if (!active) return;
    // 25 prayer + 18 hourly + 2 category + 15 content = at most 60.
    await service.replaceAll(requests);
  });
});

Future<bool> setPrayerNotification(
  WidgetRef ref,
  Prayer prayer, {
  required bool on,
}) async {
  if (on && !await ref.read(notificationServiceProvider).requestPermission()) {
    return false;
  }
  await ref
      .read(settingsProvider.notifier)
      .setPrayerNotification(prayer, on: on);
  return true;
}

Future<bool> setAllPrayerNotifications(
  WidgetRef ref, {
  required bool on,
}) async {
  if (on && !await ref.read(notificationServiceProvider).requestPermission()) {
    return false;
  }
  await ref.read(settingsProvider.notifier).setAllPrayerNotifications(on: on);
  return true;
}

Future<bool> setHourlyDhikrReminder(WidgetRef ref, {required bool on}) async {
  if (on && !await ref.read(notificationServiceProvider).requestPermission()) {
    return false;
  }
  await ref.read(settingsProvider.notifier).setHourlyDhikr(on: on);
  return true;
}

Future<bool> setDailyContentReminder(WidgetRef ref, {required bool on}) async {
  if (on && !await ref.read(notificationServiceProvider).requestPermission()) {
    return false;
  }
  await ref.read(settingsProvider.notifier).setDailyContent(on: on);
  return true;
}
