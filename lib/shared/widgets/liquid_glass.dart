import 'dart:ui';

import 'package:flutter/material.dart';

/// Clipped frosted lens with a tinted body and reflective edge.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.tint,
    this.radius = 28,
    this.padding = EdgeInsets.zero,
    this.blur = 0,
  });
  final Widget child;
  final Color? tint;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final opaque = MediaQuery.maybeOf(context)?.accessibleNavigation ?? false;
    final color = tint ?? theme.colorScheme.surface;
    final borderRadius = BorderRadius.circular(radius);
    final body = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: opaque ? null : const [0, .10, .65, 1],
          colors: opaque
              ? [color, color]
              : [
                  Color.lerp(
                    color,
                    Colors.white,
                    tint != null ? .06 : (dark ? .28 : .60),
                  )!.withValues(alpha: tint != null ? 1 : .85),
                  Color.lerp(
                    color,
                    Colors.white,
                    tint != null ? .02 : (dark ? .10 : .32),
                  )!.withValues(alpha: tint == null ? .62 : 1),
                  color.withValues(
                    alpha: tint == null ? (dark ? .35 : .40) : 1,
                  ),
                  Color.lerp(
                    color,
                    theme.colorScheme.primary,
                    .08,
                  )!.withValues(alpha: tint != null ? 1 : (dark ? .72 : .58)),
                ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: dark ? .20 : .80),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(padding: padding, child: child),
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(
              alpha: dark ? .08 : .07,
            ),
            blurRadius: 12,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: opaque || blur <= 0
            ? body
            : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: body,
              ),
      ),
    );
  }
}

/// Luminous backdrop visible through transparent route scaffolds.
class LiquidBackdrop extends StatelessWidget {
  const LiquidBackdrop({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [
                  const Color(0xFF101526),
                  const Color(0xFF18233C),
                  const Color(0xFF201B38),
                ]
              : [
                  const Color(0xFFE5F8F5),
                  const Color(0xFFF7F8FF),
                  const Color(0xFFF3EAFE),
                ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -100,
            right: -120,
            child: _Glow(
              color: theme.colorScheme.primary.withValues(
                alpha: dark ? .25 : .13,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -160,
            child: _Glow(color: const Color(0xFF9CABE8).withValues(alpha: .20)),
          ),
          Positioned(
            top: 310,
            right: -190,
            child: _Glow(
              color: theme.colorScheme.secondary.withValues(alpha: .12),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SizedBox.square(
      dimension: 460,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    ),
  );
}
