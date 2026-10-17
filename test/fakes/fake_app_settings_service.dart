import 'package:sternburg_bingo_2/core/settings/app_settings_service.dart';

final class FakeAppSettingsService implements AppSettingsService {
  new();

  bool notificationSettingsOpened = false;
  bool languageSettingsOpened = false;

  @override
  Future<void> openNotificationSettings() async {
    notificationSettingsOpened = true;
  }

  @override
  Future<void> openLanguageSettings() async {
    languageSettingsOpened = true;
  }
}
