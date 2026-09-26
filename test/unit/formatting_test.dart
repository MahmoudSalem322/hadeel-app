import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/utils/arabic_normalizer.dart';
import 'package:hadeel/core/utils/formatters.dart';
import 'package:hadeel/domain/entities/geo.dart';
import 'package:hadeel/domain/entities/hijri_date.dart';
import 'package:hadeel/services/hijri/hijri_converter.dart';
import 'package:timezone/timezone.dart' as tz;

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  group('AppFormatters', () {
    test('countdown pads to HH:MM:SS', () {
      final f = AppFormatters('ar');
      expect(f.countdown(const Duration(hours: 1, minutes: 24, seconds: 32)), '01:24:32');
      expect(f.countdown(const Duration(seconds: 5)), '00:00:05');
      expect(f.countdown(const Duration(hours: 13)), '13:00:00');
      expect(f.countdown(const Duration(seconds: -3)), '00:00:00');
    });

    test('formats a TZDateTime in its own zone, not the device zone', () {
      final f = AppFormatters('en');
      final t = tz.TZDateTime(tz.getLocation('Asia/Gaza'), 2026, 9, 26, 16, 15);
      expect(f.time(t), contains('4:15'));
      expect(f.time(t), contains('PM'));
    });

    test('Arabic time uses the Arabic day-period marker and Western digits', () {
      final t = tz.TZDateTime(tz.getLocation('Asia/Hebron'), 2026, 9, 26, 16, 15);
      final text = AppFormatters('ar').time(t);
      expect(text, contains('م'));
      expect(text, contains('4:15'));
    });

    test('Arabic dates and numbers share the same digits', () {
      final f = AppFormatters('ar');
      expect(f.gregorianDate(const CalendarDate(2026, 9, 26)), contains('2026'));
      expect(f.number(26), '26');
    });
  });

  group('HijriConverter (Umm al-Qura)', () {
    const converter = HijriConverter();

    test('1 Muharram 1447 = 26 June 2025', () {
      expect(converter.fromGregorian(const CalendarDate(2025, 6, 26)), const HijriDate(1447, 1, 1));
    });

    test('1 Ramadan 1445 = 11 March 2024', () {
      expect(converter.fromGregorian(const CalendarDate(2024, 3, 11)), const HijriDate(1445, 9, 1));
    });

    test('day adjustment shifts the result', () {
      const plusOne = HijriConverter(dayAdjustment: 1);
      expect(plusOne.fromGregorian(const CalendarDate(2025, 6, 25)), const HijriDate(1447, 1, 1));
    });
  });

  group('normalizeArabic', () {
    test('unifies alef forms, taa marbuta and alef maqsura', () {
      expect(normalizeArabic('أريحا'), normalizeArabic('اريحا'));
      expect(normalizeArabic('غزة'), 'غزه');
      expect(normalizeArabic('مصطفى'), 'مصطفي');
    });

    test('strips tashkeel and tatweel', () {
      expect(normalizeArabic('نَابُلُس'), 'نابلس');
      expect(normalizeArabic('القـدس'), 'القدس');
    });

    test('lower-cases Latin text', () {
      expect(normalizeArabic('  Gaza '), 'gaza');
    });
  });

  test('CalendarDate.addDays crosses month and year boundaries', () {
    expect(const CalendarDate(2026, 12, 31).addDays(1), const CalendarDate(2027, 1, 1));
    expect(const CalendarDate(2026, 3, 1).addDays(-1), const CalendarDate(2026, 2, 28));
  });
}
