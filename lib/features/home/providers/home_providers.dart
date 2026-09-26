import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/hijri_date.dart';
import '../../../services/hijri/hijri_converter.dart';
import '../../prayer/providers/prayer_providers.dart';
import '../../settings/providers/settings_provider.dart';

/// Umm al-Qura conversion, shifted by the user's moon-sighting adjustment.
final hijriConverterProvider = Provider<HijriConverter>(
  (ref) => HijriConverter(dayAdjustment: ref.watch(settingsProvider.select((s) => s.hijriAdjustment))),
);

/// Today's Hijri date, following the location's calendar day.
final todayHijriProvider = Provider<HijriDate>((ref) {
  return ref.watch(hijriConverterProvider).fromGregorian(ref.watch(todayDateProvider));
});
