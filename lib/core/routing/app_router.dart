import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/adhkar/adhkar_home_screen.dart';
import '../../features/adhkar/adhkar_reader_screen.dart';
import '../../features/design_gallery/design_gallery_screen.dart';
import '../../features/duas/dua_category_screen.dart';
import '../../features/duas/duas_screen.dart';
import '../../features/hadith/hadith_screens.dart';
import '../../features/home/home_screen.dart';
import '../../features/more/more_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/placeholder/coming_soon_screen.dart';
import '../../features/quran/quran_home_screen.dart';
import '../../features/quran/quran_reader_screen.dart';
import '../../features/quran/quran_search_screen.dart';
import '../../features/settings/providers/settings_provider.dart';
import '../../features/settings/sources_screen.dart';
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
              GoRoute(
                path: Routes.quran,
                builder: (context, state) => const QuranHomeScreen(),
                routes: [
                  // Reading and search open full-screen, above the tab bar.
                  GoRoute(
                    path: 'surah/:id',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => QuranReaderScreen(
                      key: ValueKey(state.uri.toString()),
                      surahNumber: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
                      initialAyah: int.tryParse(state.uri.queryParameters['ayah'] ?? ''),
                    ),
                  ),
                  GoRoute(
                    path: 'search',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => const QuranSearchScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.azkar,
                builder: (context, state) => const AdhkarHomeScreen(),
                routes: [
                  GoRoute(
                    path: ':category',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) =>
                        AdhkarReaderScreen(categoryKey: state.pathParameters['category'] ?? ''),
                  ),
                ],
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
      GoRoute(
        path: Routes.duas,
        builder: (context, state) => const DuasScreen(),
        routes: [
          GoRoute(
            path: ':category',
            builder: (context, state) => DuaCategoryScreen(categoryKey: state.pathParameters['category'] ?? ''),
          ),
        ],
      ),
      GoRoute(
        path: Routes.hadith,
        builder: (context, state) => const HadithBooksScreen(),
        routes: [
          GoRoute(
            path: ':book',
            builder: (context, state) => HadithBookScreen(bookKey: state.pathParameters['book'] ?? ''),
            routes: [
              GoRoute(
                path: ':n',
                builder: (context, state) => HadithDetailScreen(
                  bookKey: state.pathParameters['book'] ?? '',
                  number: int.tryParse(state.pathParameters['n'] ?? '') ?? 0,
                ),
              ),
            ],
          ),
        ],
      ),
      _placeholder(Routes.tasbeeh, (l) => l.featureTasbeeh),
      _placeholder(Routes.hijriCalendar, (l) => l.featureHijriCalendar),
      _placeholder(Routes.favorites, (l) => l.featureFavorites),
      _placeholder(Routes.search, (l) => l.featureSearch),
      _placeholder(Routes.settings, (l) => l.featureSettings),
      _placeholder(Routes.about, (l) => l.featureAbout),
      GoRoute(path: Routes.sources, builder: (context, state) => const SourcesScreen()),
      if (kDebugMode)
        GoRoute(
          path: Routes.designGallery,
          builder: (context, state) => const DesignGalleryScreen(),
        ),
    ],
  );
});
