import 'package:flutter/services.dart';

abstract interface class HapticService {
  Future<void> heavyImpact();
}

final class SystemHapticService implements HapticService {
  const new();

  @override
  Future<void> heavyImpact() => HapticFeedback.heavyImpact();
}
