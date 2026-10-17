abstract interface class PushNotificationService {
  Future<bool> requestPermission();

  Future<bool> isPermissionGranted();

  Future<void> openNotificationSettings();
}
