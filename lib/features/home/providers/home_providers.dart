import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/hijri_date.dart';
import '../../../services/hijri/hijri_converter.dart';
import '../../prayer/providers/prayer_providers.dart';

final hijriConverterProvider = Provider<HijriConverter>((ref) => const HijriConverter());

/// Today's Hijri date, following the location's calendar day.
final todayHijriProvider = Provider<HijriDate>((ref) {
  return ref.watch(hijriConverterProvider).fromGregorian(ref.watch(todayDateProvider));
});
