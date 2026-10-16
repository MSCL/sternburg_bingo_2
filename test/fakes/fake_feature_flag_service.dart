import 'package:sternburg_bingo_2/core/feature_flags/feature_flag.dart';
import 'package:sternburg_bingo_2/core/feature_flags/feature_flag_service.dart';

/// In-memory [FeatureFlagService] implementation for unit and widget tests.
final class FakeFeatureFlagService implements FeatureFlagService {
  new([Map<FeatureFlag, bool>? overrides])
    : _enabledFlags = overrides ?? <FeatureFlag, bool>{};

  final Map<FeatureFlag, bool> _enabledFlags;
  bool isInitialized = false;

  @override
  Future<void> initialize() async => isInitialized = true;

  @override
  bool isEnabled(FeatureFlag flag) => _enabledFlags[flag] ?? flag.defaultValue;
}
