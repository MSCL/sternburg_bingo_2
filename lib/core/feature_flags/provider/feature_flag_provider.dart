import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../provider/provider_utils.dart';
import '../feature_flag.dart';
import '../feature_flag_service.dart';

/// Provider for [FeatureFlagService]. Must be overridden in [ProviderScope].
final Provider<FeatureFlagService> featureFlagServiceProvider =
    Provider<FeatureFlagService>(
      (Ref ref) =>
          throwUnimplementedProviderError('featureFlagServiceProvider'),
    );

final ProviderFamily<bool, FeatureFlag> _featureFlagProvider =
    Provider.family<bool, FeatureFlag>(
      (Ref ref, FeatureFlag flag) =>
          ref.watch(featureFlagServiceProvider).isEnabled(flag),
    );

extension FeatureFlagX on FeatureFlag {
  /// Returns whether this feature flag is enabled for a [WidgetRef] or [Ref].
  bool isEnabled(Object ref) {
    if (ref is WidgetRef) {
      return ref.watch(_featureFlagProvider(this));
    }
    if (ref is Ref) {
      return ref.watch(_featureFlagProvider(this));
    }
    throw ArgumentError('ref must be either WidgetRef or Ref');
  }
}
