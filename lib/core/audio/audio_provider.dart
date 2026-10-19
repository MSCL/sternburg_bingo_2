import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_utils.dart';
import 'audio_service.dart';

/// Provider for [AudioService]. Must be overridden in [ProviderScope].
final Provider<AudioService> audioServiceProvider = Provider<AudioService>(
  (Ref ref) => throwUnimplementedProviderError('audioServiceProvider'),
);
