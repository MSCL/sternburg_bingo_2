import 'feature_flag.dart';

abstract interface class FeatureFlagService {
  Future<void> initialize();

  bool isEnabled(FeatureFlag flag);
}
