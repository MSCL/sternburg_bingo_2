import 'package:flutter/widgets.dart';
import 'package:sternburg_bingo_2/core/confetti/confetti_service.dart';

/// In-memory [ConfettiService] fake for testing.
final class FakeConfettiService implements ConfettiService {
  new();

  int launchCount = 0;

  @override
  void launch(BuildContext context) => launchCount++;
}
