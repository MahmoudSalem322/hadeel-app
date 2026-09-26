import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/design_gallery/design_gallery_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/more/more_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/placeholder/coming_soon_screen.dart';
import '../../features/settings/providers/settings_provider.dart';
import '../../features/splash/splash_screen.dart';
import '../../shared/widgets/app_shell.dart';
import '../localization/generated/app_localizations.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Builds a "coming soon" page whose title comes from localizations.
typedef _TitleOf = String Function(AppLocalizations l10n);

GoRoute _placeholder(String path, _TitleOf title, {List<RouteBase> routes = const []}) {
  return GoRoute(
    path: path,
    builder: (context, state) => ComingSoonScreen(title: title(AppLocalizations.of(context))),
    routes: routes,
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final onboarded = ref.read(settingsProvider).onboardingDone;
      final path = state.matchedLocation;
      final isEntry = path == Routes.splash || path == Routes.onboarding;
      if (!onboarded && !isEntry) return Routes.onboarding;
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: Routes.onboarding, builder: (context, state) => const OnboardingScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [
              _placeholder(
                Routes.quran,
                (l) => l.featureQuran,
                routes: [
                  _placeholder('surah/:id', (l) => l.featureQuran),
                  _placeholder('search', (l) => l.featureSearch),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              _placeholder(
                Routes.azkar,
                (l) => l.featureAdhkar,
                routes: [_placeholder(':category', (l) => l.featureAdhkar)],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [_placeholder(Routes.prayer, (l) => l.featurePrayerTimes)],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.more, builder: (context, state) => const MoreScreen())],
          ),
        ],
      ),
      _placeholder(Routes.qibla, (l) => l.featureQibla),
      _placeholder(Routes.duas, (l) => l.featureDuas),
      _placeholder(Routes.hadith, (l) => l.featureHadith),
      _placeholder(Routes.tasbeeh, (l) => l.featureTasbeeh),
      _placeholder(Routes.hijriCalendar, (l) => l.featureHijriCalendar),
      _placeholder(Routes.favorites, (l) => l.featureFavorites),
      _placeholder(Routes.search, (l) => l.featureSearch),
      _placeholder(Routes.settings, (l) => l.featureSettings),
      _placeholder(Routes.about, (l) => l.featureAbout),
      _placeholder(Routes.sources, (l) => l.featureSources),
      if (kDebugMode)
        GoRoute(
          path: Routes.designGallery,
          builder: (context, state) => const DesignGalleryScreen(),
        ),
    ],
  );
});
