import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_utils.dart';
import 'app_info.dart';

/// Provider for [AppInfo]. Must be overridden in [ProviderScope].
final Provider<AppInfo> appInfoProvider = Provider<AppInfo>(
  (Ref ref) => throwUnimplementedProviderError('appInfoProvider'),
);
