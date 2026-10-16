import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/analytics/analytics_service.dart';
import 'package:sternburg_bingo_2/core/analytics/provider/analytics_provider.dart';
import 'package:sternburg_bingo_2/core/storage/local_storage.dart';

final class _TestAnalyticsService implements AnalyticsService {
  new();

  bool? collectionEnabled;
  final List<String> loggedEvents = <String>[];
  final List<String> screens = <String>[];

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    loggedEvents.add(name);
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    screens.add(screenName);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setAnalyticsCollectionEnabled({required bool enabled}) async {
    collectionEnabled = enabled;
  }
}

final class _FakeLocalStorage implements LocalStorage {
  new([Map<String, Object>? initialData])
    : _data = <String, Object>{...?initialData};

  final Map<String, Object> _data;

  @override
  String? getString(String key) {
    final Object? val = _data[key];
    return val is String ? val : null;
  }

  @override
  Future<void> setString(String key, String value) async => _data[key] = value;

  @override
  bool? getBool(String key) {
    final Object? val = _data[key];
    return val is bool ? val : null;
  }

  @override
  Future<void> setBool(String key, {required bool value}) async =>
      _data[key] = value;
}

void main() {
  const String analyticsKey = 'analytics_enabled';

  (ProviderContainer, _TestAnalyticsService, _FakeLocalStorage)
  createContainer({Map<String, Object>? initialStorage}) {
    final _TestAnalyticsService analyticsService = _TestAnalyticsService();
    final _FakeLocalStorage fakeStorage = _FakeLocalStorage(initialStorage);
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
        _TestAnalyticsService analyticsService,
        _,
      ) = createContainer();

      expect(container.read(analyticsEnabledProvider), isFalse);
      expect(analyticsService.collectionEnabled, isFalse);
    });

    test('restores true from local storage on build', () {
      final (
        ProviderContainer container,
        _TestAnalyticsService analyticsService,
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
          _TestAnalyticsService analyticsService,
          _FakeLocalStorage fakeStorage,
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
