import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/providers/content_providers.dart';
import '../../../domain/entities/content.dart';
import '../../../domain/entities/geo.dart';
import '../../prayer/providers/prayer_providers.dart';

/// Today's selection from local, verified content. Deterministic per date,
/// so it is stable through the day and changes at midnight.
@immutable
class DailyContent {
  const DailyContent({required this.ayah, required this.dhikr, required this.hadith, required this.dua});

  /// A Quranic dua (rendered from the mushaf text).
  final QuranDua ayah;
  final DhikrItem dhikr;
  final Hadith hadith;
  final DhikrItem dua;
}

/// Picks an item for [date] from a list of [length] items.
int dailyIndex(CalendarDate date, int length, {int salt = 0}) {
  final days = DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  return (days + salt * 7) % length;
}

final dailyContentProvider = FutureProvider<DailyContent?>((ref) async {
  final date = ref.watch(todayDateProvider);
  final hisn = await ref.watch(hisnProvider.future);
  final hadith = await ref.watch(hadithLibraryProvider.future);

  final quranic = hisn.duaCategory('quranic')?.quranDuas ?? const [];
  final morning = hisn.adhkarCategory('morning_evening');
  final dhikrItems = morning == null ? const <DhikrItem>[] : hisn.itemsOf(morning);
  final duaItems = [
    for (final key in ['distress', 'tawbah', 'general', 'rizq'])
      if (hisn.duaCategory(key) case final c?) ...hisn.itemsOf(c),
  ];
  final nawawi = hadith.book('nawawi40')?.hadiths ?? const [];
  if (quranic.isEmpty || dhikrItems.isEmpty || duaItems.isEmpty || nawawi.isEmpty) return null;

  return DailyContent(
    ayah: quranic[dailyIndex(date, quranic.length)],
    dhikr: dhikrItems[dailyIndex(date, dhikrItems.length, salt: 1)],
    hadith: nawawi[dailyIndex(date, nawawi.length, salt: 2)],
    dua: duaItems[dailyIndex(date, duaItems.length, salt: 3)],
  );
});
