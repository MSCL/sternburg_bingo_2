import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_logger.dart';

/// Provider exposing the active [AppLogger] initialized at app startup.
final appLoggerProvider = Provider<AppLogger>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope!');
});
