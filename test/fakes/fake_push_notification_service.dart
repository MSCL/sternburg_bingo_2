import 'package:sternburg_bingo_2/core/notifications/push_notification_service.dart';

final class FakePushNotificationService implements PushNotificationService {
  new({this._isGranted = false});

  final bool _isGranted;
  bool requestPermissionCalled = false;

  @override
  Future<bool> requestPermission() async {
    requestPermissionCalled = true;
    return _isGranted;
  }

  @override
  Future<bool> isPermissionGranted() async => _isGranted;
}
