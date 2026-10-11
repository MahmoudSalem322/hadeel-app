import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../extensions/context_x.dart';
import 'hadeel_logo.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const double wideBreakpoint = 900;
  static const double sidebarWidth = 246;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final wide = MediaQuery.sizeOf(context).width >= wideBreakpoint;
    final destinations = [
      _ShellDestination(icon: Icons.home_outlined, label: l10n.navHome),
      _ShellDestination(icon: Icons.menu_book_outlined, label: l10n.navQuran),
      _ShellDestination(
        icon: Icons.auto_awesome_outlined,
        label: l10n.navAdhkar,
      ),
      _ShellDestination(icon: Icons.access_time, label: l10n.navPrayer),
      _ShellDestination(icon: Icons.grid_view_outlined, label: l10n.navMore),
    ];

    void selectDestination(int index) =>
        shell.goBranch(index, initialLocation: index == shell.currentIndex);

    return Scaffold(
      bottomNavigationBar: wide
          ? null
          : Theme(
              data: Theme.of(context).copyWith(
                navigationBarTheme: NavigationBarThemeData(
                  backgroundColor: colors.surface,
                  indicatorColor: colors.primaryContainer,
                ),
              ),
              child: NavigationBar(
                selectedIndex: shell.currentIndex,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                onDestinationSelected: selectDestination,
                destinations: [
                  for (var index = 0; index < destinations.length; index++)
                    NavigationDestination(
                      key: ValueKey('nav-$index'),
                      icon: Icon(destinations[index].icon),
                      label: destinations[index].label,
                    ),
                ],
              ),
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wide)
              Container(
                key: const ValueKey('app-sidebar'),
                width: sidebarWidth,
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: BorderDirectional(
                    end: BorderSide(
                      color: colors.outlineVariant.withValues(alpha: .4),
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(listTileTheme: const ListTileThemeData()),
                  child: _ScrollableSidebar(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Brand(),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 14,
                            bottom: 14,
                          ),
                          child: Text(
                            l10n.sidebarWorkspace,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  letterSpacing: 1.4,
                                ),
                          ),
                        ),
                        for (
                          var index = 0;
                          index < destinations.length;
                          index++
                        )
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                key: ValueKey('sidebar-nav-$index'),
                                selected: index == shell.currentIndex,
                                selectedColor: colors.primary,
                                selectedTileColor: colors.primary.withValues(
                                  alpha: .09,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                leading: Icon(
                                  destinations[index].icon,
                                  size: 22,
                                ),
                                title: Text(
                                  destinations[index].label,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                onTap: () => selectDestination(index),
                              ),
                            ),
                          ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: .05),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: colors.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.settingsPrivacy,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.sidebarDeviceBody,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      height: 1.7,
                                      color: colors.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.aboutVersion('0.3.1'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(child: shell),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: HadeelLogo(size: 30, withBackground: false),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              context.l10n.appName,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScrollableSidebar extends StatelessWidget {
  const _ScrollableSidebar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: IntrinsicHeight(child: child),
      ),
    ),
  );
}

class _ShellDestination {
  const _ShellDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;
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
