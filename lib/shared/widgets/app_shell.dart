import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../extensions/context_x.dart';

/// Scaffold with a floating tab bar. Each tab keeps
/// its own stack. Content scrolls underneath the bar; tab screens add
/// context.navBarInset to their bottom padding so nothing stays hidden.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const double barHeight = 56;
  static const double sideMargin = AppSpacing.lg;
  static const double bottomMargin = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brand = context.brand;
    final dark = context.theme.brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: bottomMargin),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: sideMargin),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(barHeight / 2),
              border: Border.all(color: brand.divider.withValues(alpha: dark ? 0.6 : 0.8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? 0.35 : 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SizedBox(
              height: barHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabWidth = constraints.maxWidth / 5;
                  final indicatorWidth = 48.0;
                  final indicatorHeight = 32.0;
                  
                  final isRtl = Directionality.of(context) == TextDirection.rtl;
                  final visualIndex = isRtl ? (4 - shell.currentIndex) : shell.currentIndex;
                  final indicatorOffset = (tabWidth * visualIndex) + ((tabWidth - indicatorWidth) / 2);

                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        left: indicatorOffset,
                        top: 12.0,
                        width: indicatorWidth,
                        height: indicatorHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.colors.primaryContainer,
                            borderRadius: BorderRadius.circular(indicatorHeight / 2),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _buildNavItem(context, 0, Icons.home_outlined, Icons.home_rounded, l10n.navHome),
                          _buildNavItem(context, 1, Icons.menu_book_outlined, Icons.menu_book_rounded, l10n.navQuran),
                          _buildNavItem(context, 2, Icons.auto_awesome_outlined, Icons.auto_awesome, l10n.navAdhkar),
                          _buildNavItem(context, 3, Icons.access_time, Icons.access_time_filled_rounded, l10n.navPrayer),
                          _buildNavItem(context, 4, Icons.grid_view_outlined, Icons.grid_view_rounded, l10n.navMore),
                        ],
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = shell.currentIndex == index;
    final colorScheme = context.colors;
    final brand = context.brand;
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => shell.goBranch(index, initialLocation: index == shell.currentIndex),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 32,
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 24,
                color: isSelected ? colorScheme.primary : brand.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({super.key, required this.currentIndex, required this.children});

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() => _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _currentIndex;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _previousIndex = widget.currentIndex;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))..value = 1.0;
  }

  @override
  void didUpdateWidget(AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _currentIndex = widget.currentIndex;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(widget.children.length, (index) {
            final isCurrent = index == _currentIndex;
            final isPrevious = index == _previousIndex;
            
            if (!isCurrent && !isPrevious) {
              return Offstage(
                offstage: true,
                child: TickerMode(enabled: false, child: widget.children[index]),
              );
            }
            
            final direction = _currentIndex > _previousIndex ? 1.0 : -1.0;
            double offset = 0.0;
            double opacity = 1.0;
            
            if (isCurrent) {
              offset = Tween<double>(begin: direction * 0.15, end: 0.0)
                  .chain(CurveTween(curve: Curves.easeOutCubic))
                  .evaluate(_controller);
              opacity = Tween<double>(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeIn))
                  .evaluate(_controller);
            } else if (isPrevious) {
              offset = Tween<double>(begin: 0.0, end: -direction * 0.15)
                  .chain(CurveTween(curve: Curves.easeOutCubic))
                  .evaluate(_controller);
              opacity = Tween<double>(begin: 1.0, end: 0.0)
                  .chain(CurveTween(curve: Curves.easeOut))
                  .evaluate(_controller);
            }
            
            return Offstage(
              offstage: false,
              child: TickerMode(
                enabled: isCurrent,
                child: IgnorePointer(
                  ignoring: !isCurrent,
                  child: Opacity(
                    opacity: opacity,
                    child: FractionalTranslation(
                      translation: Offset(offset, 0.0),
                      child: widget.children[index],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
