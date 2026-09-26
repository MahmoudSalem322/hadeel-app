// End-to-end flows on a real device or emulator.
//
// Run (device in Airplane Mode to prove offline-first):
//   flutter test integration_test -d <device-id>
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/app.dart';
import 'package:hadeel/core/bootstrap.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Start every run as a fresh install.
    await SharedPreferencesAsync().clear();
  });

  testWidgets('first launch → onboarding → manual city → home with countdown', (tester) async {
    final overrides = await bootstrap();
    await tester.pumpWidget(ProviderScope(overrides: overrides, child: const HadeelApp()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('أهلًا بك في هديل'), findsOneWidget);
    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('اختر المدينة'));
    await tester.tap(find.text('اختر المدينة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('القدس'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ابدأ الآن'));
    await tester.pumpAndSettle();

    expect(find.text('الصلاة القادمة'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
