import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/usecases/plan_prayer_notifications.dart';

/// A ready-to-schedule notification (text already localized).
@immutable
class NotificationRequest {
  const NotificationRequest({
    required this.planned,
    required this.title,
    required this.body,
    required this.zone,
  });

  final PlannedNotification planned;
  final String title;
  final String body;

  /// IANA zone of the location the time was computed for.
  final String zone;
}

/// Schedules local notifications on the device. No server involved.
abstract interface class NotificationService {
  Future<void> init({required String channelName, required String channelDescription});

  /// Asks the OS for permission. Returns whether notifications are allowed.
  Future<bool> requestPermission();

  /// Replaces every pending prayer notification with [requests].
  Future<void> replaceAll(List<NotificationRequest> requests);
}

class LocalNotificationService implements NotificationService {
  LocalNotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;
  String _channelName = 'Prayer times';
  String _channelDescription = '';

  static const String channelId = 'prayer_times';

  /// Notifications are a mobile feature; the web build is a dev preview.
  static bool get supported =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<void> init({required String channelName, required String channelDescription}) async {
    _channelName = channelName;
    _channelDescription = channelDescription;
    if (!supported || _ready) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_hadeel'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  @override
  Future<bool> requestPermission() async {
    if (!supported) return false;
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission() ?? false;
      // Exact timing is best-effort: if refused we still schedule inexactly.
      if (granted && !(await android.canScheduleExactNotifications() ?? false)) {
        await android.requestExactAlarmsPermission();
      }
      return granted;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(alert: true, sound: true, badge: false) ?? false;
  }

  @override
  Future<void> replaceAll(List<NotificationRequest> requests) async {
    if (!supported || !_ready) return;
    await _plugin.cancelAll();
    if (requests.isEmpty) return;

    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final exact = await android?.canScheduleExactNotifications() ?? true;
    final mode = exact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );

    for (final r in requests) {
      await _plugin.zonedSchedule(
        id: r.planned.id,
        title: r.title,
        body: r.body,
        scheduledDate: tz.TZDateTime.from(r.planned.time, tz.getLocation(r.zone)),
        notificationDetails: details,
        androidScheduleMode: mode,
      );
    }
  }
}
