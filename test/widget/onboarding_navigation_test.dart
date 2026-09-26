import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/features/settings/providers/settings_provider.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  testWidgets('first launch: splash → onboarding → choose city → home', (tester) async {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10));
    final container = await pumpHadeelApp(tester, clock: clock, skipSplash: false);

    // Splash brand moment.
    expect(find.text('هديل'), findsOneWidget);
    expect(find.text('رفيقك اليومي للقرآن والذكر'), findsOneWidget);
    await advance(tester, clock, const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // The user's exact onboarding copy, in order.
    expect(find.text('أهلًا بك في هديل'), findsOneWidget);
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('القرآن معك دائمًا'), findsOneWidget);
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('صلاتك في وقتها'), findsOneWidget);
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('ابدأ رحلتك'), findsOneWidget);

    await tester.ensureVisible(find.text('اختر المدينة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('اختر المدينة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('نابلس'));
    await tester.pumpAndSettle();
    expect(find.text('المدينة: نابلس'), findsOneWidget);

    await tester.tap(find.text('ابدأ الآن'));
    await tester.pumpAndSettle();

    expect(find.text('السلام عليكم'), findsOneWidget);
    expect(container.read(settingsProvider).onboardingDone, isTrue);
  });

  testWidgets('skip jumps to the last onboarding page', (tester) async {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10));
    await pumpHadeelApp(tester, clock: clock);

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();
    expect(find.text('ابدأ رحلتك'), findsOneWidget);
    expect(find.text('ابدأ الآن'), findsOneWidget);
  });

  testWidgets('returning user goes straight to home', (tester) async {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10));
    await pumpHadeelApp(tester, clock: clock, prefs: onboardedWithCity('hebron'));
    expect(find.text('السلام عليكم'), findsOneWidget);
    expect(find.text('أهلًا بك في هديل'), findsNothing);
  });

  testWidgets('bottom navigation switches tabs and keeps each tab state', (tester) async {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10));
    await pumpHadeelApp(tester, clock: clock, prefs: onboardedWithCity('jerusalem'));

    final nav = find.byType(NavigationBar);
    expect(nav, findsOneWidget);

    await tester.tap(find.descendant(of: nav, matching: find.text('القرآن')));
    await tester.pumpAndSettle();
    expect(find.text('القرآن الكريم'), findsOneWidget);

    await tester.tap(find.descendant(of: nav, matching: find.text('المزيد')));
    await tester.pumpAndSettle();
    expect(find.text('القبلة'), findsOneWidget);
    expect(find.text('المصادر'), findsOneWidget);

    await tester.tap(find.descendant(of: nav, matching: find.text('الرئيسية')));
    await tester.pumpAndSettle();
    expect(find.text('السلام عليكم'), findsOneWidget);
  });

  testWidgets('quick action opens a full-screen section with a back button', (tester) async {
    final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10));
    await pumpHadeelApp(tester, clock: clock, prefs: onboardedWithCity('jerusalem'));

    await tester.scrollUntilVisible(find.text('التسبيح'), 200);
    await tester.tap(find.text('التسبيح'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('قريبًا بإذن الله'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    // Back on Home, still scrolled where the user left it.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('التسبيح'), findsOneWidget);
  });
}
