import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/content_providers.dart';
import '../../../core/providers/core_providers.dart';
import '../../../domain/entities/content.dart';
import '../../../domain/entities/library.dart';
import '../../../domain/usecases/adhkar_counter.dart';
import '../../prayer/providers/prayer_providers.dart';

/// A category key is either a configured key (e.g. `morning_evening`) or
/// `c<chapterId>` for a single Hisn al-Muslim chapter.
ContentCategory? resolveAdhkarCategory(HisnLibrary lib, String key) {
  if (key.startsWith('c')) {
    final id = int.tryParse(key.substring(1));
    if (id != null && lib.chapter(id) != null) return ContentCategory(key: key, chapterIds: [id]);
  }
  return lib.adhkarCategory(key);
}

class AdhkarSessionState {
  const AdhkarSessionState({required this.items, required this.counter});

  final List<DhikrItem> items;
  final AdhkarCounter counter;

  DhikrItem get current => items[counter.index];
}

final adhkarSessionProvider =
    AsyncNotifierProvider.autoDispose.family<AdhkarSessionNotifier, AdhkarSessionState?, String>(
  AdhkarSessionNotifier.new,
);

/// Loads a category's adhkar with today's saved position, and persists each
/// step so the user can pick up where they left off (until the day ends).
class AdhkarSessionNotifier extends AsyncNotifier<AdhkarSessionState?> {
  AdhkarSessionNotifier(this.categoryKey);

  final String categoryKey;

  @override
  Future<AdhkarSessionState?> build() async {
    final lib = await ref.watch(hisnProvider.future);
    final category = resolveAdhkarCategory(lib, categoryKey);
    if (category == null) return null;
    final items = lib.itemsOf(category);
    if (items.isEmpty) return null;

    final repeats = [for (final i in items) i.repeat];
    final saved = await ref
        .read(libraryRepositoryProvider)
        .loadAdhkarSession(categoryKey, ref.read(todayDateProvider));
    final counter = saved == null
        ? AdhkarCounter(repeats: repeats)
        : AdhkarCounter.restore(repeats, index: saved.itemIndex, count: saved.count);
    return AdhkarSessionState(items: items, counter: counter);
  }

  void tap() => _update((c) => c.tap());
  void next() => _update((c) => c.next());
  void previous() => _update((c) => c.previous());
  void goTo(int index) => _update((c) => c.goTo(index));
  void resetItem() => _update((c) => c.resetItem());
  void restart() => _update((c) => c.restart());

  void _update(AdhkarCounter Function(AdhkarCounter) change) {
    final current = state.value;
    if (current == null) return;
    final counter = change(current.counter);
    if (counter == current.counter) return;
    state = AsyncData(AdhkarSessionState(items: current.items, counter: counter));
    unawaited(
      ref.read(libraryRepositoryProvider).saveAdhkarSession(
            AdhkarSession(
              categoryKey: categoryKey,
              itemIndex: counter.completed ? counter.total : counter.index,
              count: counter.count,
            ),
            ref.read(todayDateProvider),
          ),
    );
  }
}
