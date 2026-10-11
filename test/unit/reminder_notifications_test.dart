import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/domain/entities/app_settings.dart';
import 'package:hadeel/domain/usecases/plan_reminder_notifications.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);
  test('hourly reminders cover 7 AM through midnight and skip past times', () {
    final requests = planReminderNotifications(
      now: zoned('Asia/Hebron', 2026, 10, 10, 6),
      zone: 'Asia/Hebron',
      settings: const NotificationSettings(),
      language: 'ar',
      dhikr: const [],
      hadith: const [],
    );
    final hourly = requests.where((r) => r.id >= 3000 && r.id < 4000).toList();
    expect(hourly.length, 18);
    expect(hourly.map((r) => r.time.hour).toSet(), {
      0,
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
    });
    expect(
      hourly.every(
        (r) =>
            r.repeat && r.time.isAfter(zoned('Asia/Hebron', 2026, 10, 10, 6)),
      ),
      isTrue,
    );
    expect(hourly.every((r) => r.time.minute == 0), isTrue);
    expect(hourly.first.body, contains('محمد'));
  });
  test('daily content varies by date, preserves source and uses future daytime slots', () {
    final requests = planReminderNotifications(
      now: zoned('Asia/Hebron', 2026, 10, 10),
      zone: 'Asia/Hebron',
      settings: const NotificationSettings(),
      language: 'ar',
      dhikr: const ['ذكر أ', 'ذكر ب', 'ذكر ج', 'ذكر د'],
      hadith: const ['حديث أ', 'حديث ب', 'حديث ج', 'حديث د'],
    );
    final daily = requests.where((r) => r.id >= 4000).toList();
    expect(daily.length, 15);
    expect(daily.map((r) => r.id).toSet().length, daily.length);
    expect(
      daily.every(
        (r) =>
            !r.repeat &&
            r.time.hour >= 9 &&
            r.time.hour <= 21 &&
            r.time.minute != 0,
      ),
      isTrue,
    );
    expect(daily[0].body, isNot(daily[3].body));
    expect(daily[1].body, startsWith('حديث'));
    expect(daily[0].body, startsWith('ذكر'));
    expect(requests.length + 25, lessThanOrEqualTo(64));
  });
  test('switches disable reminder families independently', () {
    final requests = planReminderNotifications(
      now: zoned('Asia/Hebron', 2026, 10, 10, 23, 59),
      zone: 'Asia/Hebron',
      settings: const NotificationSettings(
        hourlyDhikr: false,
        dailyContent: false,
      ),
      language: 'en',
      dhikr: const ['ذكر'],
      hadith: const ['حديث'],
    );
    expect(requests, isEmpty);
  });
}
