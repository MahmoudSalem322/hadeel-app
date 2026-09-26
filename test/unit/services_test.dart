import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/data/repositories/settings_repository_impl.dart';
import 'package:hadeel/domain/entities/app_settings.dart';
import 'package:hadeel/domain/entities/geo.dart';
import 'package:hadeel/domain/entities/hijri_date.dart';
import 'package:hadeel/domain/entities/location_selection.dart';
import 'package:hadeel/domain/entities/prayer.dart';
import 'package:hadeel/domain/entities/prayer_settings.dart';
import 'package:hadeel/domain/entities/quran_reading_settings.dart';
import 'package:hadeel/domain/usecases/plan_prayer_notifications.dart';
import 'package:hadeel/domain/usecases/qibla.dart';
import 'package:hadeel/domain/usecases/search_content.dart';
import 'package:hadeel/features/home/providers/daily_content_provider.dart';
import 'package:hadeel/services/hijri/hijri_converter.dart';
import 'package:hadeel/services/prayer/adhan_prayer_calculator.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  group('qibla', () {
    for (final id in ['jerusalem', 'gaza', 'jenin', 'haifa']) {
      test('bearing from $id matches the Adhan library', () {
        final city = loadBundledCities().firstWhere((c) => c.id == id);
        final ours = qiblaBearing(city.coordinates);
        final reference =
            adhan.Qibla(adhan.Coordinates(city.coordinates.latitude, city.coordinates.longitude)).direction;
        expect(ours, closeTo(reference, 0.5));
        // Palestine lies north-west of Makkah, so the qibla is to the south-east.
        expect(ours, inInclusiveRange(140, 170));
      });
    }

    test('distance from Jerusalem is about 1,230 km', () {
      final km = distanceToKaabaKm(const GeoCoordinates(31.778, 35.2354));
      expect(km, inInclusiveRange(1180, 1280));
      expect(distanceToKaabaKm(kaaba), closeTo(0, 0.001));
    });

    test('turn direction takes the short way round', () {
      expect(turnToQibla(heading: 150, bearing: 157), closeTo(7, 1e-9));
      expect(turnToQibla(heading: 170, bearing: 157), closeTo(-13, 1e-9));
      expect(turnToQibla(heading: 350, bearing: 10), closeTo(20, 1e-9));
      expect(turnToQibla(heading: 10, bearing: 350), closeTo(-20, 1e-9));
    });
  });

  group('prayer notification planning', () {
    final city = loadBundledCities().firstWhere((c) => c.id == 'nablus');
    final location = ResolvedLocation(coordinates: city.coordinates, timezone: city.timezone, city: city);
    const calculator = AdhanPrayerCalculator();

    test('schedules only enabled, future prayers across the window', () {
      final now = zoned('Asia/Hebron', 2026, 9, 26, 14); // after Dhuhr, before Maghrib
      final planned = planPrayerNotifications(
        now: now,
        location: location,
        settings: PrayerSettings.defaults,
        enabled: {Prayer.fajr, Prayer.maghrib},
        calculator: calculator,
        days: 5,
      );
      // Today's Fajr is past → 1 (Maghrib today) + 4 days × 2.
      expect(planned.length, 9);
      expect(planned.every((p) => p.time.isAfter(now)), isTrue);
      expect(planned.map((p) => p.prayer).toSet(), {Prayer.fajr, Prayer.maghrib});
      expect(planned.map((p) => p.id).toSet().length, planned.length, reason: 'ids are unique');
      for (var i = 1; i < planned.length; i++) {
        expect(planned[i].time.isAfter(planned[i - 1].time), isTrue);
      }
    });

    test('nothing enabled means nothing scheduled', () {
      expect(
        planPrayerNotifications(
          now: DateTime.utc(2026, 9, 26),
          location: location,
          settings: PrayerSettings.defaults,
          enabled: const {},
          calculator: calculator,
        ),
        isEmpty,
      );
    });

    test('stays under the iOS limit of 64 pending notifications', () {
      final planned = planPrayerNotifications(
        now: zoned('Asia/Hebron', 2026, 9, 26, 0, 1),
        location: location,
        settings: PrayerSettings.defaults,
        enabled: Prayer.obligatory.toSet(),
        calculator: calculator,
      );
      expect(planned.length, lessThanOrEqualTo(64));
      expect(planned.length, 25);
    });
  });

  group('Hijri calendar', () {
    const converter = HijriConverter();

    test('Gregorian ↔ Hijri round trip', () {
      for (final d in [const CalendarDate(2026, 9, 26), const CalendarDate(2025, 6, 26), const CalendarDate(2027, 3, 1)]) {
        expect(converter.toGregorian(converter.fromGregorian(d)), d);
      }
      expect(converter.toGregorian(const HijriDate(1447, 1, 1)), const CalendarDate(2025, 6, 26));
    });

    test('adjustment shifts both directions consistently', () {
      const plus = HijriConverter(dayAdjustment: 1);
      const d = CalendarDate(2026, 9, 26);
      expect(plus.toGregorian(plus.fromGregorian(d)), d);
    });

    test('months are 29 or 30 days and shifting wraps years', () {
      for (var m = 1; m <= 12; m++) {
        expect(converter.monthLength(1448, m), inInclusiveRange(29, 30));
      }
      expect(HijriConverter.shiftMonth(1447, 12, 1), (1448, 1));
      expect(HijriConverter.shiftMonth(1448, 1, -1), (1447, 12));
    });
  });

  group('content search', () {
    final index = ContentSearchIndex(loadHisnLibrary(), loadHadithLibrary());

    test('finds adhkar and hadith by a word from their own text', () {
      final dhikr = loadHisnLibrary().chapters.first.items.first;
      final word = dhikr.text.split(' ').reduce((a, b) => b.length > a.length ? b : a);
      expect(index.search(word, limit: 1000).adhkar.map((h) => h.item), contains(dhikr));

      final hadith = loadHadithLibrary().book('nawawi40')!.hadiths[5];
      final hWord = hadith.text.split(' ').reduce((a, b) => b.length > a.length ? b : a);
      expect(index.search(hWord, limit: 5000).hadith.map((h) => h.item), contains(hadith));
    });

    test('excerpt keeps the match and shifts its range', () {
      final text = '${List.filled(40, 'كلمة').join(' ')} المطلوب ${List.filled(40, 'نص').join(' ')}';
      final start = text.indexOf('المطلوب');
      final (excerpt, ranges) = excerptAround(text, [(start, start + 7)], context: 30);
      expect(excerpt.length, lessThan(text.length));
      expect(excerpt.substring(ranges.first.$1, ranges.first.$2), 'المطلوب');
    });
  });

  test('daily index is stable within a day and changes the next day', () {
    const d = CalendarDate(2026, 9, 26);
    expect(dailyIndex(d, 42), dailyIndex(d, 42));
    expect(dailyIndex(d.addDays(1), 42), (dailyIndex(d, 42) + 1) % 42);
    expect(dailyIndex(d, 42, salt: 1), isNot(dailyIndex(d, 42)));
  });

  test('new settings persist: language, notifications, tasbeeh, hijri, tafsir', () async {
    final store = await openTestStore();
    final repo = SettingsRepositoryImpl(store);
    await repo.saveLanguage('en');
    await repo.saveNotificationSettings(const NotificationSettings(enabled: {Prayer.fajr, Prayer.isha}));
    await repo.saveTasbeehSettings(const TasbeehSettings(vibration: false, sound: true, phraseKey: 'istighfar'));
    await repo.saveHijriAdjustment(-1);
    await repo.saveQuranSettings(const QuranReadingSettings(showTafsir: true));

    final s = SettingsRepositoryImpl(store).load();
    expect(s.languageCode, 'en');
    expect(s.notifications.enabled, {Prayer.fajr, Prayer.isha});
    expect(s.tasbeeh, const TasbeehSettings(vibration: false, sound: true, phraseKey: 'istighfar'));
    expect(s.hijriAdjustment, -1);
    expect(s.quran.showTafsir, isTrue);
  });
}
