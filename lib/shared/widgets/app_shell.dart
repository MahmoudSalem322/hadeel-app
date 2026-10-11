import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../extensions/context_x.dart';
import 'liquid_glass.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;
  static const double barHeight = 72;
  static const double sideMargin = AppSpacing.md;
  static const double bottomMargin = AppSpacing.sm;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: bottomMargin),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: sideMargin),
          child: LiquidGlass(
            radius: 36,
            blur: 8,
            child: NavigationBar(
              height: barHeight,
              backgroundColor: Colors.transparent,
              selectedIndex: shell.currentIndex,
              onDestinationSelected: (index) => shell.goBranch(
                index,
                initialLocation: index == shell.currentIndex,
              ),
              indicatorColor: context.colors.primary.withValues(alpha: .14),
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
    );
  }
}

/// Keeps each branch mounted, but only paints and ticks the selected branch.
/// Whole-page fades would composite two glass-heavy screens on every frame.
class AnimatedBranchContainer extends StatelessWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });
  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      for (var index = 0; index < children.length; index++)
        Offstage(
          offstage: index != currentIndex,
          child: TickerMode(
            enabled: index == currentIndex,
            child: RepaintBoundary(child: children[index]),
          ),
        ),
    ],
  );
}
