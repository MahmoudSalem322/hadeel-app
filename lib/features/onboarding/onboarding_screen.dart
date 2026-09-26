import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/hadeel_logo.dart';
import '../prayer/widgets/location_setup_panel.dart';
import '../settings/providers/settings_provider.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const int pageCount = 4;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == OnboardingScreen.pageCount - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _controller.jumpToPage(page);
    } else {
      _controller.animateToPage(page, duration: AppMotion.medium, curve: AppMotion.curve);
    }
  }

  Future<void> _finish() async {
    await ref.read(settingsProvider.notifier).completeOnboarding();
    if (mounted) context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pages = [
      OnboardingPage(
        emblem: HadeelLogo(size: 132, semanticLabel: l10n.appName),
        title: l10n.onboardingWelcomeTitle,
        body: l10n.onboardingWelcomeBody,
      ),
      OnboardingPage(
        emblem: const OnboardingEmblem(icon: Icons.menu_book_rounded),
        title: l10n.onboardingQuranTitle,
        body: l10n.onboardingQuranBody,
      ),
      OnboardingPage(
        emblem: const OnboardingEmblem(icon: Icons.access_time_rounded),
        title: l10n.onboardingPrayerTitle,
        body: l10n.onboardingPrayerBody,
      ),
      OnboardingPage(
        emblem: const OnboardingEmblem(icon: Icons.explore_outlined),
        title: l10n.onboardingStartTitle,
        body: l10n.onboardingStartBody,
        footer: const LocationSetupPanel(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AnimatedOpacity(
                  opacity: _isLast ? 0 : 1,
                  duration: AppMotion.fast,
                  child: TextButton(
                    onPressed: _isLast ? null : () => _goTo(OnboardingScreen.pageCount - 1),
                    child: Text(l10n.actionSkip),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (page) => setState(() => _page = page),
                children: pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _Dots(count: OnboardingScreen.pageCount, current: _page),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: _isLast ? l10n.actionStartNow : l10n.actionNext,
                      onPressed: _isLast ? _finish : () => _goTo(_page + 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.onboardingPageIndicator(current + 1, count),
      child: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < count; i++)
              AnimatedContainer(
                duration: AppMotion.medium,
                curve: AppMotion.curve,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == current ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == current ? context.colors.primary : context.colors.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
