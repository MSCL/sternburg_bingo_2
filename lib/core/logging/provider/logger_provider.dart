import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logger.dart';

final loggerProvider = Provider<Logger>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope!');
});
