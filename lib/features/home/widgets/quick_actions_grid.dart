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
      (Icons.auto_awesome_outlined, l10n.featureAdhkar, () => context.go(Routes.azkar)),
      (Icons.fingerprint_rounded, l10n.featureTasbeeh, () => context.push(Routes.tasbeeh)),
      (Icons.explore_outlined, l10n.featureQibla, () => context.push(Routes.qibla)),
      (Icons.volunteer_activism_outlined, l10n.featureDuas, () => context.push(Routes.duas)),
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
            for (final (icon, label, onTap) in actions)
              SizedBox(
                width: width,
                child: _QuickAction(icon: icon, label: label, onTap: onTap),
              ),
          ],
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HadeelCard(
      onTap: onTap,
      semanticLabel: label,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xxs),
      child: ExcludeSemantics(
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.colors.primary, size: 22),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: context.text.labelMedium!.copyWith(color: context.colors.onSurface),
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
