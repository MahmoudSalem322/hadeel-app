import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hadeel/core/providers/content_providers.dart';
import 'package:hadeel/core/routing/routes.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/data/local/preferences_store.dart';
import 'package:hadeel/domain/entities/library.dart';
import 'package:hadeel/domain/entities/quran.dart';
import 'package:hadeel/features/adhkar/providers/adhkar_providers.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  final hisn = loadHisnLibrary();
  final reading = loadQuranReadingText();
  final tafsir = loadTafsirText();
  final hadith = loadHadithLibrary();

  Future<ProviderContainer> start(WidgetTester tester, {Map<String, Object> prefs = const {}}) =>
      pumpHadeelApp(
        tester,
        clock: ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10)),
        prefs: {...onboardedWithCity('jerusalem'), ...prefs},
      );

  void go(WidgetTester tester, String location) =>
      GoRouter.of(tester.element(find.byType(Scaffold).first)).push(location);

  group('tafsir', () {
    testWidgets('opens from the ayah actions with the source text', (tester) async {
      await start(tester);
      go(tester, Routes.surah(112));
      await tester.pumpAndSettle();
      await tester.tap(find.text(reading.ayah(const AyahRef(112, 1))));
      await tester.pumpAndSettle();
      await tester.tap(find.text('التفسير'));
      await tester.pumpAndSettle();

      expect(find.text('التفسير الميسر'), findsOneWidget);
      expect(find.text(tafsir.ayah(const AyahRef(112, 1))), findsOneWidget);
    });

    testWidgets('can be shown inline under each ayah', (tester) async {
      await start(tester, prefs: {PreferencesStore.keyQuranShowTafsir: true});
      go(tester, Routes.surah(112));
      await tester.pumpAndSettle();
      expect(find.text(tafsir.ayah(const AyahRef(112, 2))), findsOneWidget);
    });
  });

  group('adhkar', () {
    testWidgets('tab shows daily categories and all Hisn chapters', (tester) async {
      await start(tester);
      await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('الأذكار')));
      await tester.pumpAndSettle();
      expect(find.text('أذكار الصباح والمساء'), findsWidgets);
      expect(find.text('أذكار النوم'), findsWidgets);
      await tester.scrollUntilVisible(find.text('جميع أبواب حصن المسلم'), 300, scrollable: find.byType(Scrollable).last);
      expect(find.text('جميع أبواب حصن المسلم'), findsOneWidget);
    });

    testWidgets('reader counts repetitions and advances to the next dhikr', (tester) async {
      final container = await start(tester);
      go(tester, Routes.azkarOf('morning_evening'));
      await tester.pumpAndSettle();

      final items = hisn.itemsOf(hisn.adhkarCategory('morning_evening')!);
      expect(find.text(items[0].text), findsOneWidget);
      expect(find.text('1 / ${items.length}'), findsOneWidget);

      final button = find.bySemanticsLabel(RegExp('^تسبيح'));
      for (var i = 0; i < items[0].repeat; i++) {
        await tester.tap(button);
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(find.text('2 / ${items.length}'), findsOneWidget);
      expect(container.read(adhkarSessionProvider('morning_evening')).value!.counter.index, 1);
    });

    testWidgets('a single chapter opens by id', (tester) async {
      await start(tester);
      final chapter = hisn.chapters.firstWhere((c) => c.items.length == 1);
      go(tester, Routes.azkarOf('c${chapter.id}'));
      await tester.pumpAndSettle();
      expect(find.text(chapter.title), findsOneWidget);
      expect(find.text(chapter.items.single.text), findsOneWidget);
    });
  });

  group('duas', () {
    testWidgets('categories list and Quranic duas render from the mushaf text', (tester) async {
      await start(tester);
      go(tester, Routes.duas);
      await tester.pumpAndSettle();
      expect(find.text('أدعية قرآنية'), findsOneWidget);
      expect(find.text('أدعية الأنبياء'), findsOneWidget);

      await tester.tap(find.text('أدعية قرآنية'));
      await tester.pumpAndSettle();
      final first = hisn.duaCategory('quranic')!.quranDuas.first;
      expect(find.textContaining(reading.ayah(first.from)), findsOneWidget);
    });

    testWidgets('favoriting a dua stores it', (tester) async {
      final container = await start(tester);
      go(tester, Routes.duasOf('rizq'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('المفضلة').first);
      await tester.pumpAndSettle();
      final item = hisn.itemsOf(hisn.duaCategory('rizq')!).first;
      expect(container.read(favoriteKeysProvider(FavoriteKind.dua)), contains(item.key));
    });
  });

  group('hadith', () {
    testWidgets('books → list → detail', (tester) async {
      await start(tester);
      go(tester, Routes.hadith);
      await tester.pumpAndSettle();
      final nawawi = hadith.book('nawawi40')!;
      expect(find.text(nawawi.title), findsOneWidget);

      await tester.tap(find.text(nawawi.title));
      await tester.pumpAndSettle();
      await tester.tap(find.text(nawawi.hadiths.first.text));
      await tester.pumpAndSettle();

      expect(find.text('الحديث 1'), findsWidgets);
      expect(find.text(nawawi.hadiths.first.text), findsOneWidget);
      await tester.scrollUntilVisible(find.byTooltip('مشاركة'), 300, scrollable: find.byType(Scrollable).last);
      expect(find.byTooltip('مشاركة'), findsOneWidget);
    });

    testWidgets('Riyad as-Salihin can be filtered by book', (tester) async {
      await start(tester);
      final riyad = hadith.book('riyad')!;
      go(tester, Routes.hadithBook('riyad'));
      await tester.pumpAndSettle();
      final second = riyad.chapters[1];
      await tester.tap(find.text(second.title));
      await tester.pumpAndSettle();
      final firstInChapter = riyad.hadiths.firstWhere((h) => h.chapterId == second.id);
      expect(find.text(firstInChapter.text), findsOneWidget);
    });
  });
}
