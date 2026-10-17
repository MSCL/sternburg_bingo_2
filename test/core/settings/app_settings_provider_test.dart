import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/settings/app_settings_provider.dart';
import 'package:sternburg_bingo_2/core/settings/app_settings_service.dart';

import '../../fakes/fake_app_settings_service.dart';

void main() {
  group('appSettingsServiceProvider', () {
    test(
      'provides app settings service and invokes methods correctly',
      () async {
        final FakeAppSettingsService settingsService = FakeAppSettingsService();
        final ProviderContainer container = ProviderContainer(
          overrides: <Override>[
            appSettingsServiceProvider.overrideWithValue(settingsService),
          ],
        );
        addTearDown(container.dispose);

        final AppSettingsService service = container.read(
          appSettingsServiceProvider,
        );

        await service.openNotificationSettings();
        expect(settingsService.notificationSettingsOpened, isTrue);

        await service.openLanguageSettings();
        expect(settingsService.languageSettingsOpened, isTrue);
      },
    );
  });
}
