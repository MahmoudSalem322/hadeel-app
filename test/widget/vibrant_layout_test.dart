import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/localization/generated/app_localizations.dart';
import 'package:hadeel/core/theme/app_theme.dart';
import 'package:hadeel/features/home/widgets/quick_actions_grid.dart';
import 'package:hadeel/shared/widgets/colorful_hero.dart';
import 'package:hadeel/shared/widgets/hadeel_card.dart';
import 'package:hadeel/shared/widgets/hadeel_logo.dart';

import 'glass_performance_test.dart' show blurLayers;

void main() {
  for (final width in [320.0, 390.0]) {
    for (final dark in [false, true]) {
      testWidgets(
        'colorful surfaces fit $width px, dark=$dark, large Arabic text',
        (tester) async {
          tester.view.physicalSize = Size(width, 844);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(
            MaterialApp(
              theme: dark ? AppTheme.dark() : AppTheme.light(),
              locale: const Locale('ar'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
              home: const Scaffold(
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      HadeelLogo(size: 44),
                      ColorfulHero(
                        child: Text(
                          'الصلاة القادمة',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16),
                      QuickActionsGrid(),
                      SizedBox(height: 16),
                      HadeelCard(child: Text('ذكر اليوم')),
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: 'Arabic labels must fit narrow phones at large font sizes',
          );
          expect(
            blurLayers(tester.binding.renderViews.single.debugLayer!),
            0,
            reason: 'reading surfaces must not add GPU backdrop sampling',
          );
          expect(find.byType(QuickActionsGrid), findsOneWidget);
        },
      );
    }
  }
}
