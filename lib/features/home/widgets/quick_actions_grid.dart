import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/hadeel_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = [
      // Adhkar is a tab: switch branches instead of stacking a page.
      (
        Icons.auto_awesome_outlined,
        l10n.featureAdhkar,
        () => context.go(Routes.azkar),
        const Color(0xFF087F8C),
      ),
      (
        Icons.fingerprint_rounded,
        l10n.featureTasbeeh,
        () => context.push(Routes.tasbeeh),
        const Color(0xFF7554CF),
      ),
      (
        Icons.explore_outlined,
        l10n.featureQibla,
        () => context.push(Routes.qibla),
        const Color(0xFF2D68CB),
      ),
      (
        Icons.volunteer_activism_outlined,
        l10n.featureDuas,
        () => context.push(Routes.duas),
        const Color(0xFFBB526A),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.sm;
        final columns = constraints.maxWidth >= 340 ? 4 : 2;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (icon, label, onTap, accent) in actions)
              SizedBox(
                width: width,
                child: _QuickAction(
                  icon: icon,
                  label: label,
                  onTap: onTap,
                  accent: accent,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return HadeelCard(
      color: Color.lerp(
        Theme.of(context).colorScheme.surface,
        accent,
        Theme.of(context).brightness == Brightness.dark ? .20 : .10,
      ),
      onTap: onTap,
      semanticLabel: label,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.xxs,
      ),
      child: ExcludeSemantics(
        child: Column(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color.lerp(accent, Colors.white, .15)!, accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: .20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 23),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: context.text.labelMedium!.copyWith(
                color: context.colors.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
