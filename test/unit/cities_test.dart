import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  final cities = loadBundledCities();

  test('includes every city the spec requires', () {
    const required = [
      'jerusalem', 'gaza', 'nablus', 'ramallah', 'hebron', 'jenin', 'tulkarm',
      'qalqilya', 'bethlehem', 'jericho', 'rafah', 'khan_yunis', 'deir_al_balah',
    ];
    final ids = cities.map((c) => c.id).toSet();
    for (final id in required) {
      expect(ids, contains(id));
    }
  });

  test('ids are unique', () {
    final ids = cities.map((c) => c.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('coordinates lie within historic Palestine', () {
    for (final c in cities) {
      expect(c.coordinates.latitude, inInclusiveRange(29.4, 33.4), reason: c.id);
      expect(c.coordinates.longitude, inInclusiveRange(34.2, 35.9), reason: c.id);
    }
  });

  test('timezones exist in the bundled tz database', () {
    for (final c in cities) {
      expect(() => tz.getLocation(c.timezone), returnsNormally, reason: c.id);
    }
  });

  test('every city has Arabic and English names and a region', () {
    for (final c in cities) {
      expect(c.nameAr, isNotEmpty);
      expect(c.nameEn, isNotEmpty);
      expect(['west_bank', 'gaza_strip', 'interior'], contains(c.region));
    }
  });
}
