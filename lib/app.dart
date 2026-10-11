import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/generated/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/prayer/providers/notification_providers.dart';
import 'features/settings/providers/settings_provider.dart';
import 'shared/widgets/liquid_glass.dart';

class HadeelApp extends ConsumerStatefulWidget {
  const HadeelApp({super.key});

  @override
  ConsumerState<HadeelApp> createState() => _HadeelAppState();
}

class _HadeelAppState extends ConsumerState<HadeelApp> {
  late final AppLifecycleListener _lifecycle;
  Timer? _dailyRefresh;

  @override
  void initState() {
    super.initState();
    // Notifications are scheduled a few days ahead; top them up whenever the
    // app comes back to the foreground.
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.invalidate(prayerNotificationSyncProvider),
    );
    var day = DateTime.now();
    _dailyRefresh = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now();
      if (now.year != day.year || now.month != day.month || now.day != day.day) {
        day = now;
        ref.invalidate(prayerNotificationSyncProvider);
      }
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _dailyRefresh?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(prayerNotificationSyncProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.light(ref.watch(colorThemeProvider)),
      darkTheme: AppTheme.dark(ref.watch(colorThemeProvider)),
      themeMode: ref.watch(themeModeProvider),
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) =>
          LiquidBackdrop(child: child ?? const SizedBox.shrink()),
    );
  }
}
