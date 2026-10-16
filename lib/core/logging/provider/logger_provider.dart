import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logger.dart';

final Provider<Logger> loggerProvider = Provider<Logger>((Ref ref) {
  throw UnimplementedError('Must be overridden in ProviderScope!');
});
