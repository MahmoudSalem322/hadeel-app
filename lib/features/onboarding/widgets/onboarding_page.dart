import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/context_x.dart';

/// One onboarding page: a quiet emblem, a title and a short line of text.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.emblem,
    required this.title,
    required this.body,
    this.footer,
  });

  final Widget emblem;
  final String title;
  final String body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  emblem,
                  const SizedBox(height: AppSpacing.xxl),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: context.text.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    body,
                    style: context.text.bodyLarge!.copyWith(color: context.brand.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  if (footer != null) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft circular badge holding an icon — the onboarding "illustration".
class OnboardingEmblem extends StatelessWidget {
  const OnboardingEmblem({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.primaryContainer,
        border: Border.all(color: context.brand.gold.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Icon(icon, size: 56, color: context.colors.primary),
    );
  }
}
