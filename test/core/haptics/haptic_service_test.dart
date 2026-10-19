import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/haptics/haptic_provider.dart';
import 'package:sternburg_bingo_2/core/haptics/haptic_service.dart';

import '../../fakes/fake_haptic_service.dart';

void main() {
  group('HapticService', () {
    test('hapticServiceProvider provides registered HapticService', () async {
      final FakeHapticService fakeHaptic = FakeHapticService();
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          hapticServiceProvider.overrideWithValue(fakeHaptic),
        ],
      );
      addTearDown(container.dispose);

      final HapticService haptic = container.read(hapticServiceProvider);
      await haptic.heavyImpact();

      expect(fakeHaptic.heavyImpactCount, equals(1));
    });
  });
}
