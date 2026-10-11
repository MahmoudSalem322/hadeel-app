import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/shared/widgets/hadeel_logo.dart';
import 'package:hadeel/shared/widgets/liquid_glass.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  testWidgets('wide screens use a sidebar that navigates between sections', (
    tester,
  ) async {
    setSurface(tester, const Size(1200, 800));
    await pumpHadeelApp(
      tester,
      clock: ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10)),
      prefs: onboardedWithCity('jerusalem'),
    );

    final sidebar = find.byKey(const ValueKey('app-sidebar'));
    expect(sidebar, findsOneWidget);
    expect(
      find.descendant(of: sidebar, matching: find.byType(HadeelLogo)),
      findsOneWidget,
    );
    expect(find.byType(NavigationBar), findsNothing);
    expect(
      find.descendant(of: sidebar, matching: find.text('القرآن')),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: sidebar, matching: find.text('القرآن')),
    );
    await tester.pumpAndSettle();

    expect(find.text('القرآن الكريم'), findsOneWidget);
  });

  testWidgets('phone navigation matches Kim layout and label behavior', (
    tester,
  ) async {
    setSurface(tester, const Size(390, 844));
    await pumpHadeelApp(
      tester,
      clock: ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10)),
      prefs: onboardedWithCity('jerusalem'),
    );

    final navigation = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(
      navigation.labelBehavior,
      NavigationDestinationLabelBehavior.onlyShowSelected,
    );
    expect(tester.getSize(find.byType(NavigationBar)).width, 390);
    expect(tester.getSize(find.byType(NavigationBar)).height, 80);
    expect(find.byType(LiquidGlass), findsNothing);
  });
}
