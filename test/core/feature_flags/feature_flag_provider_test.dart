import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/feature_flags/feature_flag.dart';
import 'package:sternburg_bingo_2/core/feature_flags/feature_flag_provider.dart';

import '../../fakes/fake_feature_flag_service.dart';

void main() {
  group('FeatureFlagX extension', () {
    test('reads boolean flag fluently using Ref inside a Provider', () {
      final FakeFeatureFlagService service = FakeFeatureFlagService(
        <FeatureFlag, bool>{FeatureFlag.enableNewBingoLayout: true},
      );

      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          featureFlagServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      final Provider<bool> testProvider = Provider<bool>(
        (Ref ref) => FeatureFlag.enableNewBingoLayout.isEnabled(ref),
      );

      expect(container.read(testProvider), isTrue);
    });

    test('throws ArgumentError if ref is neither WidgetRef nor Ref', () {
      expect(
        () => FeatureFlag.enableNewBingoLayout.isEnabled('invalidRef'),
        throwsArgumentError,
      );
    });
  });
}
