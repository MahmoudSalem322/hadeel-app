import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/utils/clock.dart';

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
}
