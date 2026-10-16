import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/logging/logger.dart';
import 'package:sternburg_bingo_2/core/logging/sentry_logger.dart';

void main() {
  group('Logger', () {
    test(
      'Logger implementations execute without errors',
      () => expect(() {
        const ConsoleLogger()
          ..info('Info')
          ..error('Error');
        const SentryLogger()
          ..info('Info')
          ..error('Error');
      }, returnsNormally),
    );
  });
}
