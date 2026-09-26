import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/hadeel_logo.dart';
import '../settings/providers/settings_provider.dart';

/// Brief brand moment after the native splash. Data is already loaded by
/// bootstrap, so this never shows a spinner.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashMinDuration, _continue);
  }

  void _continue() {
    if (!mounted) return;
    final onboarded = ref.read(settingsProvider).onboardingDone;
    context.go(onboarded ? Routes.home : Routes.onboarding);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
          duration: AppMotion.slow,
          curve: AppMotion.curve,
          builder: (context, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(offset: Offset(0, 8 * (1 - t)), child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HadeelLogo(size: 104, semanticLabel: l10n.appName),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.appName, style: context.text.displaySmall),
              Text(
                l10n.appNameLatin,
                style: context.text.titleSmall!.copyWith(
                  color: context.brand.goldText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.appTagline,
                textAlign: TextAlign.center,
                style: AppTypography.quran(color: context.brand.textSecondary, fontSize: 20, height: 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
