import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/hadeel_logo.dart';
import '../../shared/widgets/responsive_body.dart';
import 'settings_screen.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final version = ref.watch(appVersionProvider).value ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureAbout)),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Center(child: HadeelLogo(size: 96, semanticLabel: l10n.appName)),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.appName, style: context.text.headlineMedium, textAlign: TextAlign.center),
            Text(
              l10n.appTagline,
              style: context.text.titleSmall!.copyWith(color: context.brand.goldText),
              textAlign: TextAlign.center,
            ),
            if (version.isNotEmpty)
              Text(l10n.aboutVersion(version), style: context.text.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.aboutBody, style: context.text.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            SecondaryButton(
              label: l10n.featureSources,
              icon: Icons.library_books_outlined,
              onPressed: () => context.push(Routes.sources),
            ),
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              label: l10n.settingsPrivacy,
              icon: Icons.privacy_tip_outlined,
              onPressed: () => context.push(Routes.privacy),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsPrivacy)),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Icon(Icons.shield_outlined, size: 56, color: context.colors.primary),
            const SizedBox(height: AppSpacing.lg),
            Text(context.l10n.privacyBody, style: context.text.bodyLarge),
          ],
        ),
      ),
    );
  }
}
