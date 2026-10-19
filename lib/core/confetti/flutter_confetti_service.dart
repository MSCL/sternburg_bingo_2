import 'package:flutter/widgets.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

import 'confetti_service.dart';

final class FlutterConfettiService implements ConfettiService {
  const new();

  @override
  void launch(BuildContext context) => Confetti.launch(
    context,
    options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
  );
}
