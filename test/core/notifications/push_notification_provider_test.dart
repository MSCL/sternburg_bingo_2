import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/notifications/push_notification_provider.dart';

import '../../fakes/fake_push_notification_service.dart';

void main() {
  group('isNotificationPermissionGrantedProvider', () {
    test('returns true when permission is granted', () async {
      final FakePushNotificationService pushService =
          FakePushNotificationService(isGranted: true);
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          pushNotificationServiceProvider.overrideWithValue(pushService),
        ],
      );
      addTearDown(container.dispose);

      final bool isGranted = await container.read(
        isNotificationPermissionGrantedProvider.future,
      );
      expect(isGranted, isTrue);
    });

    test('returns false when permission is not granted', () async {
      final FakePushNotificationService pushService =
          FakePushNotificationService();
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          pushNotificationServiceProvider.overrideWithValue(pushService),
        ],
      );
      addTearDown(container.dispose);

      final bool isGranted = await container.read(
        isNotificationPermissionGrantedProvider.future,
      );
      expect(isGranted, isFalse);
    });
  });
}
