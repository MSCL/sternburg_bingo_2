abstract interface class PushNotificationService {
  Future<void> requestPermission();

  Future<bool> isPermissionGranted();
}
