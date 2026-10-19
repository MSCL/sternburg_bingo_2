import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_utils.dart';
import 'haptic_service.dart';

/// Provider for [HapticService]. Must be overridden in [ProviderScope].
final Provider<HapticService> hapticServiceProvider = Provider<HapticService>(
  (Ref ref) => throwUnimplementedProviderError('hapticServiceProvider'),
);
