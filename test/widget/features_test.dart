import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hadeel/core/providers/core_providers.dart';
import 'package:hadeel/core/routing/routes.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/data/local/preferences_store.dart';
import 'package:hadeel/domain/entities/library.dart';
import 'package:hadeel/domain/entities/prayer.dart';
import 'package:hadeel/domain/usecases/qibla.dart';
import 'package:hadeel/features/settings/providers/settings_provider.dart';
import 'package:hadeel/services/sensors/compass_service.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  Future<ProviderContainer> start(
    WidgetTester tester, {
    Map<String, Object> prefs = const {},
    FakeNotificationService? notifications,
    FakeCompassService? compass,
  }) =>
      pumpHadeelApp(
        tester,
        clock: ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 14)),
        prefs: {...onboardedWithCity('jerusalem'), ...prefs},
        notifications: notifications,
        compass: compass,
      );

  void go(WidgetTester tester, String location) =>
      GoRouter.of(tester.element(find.byType(Scaffold).first)).push(location);

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text(label)));
    await tester.pumpAndSettle();
  }

  group('prayer', () {
    testWidgets('tab shows the full timeline, location and method', (tester) async {
      await start(tester);
      await openTab(tester, 'الصلاة');
      for (final name in ['الفجر', 'الشروق', 'الظهر', 'العصر', 'المغرب', 'العشاء']) {
        expect(find.text(name), findsWidgets);
      }
      await tester.scrollUntilVisible(find.text('الهيئة المصرية العامة للمساحة'), 300,
          scrollable: find.byType(Scrollable).last);
      expect(find.text('الهيئة المصرية العامة للمساحة'), findsOneWidget);
    });

    testWidgets('bell enables a prayer notification and schedules it', (tester) async {
      final notifications = FakeNotificationService();
      final container = await start(tester, notifications: notifications);
      await openTab(tester, 'الصلاة');
      await tester.ensureVisible(find.byTooltip('تنبيه المغرب'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('تنبيه المغرب'));
      await tester.pumpAndSettle();

      expect(notifications.permissionRequests, 1);
      expect(container.read(settingsProvider).notifications.isOn(Prayer.maghrib), isTrue);
      expect(notifications.scheduled, isNotEmpty);
      expect(notifications.scheduled.every((r) => r.title == Prayer.maghrib), isTrue);
      expect(notifications.scheduled.first.title, contains('المغرب'));
    });

    testWidgets('denied permission leaves notifications off and explains', (tester) async {
      final notifications = FakeNotificationService(granted: false);
      final container = await start(tester, notifications: notifications);
      await openTab(tester, 'الصلاة');
      await tester.ensureVisible(find.byTooltip('تنبيه الفجر'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('تنبيه الفجر'));
      await tester.pumpAndSettle();
      expect(container.read(settingsProvider).notifications.isOn(Prayer.fajr), isFalse);
      expect(find.textContaining('الإشعارات غير مسموحة'), findsOneWidget);
    });

    testWidgets('changing the method recalculates times', (tester) async {
      final container = await start(tester);
      await openTab(tester, 'الصلاة');
      final before = container.read(settingsProvider).prayer.method;
      await tester.scrollUntilVisible(find.text('الهيئة المصرية العامة للمساحة'), 300,
          scrollable: find.byType(Scrollable).last);
      await tester.tap(find.text('الهيئة المصرية العامة للمساحة'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('رابطة العالم الإسلامي'));
      await tester.pumpAndSettle();
      expect(container.read(settingsProvider).prayer.method, isNot(before));
    });
  });

  group('qibla', () {
    testWidgets('guides the user with a live compass', (tester) async {
      final controller = StreamController<CompassReading>();
      addTearDown(controller.close);
      await start(tester, compass: FakeCompassService(controller.stream));
      go(tester, Routes.qibla);
      await tester.pumpAndSettle();

      final bearing = qiblaBearing(loadBundledCities().firstWhere((c) => c.id == 'jerusalem').coordinates);
      expect(find.text('${bearing.round()}° من الشمال'), findsOneWidget);

      controller.add(CompassReading(heading: bearing - 40));
      await tester.pumpAndSettle();
      expect(find.text('استدر يمينًا'), findsOneWidget);

      controller.add(CompassReading(heading: bearing + 1));
      await tester.pumpAndSettle();
      expect(find.text('أنت متجه نحو القبلة'), findsOneWidget);
    });

    testWidgets('explains when there is no compass sensor', (tester) async {
      await start(tester);
      go(tester, Routes.qibla);
      await tester.pumpAndSettle();
      expect(find.textContaining('لا يتوفر مستشعر بوصلة'), findsOneWidget);
    });
  });

  group('tasbeeh', () {
    testWidgets('counts, changes target and persists', (tester) async {
      final container = await start(tester);
      go(tester, Routes.tasbeeh);
      await tester.pumpAndSettle();
      expect(find.text('سبحان الله'), findsOneWidget);

      final button = find.bySemanticsLabel(RegExp('^اضغط للتسبيح'));
      for (var i = 0; i < 3; i++) {
        await tester.tap(button);
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      await tester.ensureVisible(find.text('99'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('99'));
      await tester.pumpAndSettle();
      expect(find.text('/ 99'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1)); // debounce → saved
      await tester.pumpAndSettle();
      final repo = container.read(libraryRepositoryProvider);
      final saved = await tester.runAsync(() => repo.loadTasbeeh('subhanallah'));
      expect(saved!.total, 3);
      expect(saved.target, 99);
    });

    testWidgets('switching dhikr keeps separate counters', (tester) async {
      await start(tester);
      go(tester, Routes.tasbeeh);
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel(RegExp('^اضغط للتسبيح')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('تغيير الذكر'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('الحمد لله'));
      await tester.pumpAndSettle();
      expect(find.text('الحمد لله'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });
  });

  testWidgets('Hijri calendar shows the month and navigates', (tester) async {
    await start(tester);
    go(tester, Routes.hijriCalendar);
    await tester.pumpAndSettle();
    expect(find.text('ربيع الآخر 1448 هـ'), findsOneWidget);
    await tester.tap(find.byTooltip('الشهر التالي'));
    await tester.pumpAndSettle();
    expect(find.text('جمادى الأولى 1448 هـ'), findsOneWidget);
    await tester.tap(find.text('اليوم'));
    await tester.pumpAndSettle();
    expect(find.text('ربيع الآخر 1448 هـ'), findsOneWidget);
  });

  testWidgets('favorites list saved adhkar', (tester) async {
    final container = await start(tester);
    final item = loadHisnLibrary().chapters.first.items.first;
    await tester.runAsync(() => container.read(libraryRepositoryProvider).toggleFavorite(FavoriteKind.dhikr, item.key));
    go(tester, Routes.favorites);
    await tester.pumpAndSettle();
    await tester.tap(find.text('الأذكار'));
    await tester.pumpAndSettle();
    expect(find.text(item.text), findsOneWidget);
  });

  testWidgets('global search groups Quran and content results', (tester) async {
    await start(tester);
    go(tester, Routes.search);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'الحمد');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.textContaining('القرآن الكريم ·'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('الأذكار ·'), 400, scrollable: find.byType(Scrollable).last);
    expect(find.textContaining('الأذكار ·'), findsOneWidget);
  });

  testWidgets('settings switch the app to English', (tester) async {
    await start(tester);
    go(tester, Routes.settings);
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Assalamu alaikum'), findsOneWidget);
  });

  testWidgets('home shows today\'s daily content', (tester) async {
    await start(tester);
    await tester.scrollUntilVisible(find.text('زاد اليوم'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('زاد اليوم'), findsOneWidget);
    expect(find.text('آية اليوم'), findsOneWidget);
  });

  for (final route in [
    Routes.qibla,
    Routes.tasbeeh,
    Routes.hijriCalendar,
    Routes.settings,
    Routes.favorites,
    Routes.duas,
    Routes.hadith,
    Routes.about,
    Routes.sources,
  ]) {
    testWidgets('$route fits 320 px at 200% text', (tester) async {
      setSurface(tester, const Size(320, 640), textScale: 2);
      await start(tester, prefs: {PreferencesStore.keyThemeMode: 'dark'});
      go(tester, route);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -1200));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}


