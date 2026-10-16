import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_utils.dart';
import '../storage/local_storage.dart';
import 'analytics_service.dart';

/// Provider for [AnalyticsService]. Must be overridden in [ProviderScope].
final Provider<AnalyticsService> analyticsServiceProvider =
    Provider<AnalyticsService>(
      (Ref ref) => throwUnimplementedProviderError('analyticsServiceProvider'),
    );

final NotifierProvider<AnalyticsEnabledNotifier, bool>
analyticsEnabledProvider = NotifierProvider<AnalyticsEnabledNotifier, bool>(
  AnalyticsEnabledNotifier.new,
);

final class AnalyticsEnabledNotifier extends Notifier<bool> {
  static const String _analyticsEnabledKey = 'analytics_enabled';

  @override
  bool build() {
    final bool? savedEnabled = ref
        .read(localStorageProvider)
        .getBool(_analyticsEnabledKey);
    final bool isEnabled = savedEnabled ?? false;
    unawaited(
      ref
          .read(analyticsServiceProvider)
          .setAnalyticsCollectionEnabled(enabled: isEnabled),
    );
    return isEnabled;
  }

  Future<void> setAnalyticsEnabled({required bool enabled}) async {
    state = enabled;
    await Future.wait<void>(<Future<void>>[
      ref
          .read(localStorageProvider)
          .setBool(_analyticsEnabledKey, value: enabled),
      ref
          .read(analyticsServiceProvider)
          .setAnalyticsCollectionEnabled(enabled: enabled),
    ]);
  }
}
