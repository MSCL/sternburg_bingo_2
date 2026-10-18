import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/analytics/analytics_provider.dart';
import 'package:sternburg_bingo_2/core/feature_flags/feature_flag_provider.dart';
import 'package:sternburg_bingo_2/core/info/app_info.dart';
import 'package:sternburg_bingo_2/core/info/package_info_provider.dart';
import 'package:sternburg_bingo_2/core/init/app_initializer.dart';
import 'package:sternburg_bingo_2/core/logging/logger_provider.dart';
import 'package:sternburg_bingo_2/core/notifications/push_notification_provider.dart';
import 'package:sternburg_bingo_2/core/settings/app_settings_provider.dart';
import 'package:sternburg_bingo_2/core/splash/splash_provider.dart';
import 'package:sternburg_bingo_2/core/splash/splash_service.dart';
import 'package:sternburg_bingo_2/core/storage/local_storage.dart';

import '../../fakes/fake_analytics_service.dart';
import '../../fakes/fake_app_settings_service.dart';
import '../../fakes/fake_feature_flag_service.dart';
import '../../fakes/fake_local_storage.dart';
import '../../fakes/fake_logger.dart';
import '../../fakes/fake_push_notification_service.dart';

final class _FakeSplashService implements SplashService {
  const new();

  @override
  void preserve({required WidgetsBinding widgetsBinding}) {}

  @override
  void remove() {}
}

void main() {
  group('AppDependencies', () {
    test(
      'toProviderOverrides creates valid overrides for all core services',
      () {
        final FakeLogger logger = FakeLogger();
        final FakeAnalyticsService analyticsService = FakeAnalyticsService();
        final FakeFeatureFlagService featureFlagService =
            FakeFeatureFlagService();
        final FakePushNotificationService pushNotificationService =
            FakePushNotificationService();
        final FakeLocalStorage localStorage = FakeLocalStorage();
        const _FakeSplashService splashService = _FakeSplashService();
        const AppInfo appInfo = AppInfo(
          appName: 'TestApp',
          version: '1.0.0',
          buildNumber: '1',
        );
        final FakeAppSettingsService appSettingsService =
            FakeAppSettingsService();

        final AppDependencies dependencies = AppDependencies(
          logger: logger,
          analyticsService: analyticsService,
          featureFlagService: featureFlagService,
          pushNotificationService: pushNotificationService,
          localStorage: localStorage,
          splashService: splashService,
          appInfo: appInfo,
          appSettingsService: appSettingsService,
        );

        final ProviderContainer container = ProviderContainer(
          overrides: dependencies.toProviderOverrides(),
        );
        addTearDown(container.dispose);

        expect(container.read(loggerProvider), logger);
        expect(container.read(analyticsServiceProvider), analyticsService);
        expect(container.read(featureFlagServiceProvider), featureFlagService);
        expect(
          container.read(pushNotificationServiceProvider),
          pushNotificationService,
        );
        expect(container.read(localStorageProvider), localStorage);
        expect(container.read(splashServiceProvider), splashService);
        expect(container.read(appInfoProvider), appInfo);
        expect(container.read(appSettingsServiceProvider), appSettingsService);
      },
    );
  });
}
