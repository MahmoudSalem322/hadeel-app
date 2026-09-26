// End-to-end flows on a real device or emulator.
//
// Offline check (spec §57): enable Airplane Mode first, e.g.
//   adb shell cmd connectivity airplane-mode enable
//   flutter test integration_test -d <device-id>
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/app.dart';
import 'package:hadeel/core/bootstrap.dart';
import 'package:hadeel/core/database/app_database.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _freshInstall() async {
  await SharedPreferencesAsync().clear();
  final db = AppDatabase.open();
  for (final table in db.allTables) {
    await db.delete(table).go();
  }
  await db.close();
}

Future<void> _launch(WidgetTester tester) async {
  final overrides = await bootstrap();
  await tester.pumpWidget(
    ProviderScope(overrides: overrides, retry: (_, _) => null, child: const HadeelApp()),
  );
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

Future<void> _tab(WidgetTester tester, String label) async {
  await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text(label)));
  await tester.pumpAndSettle();
}

Future<void> _back(WidgetTester tester) async {
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('first launch → core features, all offline', (tester) async {
    await _freshInstall();
    await _launch(tester);

    // Onboarding with a manual city (no GPS prompt needed).
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

    // Home: next prayer computed on the device.
    expect(find.text('الصلاة القادمة'), findsOneWidget);
    expect(find.text('متبقي'), findsOneWidget);

    // Quran: read Al-Fatiha and favorite an ayah.
    await _tab(tester, 'القرآن');
    await tester.tap(find.text('الفاتحة'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('سورة الفاتحة'), findsWidgets);
    await tester.tap(find.bySemanticsLabel(RegExp('^آية 2')).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('المفضلة').last);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10)); // dismiss the sheet
    await tester.pumpAndSettle();
    await _back(tester);
    await tester.tap(find.text('المفضلة'));
    await tester.pumpAndSettle();
    expect(find.textContaining('الفاتحة · آية 2'), findsOneWidget);

    // Adhkar: count a dhikr.
    await _tab(tester, 'الأذكار');
    await tester.tap(find.text('أذكار الصباح والمساء').first);
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel(RegExp('^تسبيح')));
    await tester.pumpAndSettle();
    await _back(tester);

    // Prayer timeline.
    await _tab(tester, 'الصلاة');
    expect(find.text('الفجر'), findsWidgets);
    expect(find.text('العشاء'), findsWidgets);

    // Qibla and tasbeeh from "More".
    await _tab(tester, 'المزيد');
    await tester.tap(find.text('القبلة'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.textContaining('من الشمال'), findsOneWidget);
    await _back(tester);

    await tester.tap(find.text('التسبيح'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel(RegExp('^اضغط للتسبيح')));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    await _back(tester);
  });

  testWidgets('returning user lands on Home with saved state', (tester) async {
    await _launch(tester);
    expect(find.text('السلام عليكم'), findsOneWidget);
    expect(find.text('الصلاة القادمة'), findsOneWidget);
  });
}
