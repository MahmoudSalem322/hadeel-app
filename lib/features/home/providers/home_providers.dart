import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/hijri_date.dart';
import '../../../domain/entities/reading_progress.dart';
import '../../../services/hijri/hijri_converter.dart';
import '../../prayer/providers/prayer_providers.dart';

final hijriConverterProvider = Provider<HijriConverter>((ref) => const HijriConverter());

/// Today's Hijri date, following the location's calendar day.
final todayHijriProvider = Provider<HijriDate>((ref) {
  return ref.watch(hijriConverterProvider).fromGregorian(ref.watch(todayDateProvider));
});

/// Last reading position. Returns `null` until the Quran feature (Phase 4)
/// overrides it with real, locally stored progress — no placeholder data.
final readingProgressProvider = Provider<ReadingProgress?>((ref) => null);
