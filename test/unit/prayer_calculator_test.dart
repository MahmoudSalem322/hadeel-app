import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/domain/entities/city.dart';
import 'package:hadeel/domain/entities/geo.dart';
import 'package:hadeel/domain/entities/location_selection.dart';
import 'package:hadeel/domain/entities/prayer.dart';
import 'package:hadeel/domain/entities/prayer_settings.dart';
import 'package:hadeel/services/prayer/adhan_prayer_calculator.dart';

import '../helpers/test_harness.dart';

void main() {
  const calculator = AdhanPrayerCalculator();
  late Map<String, City> cities;

  setUpAll(() async {
    await initTestEnvironment();
    cities = {for (final c in loadBundledCities()) c.id: c};
  });

  ResolvedLocation at(String id) {
    final c = cities[id]!;
    return ResolvedLocation(coordinates: c.coordinates, timezone: c.timezone, city: c);
  }

  int minutesOf(DateTime t) => t.hour * 60 + t.minute;
  int minutesOfHm(String hm) {
    final parts = hm.split(':').map(int.parse).toList();
    return parts[0] * 60 + parts[1];
  }

  group('matches the independent Aladhan reference (Egyptian, Shafi)', () {
    final fixture = jsonDecode(File('test/fixtures/prayer_reference.json').readAsStringSync())
        as Map<String, dynamic>;
    final cases = (fixture['cases'] as List<dynamic>).cast<Map<String, dynamic>>();

    for (final c in cases) {
      test('${c['city']} on ${c['date']}', () {
        final d = DateTime.parse(c['date'] as String);
        final day = calculator.compute(
          date: CalendarDate(d.year, d.month, d.day),
          location: at(c['city'] as String),
          settings: PrayerSettings.defaults,
        );
        for (final p in Prayer.values) {
          final actual = minutesOf(day.timeOf(p));
          final expected = minutesOfHm(c[p.name] as String);
          // Different engines round differently and adhan adds +1 min to
          // Dhuhr as a safety margin, so allow ±2 minutes.
          expect(
            (actual - expected).abs(),
            lessThanOrEqualTo(2),
            reason: '${p.name}: got ${day.timeOf(p)}, reference ${c[p.name]}',
          );
        }
      });
    }
  });

  test('times are strictly increasing through the day', () {
    for (final id in ['jerusalem', 'gaza', 'jenin', 'rafah', 'haifa']) {
      for (var m = 1; m <= 12; m++) {
        final day = calculator.compute(
          date: CalendarDate(2026, m, 15),
          location: at(id),
          settings: PrayerSettings.defaults,
        );
        final times = day.entries.map((e) => e.value).toList();
        for (var i = 1; i < times.length; i++) {
          expect(times[i].isAfter(times[i - 1]), isTrue, reason: '$id month $m index $i');
        }
      }
    }
  });

  test('Hanafi Asr is later than Shafi Asr', () {
    const date = CalendarDate(2026, 9, 26);
    final shafi = calculator.compute(date: date, location: at('nablus'), settings: PrayerSettings.defaults);
    final hanafi = calculator.compute(
      date: date,
      location: at('nablus'),
      settings: const PrayerSettings(madhab: AsrMadhab.hanafi),
    );
    expect(hanafi.timeOf(Prayer.asr).isAfter(shafi.timeOf(Prayer.asr)), isTrue);
    expect(hanafi.timeOf(Prayer.dhuhr), shafi.timeOf(Prayer.dhuhr));
  });

  test('uses the location zone, including Palestinian DST on 28 March 2026', () {
    final before = calculator.compute(
      date: const CalendarDate(2026, 3, 27),
      location: at('ramallah'),
      settings: PrayerSettings.defaults,
    );
    final after = calculator.compute(
      date: const CalendarDate(2026, 3, 28),
      location: at('ramallah'),
      settings: PrayerSettings.defaults,
    );
    expect(before.timeOf(Prayer.dhuhr).timeZoneOffset, const Duration(hours: 2));
    expect(after.timeOf(Prayer.dhuhr).timeZoneOffset, const Duration(hours: 3));
    // Wall-clock Dhuhr jumps by about an hour across the transition.
    expect(minutesOf(after.timeOf(Prayer.dhuhr)) - minutesOf(before.timeOf(Prayer.dhuhr)), inInclusiveRange(59, 61));
  });

  test('changing the method changes Fajr and Isha only', () {
    const date = CalendarDate(2026, 6, 21);
    final egyptian = calculator.compute(date: date, location: at('hebron'), settings: PrayerSettings.defaults);
    final mwl = calculator.compute(
      date: date,
      location: at('hebron'),
      settings: const PrayerSettings(method: CalculationMethodType.muslimWorldLeague),
    );
    expect(mwl.timeOf(Prayer.fajr).isAfter(egyptian.timeOf(Prayer.fajr)), isTrue); // 18° < 19.5°
    expect(mwl.timeOf(Prayer.maghrib), egyptian.timeOf(Prayer.maghrib));
  });

  test('dateIn resolves the calendar day in the given zone', () {
    // 22:30 UTC on 26 Sep is already 27 Sep in Palestine (UTC+3).
    final instant = DateTime.utc(2026, 9, 26, 22, 30);
    expect(calculator.dateIn('Asia/Hebron', instant), const CalendarDate(2026, 9, 27));
    expect(calculator.dateIn('UTC', instant), const CalendarDate(2026, 9, 26));
  });

  test('every bundled method computes without error', () {
    for (final method in CalculationMethodType.values) {
      final day = calculator.compute(
        date: const CalendarDate(2026, 12, 21),
        location: at('jerusalem'),
        settings: PrayerSettings(method: method),
      );
      expect(day.timeOf(Prayer.isha).isAfter(day.timeOf(Prayer.maghrib)), isTrue, reason: method.name);
    }
  });
}
