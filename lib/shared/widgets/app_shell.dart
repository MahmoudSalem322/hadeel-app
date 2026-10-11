import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../extensions/context_x.dart';
import 'liquid_glass.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;
  static const double wideBreakpoint = 900;
  static const double sidebarWidth = 246;
  static const double barHeight = 72;
  static const double sideMargin = AppSpacing.md;
  static const double bottomMargin = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinations = [
      _ShellDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: l10n.navHome,
      ),
      _ShellDestination(
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book_rounded,
        label: l10n.navQuran,
      ),
      _ShellDestination(
        icon: Icons.auto_awesome_outlined,
        selectedIcon: Icons.auto_awesome,
        label: l10n.navAdhkar,
      ),
      _ShellDestination(
        icon: Icons.access_time,
        selectedIcon: Icons.access_time_filled_rounded,
        label: l10n.navPrayer,
      ),
      _ShellDestination(
        icon: Icons.grid_view_outlined,
        selectedIcon: Icons.grid_view_rounded,
        label: l10n.navMore,
      ),
    ];

    void selectDestination(int index) =>
        shell.goBranch(index, initialLocation: index == shell.currentIndex);

    final wide = MediaQuery.sizeOf(context).width >= wideBreakpoint;
    return Scaffold(
      extendBody: true,
      body: wide
          ? SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HadeelSidebar(
                    destinations: destinations,
                    selectedIndex: shell.currentIndex,
                    onDestinationSelected: selectDestination,
                  ),
                  Expanded(child: shell),
                ],
              ),
            )
          : shell,
      bottomNavigationBar: wide
          ? null
          : SafeArea(
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
                    onDestinationSelected: selectDestination,
                    indicatorColor: context.colors.primary.withValues(
                      alpha: .14,
                    ),
                    destinations: [
                      for (final destination in destinations)
                        NavigationDestination(
                          icon: Icon(destination.icon),
                          selectedIcon: Icon(destination.selectedIcon),
                          label: destination.label,
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _HadeelSidebar extends StatelessWidget {
  const _HadeelSidebar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      key: const ValueKey('app-sidebar'),
      width: AppShell.sidebarWidth,
      decoration: BoxDecoration(
        color: colors.surface,
        border: BorderDirectional(
          end: BorderSide(color: colors.outlineVariant.withValues(alpha: .55)),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight =
              constraints.maxHeight - AppSpacing.xl - AppSpacing.lg;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: availableHeight > 0 ? availableHeight : 0,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _HadeelBrand(),
                    const SizedBox(height: AppSpacing.xxxl),
                    for (var index = 0; index < destinations.length; index++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: _SidebarDestinationTile(
                          destination: destinations[index],
                          selected: index == selectedIndex,
                          onTap: () => onDestinationSelected(index),
                        ),
                      ),
                    const Spacer(),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: LinearGradient(
                          colors: [
                            colors.primary,
                            colors.tertiary,
                            colors.secondary,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HadeelBrand extends StatelessWidget {
  const _HadeelBrand();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconDecodeSize = (46 * MediaQuery.devicePixelRatioOf(context)).ceil();
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [colors.primary, colors.tertiary],
            ),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: .18),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/branding/icon_v4.png',
              cacheWidth: iconDecodeSize,
              cacheHeight: iconDecodeSize,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            context.l10n.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarDestinationTile extends StatelessWidget {
  const _SidebarDestinationTile({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _ShellDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected
          ? colors.primary.withValues(alpha: .11)
          : Colors.transparent,
      borderRadius: AppRadius.smAll,
      child: ListTile(
        selected: selected,
        selectedColor: colors.primary,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        leading: Icon(
          selected ? destination.selectedIcon : destination.icon,
          size: 22,
        ),
        title: Text(
          destination.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ShellDestination {
  const _ShellDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
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
