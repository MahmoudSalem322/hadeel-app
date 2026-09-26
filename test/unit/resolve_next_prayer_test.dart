import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/domain/entities/geo.dart';
import 'package:hadeel/domain/entities/next_prayer.dart';
import 'package:hadeel/domain/entities/prayer.dart';
import 'package:hadeel/domain/entities/prayer_day.dart';
import 'package:hadeel/domain/usecases/resolve_next_prayer.dart';

/// Synthetic, round-numbered days so the expectations are obvious.
PrayerDay _day(int d) {
  DateTime t(int h, [int m = 0]) => DateTime.utc(2026, 9, d, h, m);
  return PrayerDay(
    date: CalendarDate(2026, 9, d),
    times: {
      Prayer.fajr: t(4),
      Prayer.sunrise: t(5, 30),
      Prayer.dhuhr: t(12),
      Prayer.asr: t(15, 30),
      Prayer.maghrib: t(18),
      Prayer.isha: t(19, 30),
    },
  );
}

void main() {
  final yesterday = _day(25);
  final today = _day(26);
  final tomorrow = _day(27);

  NextPrayer resolve(DateTime now) =>
      resolveNextPrayer(now: now, yesterday: yesterday, today: today, tomorrow: tomorrow);

  test('before Fajr → Fajr, previous is yesterday Isha', () {
    final next = resolve(DateTime.utc(2026, 9, 26, 2));
    expect(next.prayer, Prayer.fajr);
    expect(next.time, today.timeOf(Prayer.fajr));
    expect(next.previousPrayer, Prayer.isha);
    expect(next.previousTime, yesterday.timeOf(Prayer.isha));
  });

  test('after Fajr skips Sunrise → Dhuhr', () {
    final next = resolve(DateTime.utc(2026, 9, 26, 5, 45));
    expect(next.prayer, Prayer.dhuhr);
    expect(next.previousPrayer, Prayer.fajr);
  });

  test('between Dhuhr and Asr → Asr', () {
    expect(resolve(DateTime.utc(2026, 9, 26, 13)).prayer, Prayer.asr);
  });

  test('after Isha → tomorrow Fajr', () {
    final next = resolve(DateTime.utc(2026, 9, 26, 23));
    expect(next.prayer, Prayer.fajr);
    expect(next.time, tomorrow.timeOf(Prayer.fajr));
    expect(next.previousTime, today.timeOf(Prayer.isha));
  });

  test('exactly at a prayer time moves on to the following prayer', () {
    final next = resolve(DateTime.utc(2026, 9, 26, 12));
    expect(next.prayer, Prayer.asr);
  });

  test('one second before a prayer still targets it', () {
    final next = resolve(DateTime.utc(2026, 9, 26, 11, 59, 59));
    expect(next.prayer, Prayer.dhuhr);
    expect(next.remaining(DateTime.utc(2026, 9, 26, 11, 59, 59)), const Duration(seconds: 1));
  });

  group('NextPrayer', () {
    final next = resolve(DateTime.utc(2026, 9, 26, 13));

    test('remaining is never negative', () {
      expect(next.remaining(DateTime.utc(2026, 9, 26, 16)), Duration.zero);
    });

    test('progress spans previous → next prayer', () {
      expect(next.progress(DateTime.utc(2026, 9, 26, 12)), 0);
      expect(next.progress(DateTime.utc(2026, 9, 26, 13, 45)), closeTo(0.5, 0.001));
      expect(next.progress(DateTime.utc(2026, 9, 26, 17)), 1);
    });

    test('hasArrived flips at the exact time', () {
      expect(next.hasArrived(DateTime.utc(2026, 9, 26, 15, 29, 59)), isFalse);
      expect(next.hasArrived(DateTime.utc(2026, 9, 26, 15, 30)), isTrue);
    });
  });
}
