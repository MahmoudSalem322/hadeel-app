import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hadeel/core/providers/core_providers.dart';
import 'package:hadeel/core/routing/routes.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/data/local/preferences_store.dart';
import 'package:hadeel/domain/entities/library.dart';
import 'package:hadeel/domain/entities/quran.dart';
import 'package:hadeel/features/quran/providers/quran_providers.dart';
import 'package:hadeel/features/quran/widgets/quran_style.dart';
import 'package:hadeel/features/settings/providers/settings_provider.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  final meta = loadQuranMeta();
  final reading = loadQuranReadingText();
  final search = loadQuranSearchText();

  Future<ProviderContainer> start(
    WidgetTester tester, {
    Map<String, Object> prefs = const {},
  }) {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10));
    return pumpHadeelApp(
      tester,
      clock: clock,
      prefs: {...onboardedWithCity('jerusalem'), ...prefs},
    );
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  void go(WidgetTester tester, String location) {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).push(location);
  }

  testWidgets('Quran tab lists surahs, juz and an empty favorites tab', (
    tester,
  ) async {
    await start(tester);
    await openTab(tester, 'القرآن');

    expect(find.text('القرآن الكريم'), findsOneWidget);
    expect(find.text(meta.surah(1).nameAr), findsOneWidget);
    expect(find.text(meta.surah(2).nameAr), findsOneWidget);
    expect(find.textContaining('مكية'), findsWidgets);

    await tester.tap(find.text('الأجزاء'));
    await tester.pumpAndSettle();
    expect(find.text('الجزء 1'), findsOneWidget);

    await tester.tap(find.text('المفضلة'));
    await tester.pumpAndSettle();
    expect(find.text('لا توجد آيات محفوظة'), findsOneWidget);
  });

  testWidgets('reader shows the source text of every ayah in order', (
    tester,
  ) async {
    await start(tester);
    go(tester, Routes.surah(1));
    await tester.pumpAndSettle();

    expect(
      find.text('سورة ${meta.surah(1).nameAr}'),
      findsWidgets,
    ); // app bar + header
    for (var a = 1; a <= 4; a++) {
      expect(
        find.text(reading.ayah(AyahRef(1, a))),
        findsOneWidget,
        reason: 'ayah $a',
      );
    }
    // Al-Fatiha has no separate Basmala header; its first ayah is the Basmala.
    expect(find.text(reading.bismillah!), findsOneWidget);
  });

  testWidgets('other surahs show the Basmala header, except At-Tawbah', (
    tester,
  ) async {
    await start(tester);
    go(tester, Routes.surah(112));
    await tester.pumpAndSettle();
    expect(find.text(reading.bismillah!), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    go(tester, Routes.surah(9));
    await tester.pumpAndSettle();
    expect(find.text(reading.bismillah!), findsNothing);
  });

  testWidgets('bookmark and favorite an ayah from its action sheet', (
    tester,
  ) async {
    final container = await start(tester);
    go(tester, Routes.surah(112));
    await tester.pumpAndSettle();

    await tester.tap(find.text(reading.ayah(const AyahRef(112, 2))));
    await tester.pumpAndSettle();
    expect(find.text('${meta.surah(112).nameAr} · آية 2'), findsOneWidget);

    await tester.tap(find.text('علامة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('المفضلة'));
    await tester.pumpAndSettle();

    expect(container.read(bookmarkedRefsProvider), {const AyahRef(112, 2)});
    expect(container.read(favoriteAyahRefsProvider), {const AyahRef(112, 2)});
    expect(find.text('أضيفت إلى المفضلة'), findsOneWidget);
  });

  testWidgets('bookmarks have a separate tab with the saved date and time', (
    tester,
  ) async {
    final container = await start(tester);
    await container
        .read(libraryRepositoryProvider)
        .toggleBookmark(const AyahRef(112, 2));
    await openTab(tester, 'القرآن');

    await tester.tap(find.text('العلامات'));
    await tester.pumpAndSettle();

    expect(find.text('الإخلاص · آية 2'), findsOneWidget);
    expect(find.textContaining('26 سبتمبر 2026'), findsOneWidget);
    expect(find.textContaining('10:00 ص'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_rounded), findsWidgets);
  });

  testWidgets('reading position is saved and offered on Home', (tester) async {
    final container = await start(tester);
    go(tester, Routes.surah(2, ayah: 45));
    await tester.pumpAndSettle();
    // The recorder debounces writes.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Home is paused while covered by the reader (Riverpod 3 pauses hidden
    // listeners); it catches up as soon as it is visible again.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    final saved = container.read(lastReadingPositionProvider).value;
    expect(saved!.ref.surah, 2);
    expect(saved.ref.ayah, inInclusiveRange(44, 46));
    expect(find.text('متابعة القراءة'), findsOneWidget);
    expect(
      find.textContaining('سورة ${meta.surah(2).nameAr} · آية'),
      findsOneWidget,
    );
  });

  testWidgets('search finds an ayah and opens it', (tester) async {
    await start(tester);
    go(tester, Routes.quranSearch);
    await tester.pumpAndSettle();

    final word = search
        .ayah(const AyahRef(2, 255))
        .split(' ')
        .reduce((a, b) => b.length > a.length ? b : a);
    await tester.enterText(find.byType(TextField), word);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    final label = '${meta.surah(2).nameAr} · آية 255';
    await tester.scrollUntilVisible(
      find.text(label),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    expect(find.text('سورة ${meta.surah(2).nameAr}'), findsOneWidget);
    expect(find.text(reading.ayah(const AyahRef(2, 255))), findsOneWidget);
  });

  testWidgets('search explains short queries and empty results', (
    tester,
  ) async {
    await start(tester);
    go(tester, Routes.quranSearch);
    await tester.pumpAndSettle();
    expect(find.text('اكتب حرفين على الأقل للبحث'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('لا توجد نتائج مطابقة'), findsOneWidget);
  });

  testWidgets('continuous mode renders inline ayah markers', (tester) async {
    await start(tester, prefs: {PreferencesStore.keyQuranMode: 'continuous'});
    go(tester, Routes.surah(112));
    await tester.pumpAndSettle();

    final paragraph = tester
        .widgetList<RichText>(find.byType(RichText))
        .map((r) => r.text.toPlainText())
        .firstWhere((t) => t.contains(ayahEndMarker(1)));
    expect(paragraph, contains(reading.ayah(const AyahRef(112, 1))));
    expect(paragraph, contains(ayahEndMarker(4)));
  });

  testWidgets('reading settings change the font size live', (tester) async {
    final container = await start(tester);
    go(tester, Routes.surah(1));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('إعدادات القراءة'));
    await tester.pumpAndSettle();
    expect(find.text('حجم الخط'), findsOneWidget);

    final before = container.read(settingsProvider).quran.fontSize;
    await tester.drag(
      find.byType(Slider).first,
      const Offset(-200, 0),
    ); // RTL: left = larger
    await tester.pumpAndSettle();
    expect(container.read(settingsProvider).quran.fontSize, isNot(before));
  });

  for (final dark in [false, true]) {
    testWidgets(
      'Quran screens fit 320 px at 200% text (${dark ? 'dark' : 'light'})',
      (tester) async {
        setSurface(tester, const Size(320, 640), textScale: 2);
        await start(
          tester,
          prefs: {PreferencesStore.keyThemeMode: dark ? 'dark' : 'light'},
        );
        await openTab(tester, 'القرآن');
        expect(tester.takeException(), isNull);

        go(tester, Routes.surah(2));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -1500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }

  test('reading progress provider derives the overall fraction', () {
    final container = ProviderContainer(
      overrides: [
        quranMetaProvider.overrideWithValue(meta),
        lastReadingPositionProvider.overrideWithValue(
          AsyncData(
            ReadingPosition(
              ref: const AyahRef(114, 6),
              updatedAt: DateTime.utc(2026),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final p = container.read(readingProgressProvider)!;
    expect(p.fraction, 1);
    expect(p.surahName, meta.surah(114).nameAr);
  });
}
