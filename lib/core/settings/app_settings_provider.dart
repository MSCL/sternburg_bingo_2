import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_utils.dart';
import 'app_settings_service.dart';

/// Provider for [AppSettingsService]. Must be overridden in [ProviderScope].
final Provider<AppSettingsService> appSettingsServiceProvider =
    Provider<AppSettingsService>(
      (Ref ref) =>
          throwUnimplementedProviderError('appSettingsServiceProvider'),
    );
