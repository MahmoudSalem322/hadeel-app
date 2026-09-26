import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hadeel/core/routing/routes.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/data/local/preferences_store.dart';

import '../helpers/test_harness.dart';

void main() {
  setUpAll(initTestEnvironment);

  for (final mode in ['light', 'dark']) {
    testWidgets('design gallery lays out at phone width ($mode)', (tester) async {
      setSurface(tester, const Size(360, 800));
      final clock = ManualClock(zoned('Asia/Hebron', 2026, 9, 26, 10));
      await pumpHadeelApp(
        tester,
        clock: clock,
        prefs: {...onboardedWithCity('jerusalem'), PreferencesStore.keyThemeMode: mode},
      );

      GoRouter.of(tester.element(find.byType(NavigationBar))).push(Routes.designGallery);
      await tester.pumpAndSettle();
      expect(find.text('نظام التصميم'), findsOneWidget);

      await tester.drag(find.byType(ListView).last, const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
