import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeel/core/providers/core_providers.dart';
import 'package:hadeel/core/utils/clock.dart';
import 'package:hadeel/data/local/preferences_store.dart';
import 'package:hadeel/data/repositories/settings_repository_impl.dart';
import 'package:hadeel/domain/entities/app_settings.dart';
import 'package:hadeel/domain/entities/prayer.dart';
import 'package:hadeel/features/prayer/providers/notification_providers.dart';
import 'package:hadeel/services/notifications/notification_service.dart';
import '../helpers/test_harness.dart';

class _Capture extends FakeNotificationService {
  final ready = Completer<List<NotificationRequest>>();
  @override
  Future<void> replaceAll(List<NotificationRequest> requests) async {
    await super.replaceAll(requests);
    if (!ready.isCompleted) ready.complete(requests);
  }
}

void main() {
  setUpAll(initTestEnvironment);
  test('reminders schedule in device timezone without a prayer city', () async {
    final store = await openTestStore();
    final service = _Capture();
    final container = ProviderContainer(overrides: [
      preferencesStoreProvider.overrideWithValue(store),
      citiesProvider.overrideWithValue(loadBundledCities()),
      clockProvider.overrideWithValue(ManualClock(DateTime.utc(2026, 10, 10, 3))),
      notificationServiceProvider.overrideWithValue(service),
      deviceTimezoneServiceProvider.overrideWithValue(const FakeTimezoneService('Asia/Riyadh')),
      contentRepositoryProvider.overrideWithValue(const FileContentRepository()),
    ]);
    addTearDown(container.dispose);
    container.read(prayerNotificationSyncProvider);
    final requests = await service.ready.future.timeout(const Duration(seconds: 3));
    expect(requests.where((r) => r.id >= 3000 && r.id < 4000).length, 18);
    expect(requests.any((r) => r.id >= 4000), isTrue);
    expect(requests.every((r) => r.zone == 'Asia/Riyadh'), isTrue);
    expect(requests.first.time.hour, 7);
    expect(requests.first.time.toUtc().hour, 4);
    final sources = loadHadithLibrary().books.expand((b) => b.hadiths).map((h) => h.text).toSet();
    expect(requests.where((r) => r.id >= 4000 && (r.id - 4000) % 3 == 1).every((r) => sources.contains(r.body)), isTrue);
  });
  test('reminder preferences survive restart and prayer switches', () async {
    final store = await openTestStore();
    final repo = SettingsRepositoryImpl(store);
    const disabled = NotificationSettings(hourlyDhikr: false, dailyContent: false);
    await repo.saveNotificationSettings(disabled.toggled(Prayer.fajr, on: true));
    final loaded = SettingsRepositoryImpl(store).load().notifications;
    expect(loaded.hourlyDhikr, isFalse);
    expect(loaded.dailyContent, isFalse);
    expect(loaded.enabled, {Prayer.fajr});
    expect(loaded.withHourlyDhikr(true).dailyContent, isFalse);
    expect(loaded.withDailyContent(true).hourlyDhikr, isFalse);
    expect(store.getBool(PreferencesStore.keyNotifyDailyContent), isFalse);
  });
}
