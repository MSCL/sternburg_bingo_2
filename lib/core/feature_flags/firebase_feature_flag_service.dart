import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../logging/logger.dart';
import 'feature_flag.dart';
import 'feature_flag_service.dart';

final class FirebaseFeatureFlagService implements FeatureFlagService {
  new(FirebaseApp app, this._logger)
    : _remoteConfig = FirebaseRemoteConfig.instanceFor(app: app);

  final Logger _logger;
  final FirebaseRemoteConfig _remoteConfig;

  static const String _tag = 'FeatureFlag';

  @override
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );

    final Map<String, Object> defaultValues = <String, Object>{
      for (final FeatureFlag flag in FeatureFlag.values)
        flag.key: flag.defaultValue,
    };

    await _remoteConfig.setDefaults(defaultValues);
    await fetchAndActivate();
  }

  @override
  bool isEnabled(FeatureFlag flag) => _remoteConfig.getBool(flag.key);

  @override
  Future<bool> fetchAndActivate() async {
    try {
      return await _remoteConfig.fetchAndActivate();
    } on FirebaseException catch (e, stackTrace) {
      if (!e.isOfflineOrTimeout) {
        _logger.error(
          'Remote Config error [${e.code}]: ${e.message}',
          error: e,
          stackTrace: stackTrace,
          tag: _tag,
        );
      }
      return false;
    }
  }
}

extension FirebaseExceptionX on FirebaseException {
  static const Set<String> _offlineErrorCodes = <String>{
    'network-request-failed',
    'fetch-timeout',
  };

  /// Returns `true` if the exception is due to normal offline network
  /// conditions or timeouts.
  bool get isOfflineOrTimeout => _offlineErrorCodes.contains(code);
}
