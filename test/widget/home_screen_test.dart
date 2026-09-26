import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/errors/failures.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/core/utils/formatters.dart';
import 'package:hadeel/data/local/preferences_store.dart';
import 'package:hadeel/domain/entities/geo.dart';
import 'package:hadeel/domain/entities/location_selection.dart';
import 'package:hadeel/domain/entities/prayer.dart';
import 'package:hadeel/domain/entities/prayer_settings.dart';
import 'package:hadeel/features/prayer/providers/prayer_providers.dart';
import 'package:hadeel/services/prayer/adhan_prayer_calculator.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  DateTime asrInJerusalem() {
    final jerusalem = loadBundledCities().firstWhere((c) => c.id == 'jerusalem');
    return const AdhanPrayerCalculator()
        .compute(
          date: const CalendarDate(2026, 9, 26),
          location: ResolvedLocation(
            coordinates: jerusalem.coordinates,
            timezone: jerusalem.timezone,
            city: jerusalem,
          ),
          settings: PrayerSettings.defaults,
        )
        .timeOf(Prayer.asr);
  }

  testWidgets('shows greeting, next prayer and a live countdown', (tester) async {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 14));
    await pumpHadeelApp(tester, clock: clock, prefs: onboardedWithCity('jerusalem'));

    expect(find.text('السلام عليكم'), findsOneWidget);
    expect(find.text('الصلاة القادمة'), findsOneWidget);
    expect(find.text('العصر'), findsWidgets);
    expect(find.textContaining('ربيع'), findsOneWidget); // Hijri month (Rabi' al-Akhir 1448)

    final f = AppFormatters('ar');
    final asr = asrInJerusalem();
    expect(find.text(f.countdown(asr.difference(clock.now()))), findsOneWidget);

    await advance(tester, clock, const Duration(seconds: 1));
    expect(find.text(f.countdown(asr.difference(clock.now()))), findsOneWidget);
  });

  testWidgets('switches to the following prayer when the countdown ends', (tester) async {
    final asr = asrInJerusalem();
    // The harness spends 1 s on the splash, leaving 2 s before Asr.
    final clock = ManualClock(asr.subtract(const Duration(seconds: 3)));
    final container = await pumpHadeelApp(tester, clock: clock, prefs: onboardedWithCity('jerusalem'));
    expect(container.read(nextPrayerProvider)!.prayer, Prayer.asr);

    await advance(tester, clock, const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 500));
    expect(container.read(nextPrayerProvider)!.prayer, Prayer.maghrib);
    expect(find.text('المغرب'), findsWidgets);
  });

  testWidgets('without a location, offers manual city selection', (tester) async {
    final clock = ManualClock(zoned('Asia/Gaza', 2026, 9, 26, 9));
    final container = await pumpHadeelApp(
      tester,
      clock: clock,
      prefs: {PreferencesStore.keyOnboardingDone: true},
    );

    expect(find.text('حدّد موقعك'), findsOneWidget);
    await tester.tap(find.text('اختر المدينة'));
    await tester.pumpAndSettle();

    expect(find.text('اختر مدينتك'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'غزه'); // taa marbuta normalized
    await tester.pumpAndSettle();
    await tester.tap(find.text('غزة'));
    await tester.pumpAndSettle();

    expect(container.read(resolvedLocationProvider)?.city?.id, 'gaza');
    expect(find.text('الصلاة القادمة'), findsOneWidget);
    expect(find.text('غزة'), findsOneWidget); // location chip on the card
  });

  testWidgets('denied GPS explains why and keeps the city picker available', (tester) async {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 9));
    final gps = FakeLocationService(const Err(LocationFailure.permissionDenied));
    await pumpHadeelApp(
      tester,
      clock: clock,
      prefs: {PreferencesStore.keyOnboardingDone: true},
      locationService: gps,
    );

    await tester.tap(find.text('استخدم موقعي'));
    await tester.pumpAndSettle();

    expect(gps.calls, 1);
    expect(find.textContaining('تعذر الحصول على الموقع'), findsOneWidget);
    expect(find.textContaining('لم يتم منح إذن الوصول إلى الموقع.'), findsOneWidget);
    expect(find.text('اختيار المدينة يدويًا'), findsOneWidget);
  });

  testWidgets('a GPS fix is saved with the device timezone', (tester) async {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 9));
    final container = await pumpHadeelApp(
      tester,
      clock: clock,
      prefs: {PreferencesStore.keyOnboardingDone: true},
      locationService: FakeLocationService(const Ok(GeoCoordinates(32.22, 35.25))),
    );

    await tester.tap(find.text('استخدم موقعي'));
    await tester.pumpAndSettle();

    final location = container.read(resolvedLocationProvider)!;
    expect(location.isGps, isTrue);
    expect(location.timezone, 'Asia/Hebron');
    expect(find.text('موقعي الحالي'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets('no overflow at 320 px with 200% text (${dark ? 'dark' : 'light'})', (tester) async {
      setSurface(tester, const Size(320, 640), textScale: 2);
      final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 14));
      await pumpHadeelApp(
        tester,
        clock: clock,
        prefs: {
          ...onboardedWithCity('deir_al_balah'),
          PreferencesStore.keyThemeMode: dark ? 'dark' : 'light',
        },
      );
      await tester.drag(find.byType(ListView).first, const Offset(0, -2000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
