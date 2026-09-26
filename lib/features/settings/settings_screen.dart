import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/routing/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/prayer.dart';
import '../../domain/entities/quran_reading_settings.dart';
import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/content_actions.dart';
import '../../shared/widgets/hadeel_card.dart';
import '../../shared/widgets/responsive_body.dart';
import '../../shared/widgets/section_header.dart';
import '../prayer/providers/location_setup_provider.dart';
import '../prayer/providers/notification_providers.dart';
import '../prayer/providers/prayer_providers.dart';
import '../prayer/widgets/city_picker_sheet.dart';
import '../prayer/widgets/prayer_settings_pickers.dart';
import '../quran/widgets/reading_settings_sheet.dart';
import 'providers/settings_provider.dart';

final appVersionProvider = FutureProvider<String>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return '${info.version} (${info.buildNumber})';
  } catch (_) {
    return '';
  }
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final s = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final location = ref.watch(resolvedLocationProvider);

    Widget group(List<Widget> tiles) => HadeelCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          child: Column(children: [
            for (var i = 0; i < tiles.length; i++) ...[
              if (i > 0) const Divider(indent: AppSpacing.md, endIndent: AppSpacing.md),
              tiles[i],
            ],
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureSettings)),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenGutter, 0, AppSpacing.screenGutter, AppSpacing.xxl),
          children: [
            SectionHeader(title: l10n.settingsAppearance),
            HadeelCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<AppThemeMode>(
                    segments: [
                      ButtonSegment(value: AppThemeMode.light, label: Text(l10n.themeLight), icon: const Icon(Icons.light_mode_outlined)),
                      ButtonSegment(value: AppThemeMode.dark, label: Text(l10n.themeDark), icon: const Icon(Icons.dark_mode_outlined)),
                      ButtonSegment(value: AppThemeMode.system, label: Text(l10n.themeSystem)),
                    ],
                    selected: {s.themeMode},
                    onSelectionChanged: (v) => notifier.setThemeMode(v.first),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.settingsLanguage, style: context.text.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'ar', label: Text(l10n.languageArabic)),
                      ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
                    ],
                    selected: {s.languageCode},
                    onSelectionChanged: (v) => notifier.setLanguage(v.first),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.languageArabic == 'العربية' ? 'لون التطبيق' : 'App Color', style: context.text.titleSmall),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 16,
                    children: [
                      for (final theme in AppColorTheme.values)
                        GestureDetector(
                          onTap: () => notifier.setColorTheme(theme),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: switch (theme) {
                                AppColorTheme.green => const Color(0xFF123C35),
                                AppColorTheme.blue => const Color(0xFF1A5F7A),
                                AppColorTheme.brown => const Color(0xFF795548),
                                AppColorTheme.purple => const Color(0xFF673AB7),
                              },
                              border: s.appColorTheme == theme 
                                ? Border.all(color: context.colors.onSurface, width: 3) 
                                : null,
                            ),
                            child: s.appColorTheme == theme 
                                ? Icon(Icons.check, color: Colors.white, size: 24)
                                : null,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SectionHeader(title: l10n.settingsQuran),
            group([
              ListTile(
                leading: const Icon(Icons.text_fields_rounded),
                title: Text(l10n.readingSettingsTitle),
                subtitle: Text(
                  '${switch (s.quran.font) {
                    QuranFont.amiri => l10n.readingFontAmiri,
                    QuranFont.scheherazade => l10n.readingFontScheherazade,
                  }} · ${context.formatters.number(s.quran.fontSize.round())}',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showReadingSettings(context),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.auto_stories_outlined),
                title: Text(l10n.readingShowTafsir),
                value: s.quran.showTafsir,
                onChanged: (v) => notifier.updateQuranSettings((q) => q.copyWith(showTafsir: v)),
              ),
            ]),
            SectionHeader(title: l10n.settingsPrayer),
            group([
              ListTile(
                leading: Icon(location?.isGps ?? false ? Icons.my_location_rounded : Icons.location_on_outlined),
                title: Text(l10n.settingsLocation),
                subtitle: Text(
                  location == null
                      ? l10n.locationMissingTitle
                      : location.isGps
                          ? l10n.locationGpsLabel
                          : location.city!.localizedName(context.languageCode),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final city = await showCityPicker(context);
                  if (city != null) await ref.read(locationSetupProvider.notifier).chooseCity(city);
                },
              ),
              ListTile(
                leading: const Icon(Icons.my_location_rounded),
                title: Text(l10n.locationUpdate),
                onTap: () async {
                  final ok = await ref.read(locationSetupProvider.notifier).useDeviceLocation();
                  if (!ok && context.mounted) showToast(context, l10n.locationErrorTitle);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calculate_outlined),
                title: Text(l10n.prayerMethod),
                subtitle: Text(l10n.calcMethodName(s.prayer.method.name)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => pickCalculationMethod(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.wb_sunny_outlined),
                title: Text(l10n.prayerMadhab),
                subtitle: Text(l10n.madhabName(s.prayer.madhab.name)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => pickMadhab(context, ref),
              ),
            ]),
            SectionHeader(title: l10n.notificationsTitle),
            group([
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined),
                title: Text(l10n.notificationsEnableAll),
                value: s.notifications.enabled.length == Prayer.obligatory.length,
                onChanged: (v) async {
                  final ok = await setAllPrayerNotifications(ref, on: v);
                  if (!ok && context.mounted) showToast(context, l10n.notificationsDenied);
                },
              ),
              for (final p in Prayer.obligatory)
                SwitchListTile(
                  title: Text(l10n.notificationForPrayer(l10n.prayerLabel(p))),
                  value: s.notifications.isOn(p),
                  onChanged: (v) async {
                    final ok = await setPrayerNotification(ref, p, on: v);
                    if (!ok && context.mounted) showToast(context, l10n.notificationsDenied);
                  },
                ),
            ]),
            SectionHeader(title: l10n.settingsTasbeeh),
            group([
              SwitchListTile(
                secondary: const Icon(Icons.vibration_rounded),
                title: Text(l10n.tasbeehVibration),
                value: s.tasbeeh.vibration,
                onChanged: (v) => notifier.setTasbeehSettings(s.tasbeeh.copyWith(vibration: v)),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.volume_up_outlined),
                title: Text(l10n.tasbeehSound),
                value: s.tasbeeh.sound,
                onChanged: (v) => notifier.setTasbeehSettings(s.tasbeeh.copyWith(sound: v)),
              ),
            ]),
            SectionHeader(title: l10n.settingsGeneral),
            group([
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: Text(l10n.hijriAdjustment),
                subtitle: Text(
                  s.hijriAdjustment == 0
                      ? l10n.hijriNoAdjustment
                      : l10n.hijriAdjustmentValue(s.hijriAdjustment > 0 ? '+${s.hijriAdjustment}' : '${s.hijriAdjustment}'),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.hijriCalendar),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: Text(l10n.featureAbout),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.about),
              ),
              ListTile(
                leading: const Icon(Icons.library_books_outlined),
                title: Text(l10n.featureSources),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.sources),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(l10n.settingsPrivacy),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.privacy),
              ),
              ListTile(
                leading: const Icon(Icons.verified_outlined),
                title: Text(l10n.settingsVersion),
                subtitle: Text(ref.watch(appVersionProvider).value ?? ''),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

