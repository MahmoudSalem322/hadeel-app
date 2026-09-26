import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/context_x.dart';
import '../../prayer/providers/prayer_providers.dart';
import '../providers/home_providers.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final f = context.formatters;
    final hijri = ref.watch(todayHijriProvider);
    final gregorian = ref.watch(todayDateProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(l10n.homeGreeting, style: context.text.headlineSmall),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                l10n.hijriLabel(hijri, f),
                style: context.text.titleSmall!.copyWith(color: context.brand.goldText),
              ),
              Text(
                f.gregorianDate(gregorian),
                style: context.text.bodySmall,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: l10n.featureSearch,
          onPressed: () => context.push(Routes.search),
          icon: const Icon(Icons.search_rounded),
        ),
        IconButton(
          tooltip: l10n.featureSettings,
          onPressed: () => context.push(Routes.settings),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
