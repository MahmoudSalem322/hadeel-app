import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../extensions/context_x.dart';

/// Scaffold with a floating, frosted-glass tab bar (iOS style). Each tab keeps
/// its own stack. Content scrolls underneath the bar; tab screens add
/// `context.navBarInset` to their bottom padding so nothing stays hidden.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const double barHeight = 64;
  static const double sideMargin = AppSpacing.lg;
  static const double bottomMargin = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brand = context.brand;
    final dark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      // Lets content pass behind the bar so the blur has something to show.
      extendBody: true,
      body: shell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: bottomMargin),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: sideMargin),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(barHeight / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? 0.35 : 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(barHeight / 2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.surface.withValues(alpha: dark ? 0.62 : 0.72),
                    borderRadius: BorderRadius.circular(barHeight / 2),
                    border: Border.all(color: brand.divider.withValues(alpha: dark ? 0.6 : 0.8)),
                  ),
                  // The bar sits inside SafeArea already; stop NavigationBar
                  // from adding the system inset a second time.
                  child: MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    child: NavigationBar(
                      height: barHeight,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      indicatorShape: const StadiumBorder(),
                      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                      selectedIndex: shell.currentIndex,
                      onDestinationSelected: (index) => shell.goBranch(
                        index,
                        // Tapping the active tab returns to its root.
                        initialLocation: index == shell.currentIndex,
                      ),
                      destinations: [
                        NavigationDestination(
                          icon: const Icon(Icons.home_outlined),
                          selectedIcon: const Icon(Icons.home_rounded),
                          label: l10n.navHome,
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.menu_book_outlined),
                          selectedIcon: const Icon(Icons.menu_book_rounded),
                          label: l10n.navQuran,
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.auto_awesome_outlined),
                          selectedIcon: const Icon(Icons.auto_awesome),
                          label: l10n.navAdhkar,
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.access_time),
                          selectedIcon: const Icon(Icons.access_time_filled_rounded),
                          label: l10n.navPrayer,
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.grid_view_outlined),
                          selectedIcon: const Icon(Icons.grid_view_rounded),
                          label: l10n.navMore,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
