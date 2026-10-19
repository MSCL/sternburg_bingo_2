import 'package:sternburg_bingo_2/core/haptics/haptic_service.dart';

/// In-memory [HapticService] implementation for unit and widget tests.
final class FakeHapticService implements HapticService {
  new();

  int heavyImpactCount = 0;

  @override
  Future<void> heavyImpact() async => heavyImpactCount++;
}
