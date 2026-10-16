import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/analytics/analytics_provider.dart';
import 'package:sternburg_bingo_2/core/storage/local_storage.dart';

import '../../fakes/fake_analytics_service.dart';
import '../../fakes/fake_local_storage.dart';

void main() {
  const String analyticsKey = 'analytics_enabled';

  (ProviderContainer, FakeAnalyticsService, FakeLocalStorage) createContainer({
    Map<String, Object>? initialStorage,
  }) {
    final FakeAnalyticsService analyticsService = FakeAnalyticsService();
    final FakeLocalStorage fakeStorage = FakeLocalStorage(initialStorage);
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        analyticsServiceProvider.overrideWithValue(analyticsService),
        localStorageProvider.overrideWithValue(fakeStorage),
      ],
    );
    addTearDown(container.dispose);
    return (container, analyticsService, fakeStorage);
  }

  group('AnalyticsEnabledNotifier', () {
    test('defaults to false when no saved preference exists', () {
      final (
        ProviderContainer container,
        FakeAnalyticsService analyticsService,
        _,
      ) = createContainer();

      expect(container.read(analyticsEnabledProvider), isFalse);
      expect(analyticsService.collectionEnabled, isFalse);
    });

    test('restores true from local storage on build', () {
      final (
        ProviderContainer container,
        FakeAnalyticsService analyticsService,
        _,
      ) = createContainer(
        initialStorage: <String, Object>{analyticsKey: true},
      );

      expect(container.read(analyticsEnabledProvider), isTrue);
      expect(analyticsService.collectionEnabled, isTrue);
    });

    test(
      'updates state, local storage, and analytics service when toggled',
      () async {
        final (
          ProviderContainer container,
          FakeAnalyticsService analyticsService,
          FakeLocalStorage fakeStorage,
        ) = createContainer();

        final AnalyticsEnabledNotifier notifier = container.read(
          analyticsEnabledProvider.notifier,
        );

        expect(container.read(analyticsEnabledProvider), isFalse);

        await notifier.setAnalyticsEnabled(enabled: true);

        expect(container.read(analyticsEnabledProvider), isTrue);
        expect(fakeStorage.getBool(analyticsKey), isTrue);
        expect(analyticsService.collectionEnabled, isTrue);

        await notifier.setAnalyticsEnabled(enabled: false);

        expect(container.read(analyticsEnabledProvider), isFalse);
        expect(fakeStorage.getBool(analyticsKey), isFalse);
        expect(analyticsService.collectionEnabled, isFalse);
      },
    );
  });
}
