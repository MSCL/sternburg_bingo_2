import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../logging/logger.dart';
import 'push_notification_service.dart';

/// No notifications are shown when the app is in the foreground when
/// receiving them. Android devices without Google Play Services are not
/// supported (e.g. Huawei).
final class FirebasePushNotificationService implements PushNotificationService {
  new(FirebaseApp _, Logger _) : _messaging = FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  @override
  Future<bool> requestPermission() async =>
      (await _messaging.requestPermission()).isGranted;

  @override
  Future<bool> isPermissionGranted() async =>
      (await _messaging.getNotificationSettings()).isGranted;

  @override
  Future<void> openNotificationSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.notification);
}

extension on NotificationSettings {
  bool get isGranted =>
      authorizationStatus == AuthorizationStatus.authorized ||
      authorizationStatus == AuthorizationStatus.provisional;
}
