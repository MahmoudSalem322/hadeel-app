import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/section_header.dart';
import '../prayer/providers/prayer_providers.dart';
import '../quran/widgets/continue_reading_card.dart';
import 'widgets/daily_content_card.dart';
import 'widgets/home_header.dart';
import 'widgets/next_prayer_card.dart';
import 'widgets/prayer_times_strip.dart';
import 'widgets/quick_actions_grid.dart';

/// Home, ordered by what matters most day-to-day: next prayer, Quran,
/// today's times, quick access (adhkar, tasbeeh, qibla, duas), then the day's
/// ayah, dhikr, hadith and dua from verified local content.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final hasLocation = ref.watch(resolvedLocationProvider) != null;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ResponsiveBody(
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.screenGutter,
              AppSpacing.md,
              AppSpacing.screenGutter,
              AppSpacing.xxl,
            ),
            children: [
              const HomeHeader(),
              const SizedBox(height: AppSpacing.lg),
              const NextPrayerCard(),
              const SizedBox(height: AppSpacing.md),
              const ContinueReadingCard(),
              if (hasLocation) ...[
                SectionHeader(title: l10n.homeTodayPrayerTimes),
                const PrayerTimesStrip(),
              ],
              SectionHeader(title: l10n.homeQuickAccess),
              const QuickActionsGrid(),
              const DailyContentSection(),
            ],
          ),
        ),
      ),
    );
  }
}
