import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_utils.dart';
import 'push_notification_service.dart';

/// Provider for [PushNotificationService]. Must be overridden in
/// [ProviderScope].
final Provider<PushNotificationService> pushNotificationServiceProvider =
    Provider<PushNotificationService>(
      (Ref ref) =>
          throwUnimplementedProviderError('pushNotificationServiceProvider'),
    );

final FutureProvider<bool> isNotificationPermissionGrantedProvider =
    FutureProvider<bool>(
      (Ref ref) =>
          ref.watch(pushNotificationServiceProvider).isPermissionGranted(),
    );
