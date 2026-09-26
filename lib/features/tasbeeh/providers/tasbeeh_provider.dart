import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../domain/entities/library.dart';
import '../../../domain/repositories/library_repository.dart';
import '../../settings/providers/settings_provider.dart';

final tasbeehProvider = AsyncNotifierProvider.autoDispose<TasbeehNotifier, TasbeehCounter>(TasbeehNotifier.new);

/// Counter for the selected phrase. Every tap updates instantly; writes to
/// the database are debounced and flushed when the screen closes.
class TasbeehNotifier extends AsyncNotifier<TasbeehCounter> {
  static const Duration saveDelay = Duration(milliseconds: 500);

  Timer? _saveTimer;
  TasbeehCounter? _unsaved;
  late LibraryRepository _repo;

  @override
  Future<TasbeehCounter> build() async {
    _repo = ref.read(libraryRepositoryProvider);
    ref.onDispose(flush);
    final phrase = ref.watch(settingsProvider.select((s) => s.tasbeeh.phraseKey));
    return _repo.loadTasbeeh(phrase);
  }

  void increment() => _set((c) => c.increment());
  void reset() => _set((c) => c.reset());
  void setTarget(int target) => _set((c) => c.withTarget(target));

  Future<void> selectPhrase(String key) async {
    flush();
    final settings = ref.read(settingsProvider).tasbeeh;
    await ref.read(settingsProvider.notifier).setTasbeehSettings(settings.copyWith(phraseKey: key));
  }

  void _set(TasbeehCounter Function(TasbeehCounter) change) {
    final current = state.value;
    if (current == null) return;
    final next = change(current);
    state = AsyncData(next);
    _unsaved = next;
    _saveTimer?.cancel();
    _saveTimer = Timer(saveDelay, flush);
  }

  void flush() {
    _saveTimer?.cancel();
    _saveTimer = null;
    final pending = _unsaved;
    if (pending == null) return;
    _unsaved = null;
    unawaited(_repo.saveTasbeeh(pending));
  }
}
