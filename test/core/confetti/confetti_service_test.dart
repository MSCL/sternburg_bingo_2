import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/confetti/confetti_provider.dart';
import 'package:sternburg_bingo_2/core/confetti/confetti_service.dart';

import '../../fakes/fake_confetti_service.dart';

void main() {
  group('ConfettiService', () {
    test('confettiServiceProvider provides registered ConfettiService', () {
      final FakeConfettiService fakeConfetti = FakeConfettiService();
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          confettiServiceProvider.overrideWithValue(fakeConfetti),
        ],
      );
      addTearDown(container.dispose);

      final ConfettiService confetti = container.read(confettiServiceProvider);
      expect(confetti, equals(fakeConfetti));
    });
  });
}
