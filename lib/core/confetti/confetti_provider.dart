import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_utils.dart';
import 'confetti_service.dart';

/// Provider for [ConfettiService]. Must be overridden in [ProviderScope].
final Provider<ConfettiService> confettiServiceProvider =
    Provider<ConfettiService>(
      (Ref ref) => throwUnimplementedProviderError('confettiServiceProvider'),
    );
