import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider_utils.dart';
import '../logger.dart';

/// Provider for [Logger]. Must be overridden in [ProviderScope].
final Provider<Logger> loggerProvider = Provider<Logger>(
  (Ref ref) => throwUnimplementedProviderError('loggerProvider'),
);
