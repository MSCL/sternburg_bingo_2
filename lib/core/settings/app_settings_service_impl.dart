import 'dart:async';

import 'package:app_settings/app_settings.dart';

import 'app_settings_service.dart';

final class AppSettingsServiceImpl implements AppSettingsService {
  const new();

  @override
  Future<void> openNotificationSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.notification);

  @override
  Future<void> openLanguageSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.appLocale);
}
