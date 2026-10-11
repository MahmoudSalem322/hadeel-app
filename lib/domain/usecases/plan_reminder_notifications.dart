import 'dart:math';

import 'package:timezone/timezone.dart' as tz;

import '../../services/notifications/notification_service.dart';
import '../entities/app_settings.dart';

List<NotificationRequest> planReminderNotifications({
  required DateTime now,
  required String zone,
  required NotificationSettings settings,
  required String language,
  required List<String> dhikr,
  required List<String> hadith,
  int days = 5,
}) {
  final location = tz.getLocation(zone);
  final current = tz.TZDateTime.from(now, location);
  final ar = language == 'ar';
  final requests = <NotificationRequest>[];
  if (settings.hourlyDhikr) {
    for (final hour in [for (var h = 7; h <= 23; h++) h, 0]) {
      var at = tz.TZDateTime(
        location,
        current.year,
        current.month,
        current.day,
        hour,
      );
      if (!at.isAfter(current)) {
        at = tz.TZDateTime(
          location,
          current.year,
          current.month,
          current.day + 1,
          hour,
        );
      }
      requests.add(
        NotificationRequest(
          id: 3000 + hour,
          time: at,
          zone: zone,
          repeat: true,
          title: ar
              ? 'ذكر الله والصلاة على النبي ﷺ'
              : 'Remember Allah · Salawat',
          body: ar
              ? 'سبحان الله، والحمد لله، ولا إله إلا الله، والله أكبر. اللهم صلِّ وسلم على نبينا محمد ﷺ.'
              : 'Remember Allah and send blessings upon Prophet Muhammad ﷺ.',
        ),
      );
    }
  }
  if (!settings.dailyContent) return requests;
  // Repeating category reminders consume two slots rather than ten.
  for (final hour in [8, 21]) {
    var at = tz.TZDateTime(
      location,
      current.year,
      current.month,
      current.day,
      hour,
      10,
    );
    if (!at.isAfter(current)) {
      at = tz.TZDateTime(
        location,
        current.year,
        current.month,
        current.day + 1,
        hour,
        10,
      );
    }
    requests.add(
      NotificationRequest(
        id: 1000 + hour,
        time: at,
        zone: zone,
        repeat: true,
        title: ar
            ? (hour == 8 ? 'أذكار الصباح' : 'أذكار المساء')
            : (hour == 8 ? 'Morning adhkar' : 'Evening adhkar'),
        body: ar
            ? 'اجعل لذكر الله نصيباً من يومك، وافتح هديل لقراءة الأذكار.'
            : 'Open Hadeel for your daily adhkar.',
      ),
    );
  }
  // Shuffle verified text once, then advance through it by date. Reopening
  // does not change today's choices; consecutive dates use different entries.
  final dhikrDeck = [...dhikr]..shuffle(Random(7321));
  final hadithDeck = [...hadith]..shuffle(Random(9143));
  for (var d = 0; d < days; d++) {
    final date = tz.TZDateTime(
      location,
      current.year,
      current.month,
      current.day + d,
    );
    final ordinal = DateTime.utc(
      date.year,
      date.month,
      date.day,
    ).difference(DateTime.utc(2020)).inDays;
    final random = Random(ordinal);
    for (var slot = 0; slot < 3; slot++) {
      final isHadith = slot == 1;
      final deck = isHadith ? hadithDeck : dhikrDeck;
      if (deck.isEmpty) continue;
      final at = tz.TZDateTime(
        location,
        date.year,
        date.month,
        date.day,
        [9, 14, 19][slot] + random.nextInt(2),
        15 + random.nextInt(35),
      );
      if (!at.isAfter(current)) continue;
      final index = (ordinal + (slot == 2 ? 1 : 0)) % deck.length;
      requests.add(
        NotificationRequest(
          id: 4000 + d * 3 + slot,
          time: at,
          zone: zone,
          title: ar
              ? (isHadith ? 'حديث يضيء يومك' : 'ذكر يطمئن قلبك')
              : (isHadith ? 'A hadith for your day' : 'A moment of dhikr'),
          body: deck[index],
        ),
      );
    }
  }
  return requests;
}
