import 'package:flutter/material.dart';

/// A saturated, static hero; decorative orbits need no backdrop sampling.
class ColorfulHero extends StatelessWidget {
  const ColorfulHero({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(32),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF236DAD).withValues(alpha: .23),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF08727F), Color(0xFF2261A5), Color(0xFF6752B9)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(left: -55, top: -75, child: _Orbit(size: 220)),
            const Positioned(
              right: -65,
              bottom: -125,
              child: _Orbit(size: 250),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    ),
  );
}

class _Orbit extends StatelessWidget {
  const _Orbit({required this.size});
  final double size;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: .04),
        border: Border.all(
          color: Colors.white.withValues(alpha: .14),
          width: 1.5,
        ),
      ),
    ),
  );
}
