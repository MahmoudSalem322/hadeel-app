import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/adhkar/adhkar_home_screen.dart';
import '../../features/adhkar/adhkar_reader_screen.dart';
import '../../features/design_gallery/design_gallery_screen.dart';
import '../../features/duas/dua_category_screen.dart';
import '../../features/duas/duas_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/hadith/hadith_screens.dart';
import '../../features/hijri_calendar/hijri_calendar_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/more/more_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/prayer/prayer_screen.dart';
import '../../features/qibla/qibla_screen.dart';
import '../../features/quran/quran_home_screen.dart';
import '../../features/quran/quran_reader_screen.dart';
import '../../features/quran/quran_search_screen.dart';
import '../../features/search/global_search_screen.dart';
import '../../features/settings/about_screens.dart';
import '../../features/settings/providers/settings_provider.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/sources_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/tasbeeh/tasbeeh_screen.dart';
import '../../shared/widgets/app_shell.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRoute _page(String path, Widget Function(GoRouterState state) build, {List<RouteBase> routes = const []}) =>
    GoRoute(path: path, builder: (context, state) => build(state), routes: routes);

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
      _page(Routes.splash, (_) => const SplashScreen()),
      _page(Routes.onboarding, (_) => const OnboardingScreen()),
      StatefulShellRoute(
        builder: (context, state, shell) => AppShell(shell: shell),
        navigatorContainerBuilder: (context, shell, children) {
          return AnimatedBranchContainer(
            currentIndex: shell.currentIndex,
            children: children,
          );
        },
        branches: [
          StatefulShellBranch(routes: [_page(Routes.home, (_) => const HomeScreen())]),
          StatefulShellBranch(
            routes: [
              _page(
                Routes.quran,
                (_) => const QuranHomeScreen(),
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
                    builder: (context, state) => QuranSearchScreen(initialQuery: state.uri.queryParameters['q'] ?? ''),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              _page(
                Routes.azkar,
                (_) => const AdhkarHomeScreen(),
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
          StatefulShellBranch(routes: [_page(Routes.prayer, (_) => const PrayerScreen())]),
          StatefulShellBranch(routes: [_page(Routes.more, (_) => const MoreScreen())]),
        ],
      ),
      _page(Routes.qibla, (_) => const QiblaScreen()),
      _page(Routes.tasbeeh, (_) => const TasbeehScreen()),
      _page(Routes.hijriCalendar, (_) => const HijriCalendarScreen()),
      _page(Routes.favorites, (_) => const FavoritesScreen()),
      _page(Routes.search, (_) => const GlobalSearchScreen()),
      _page(Routes.settings, (_) => const SettingsScreen()),
      _page(Routes.about, (_) => const AboutScreen()),
      _page(Routes.privacy, (_) => const PrivacyScreen()),
      _page(Routes.sources, (_) => const SourcesScreen()),
      _page(
        Routes.duas,
        (_) => const DuasScreen(),
        routes: [_page(':category', (s) => DuaCategoryScreen(categoryKey: s.pathParameters['category'] ?? ''))],
      ),
      _page(
        Routes.hadith,
        (_) => const HadithBooksScreen(),
        routes: [
          _page(
            ':book',
            (s) => HadithBookScreen(bookKey: s.pathParameters['book'] ?? ''),
            routes: [
              _page(
                ':n',
                (s) => HadithDetailScreen(
                  bookKey: s.pathParameters['book'] ?? '',
                  number: int.tryParse(s.pathParameters['n'] ?? '') ?? 0,
                ),
              ),
            ],
          ),
        ],
      ),
      if (kDebugMode) _page(Routes.designGallery, (_) => const DesignGalleryScreen()),
    ],
  );
});
