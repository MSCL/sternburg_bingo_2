import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_utils.dart';
import 'splash_service.dart';

/// Provider for [SplashService]. Must be overridden in [ProviderScope].
final Provider<SplashService> splashServiceProvider = Provider<SplashService>(
  (Ref ref) => throwUnimplementedProviderError('splashServiceProvider'),
);
