import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/logging/app_logger.dart';
import 'package:sternburg_bingo_2/core/logging/sentry_app_logger.dart';
import 'package:sternburg_bingo_2/core/provider/riverpod_observer.dart';

void main() {
  test('AppLogger implementations execute without errors', () {
    expect(() {
      const ConsoleAppLogger()
        ..info('Info')
        ..error('Error');
      const SentryAppLogger()
        ..info('Info')
        ..error('Error');
    }, returnsNormally);
  });

  test('RiverpodObserver logs provider lifecycle events when enabled', () {
    final logs = <String>[];
    final logger = _MockLogger(logs);
    final observer = RiverpodObserver(logger, enabled: true);

    final container = ProviderContainer(observers: [observer]);
    final provider = Provider((ref) => 'test');

    container.read(provider);
    expect(
      logs,
      contains('INFO: [Riverpod] Initialized: Provider<String> (test)'),
    );

    container.dispose();
    expect(logs, contains('INFO: [Riverpod] Disposed: Provider<String>'));
  });
}

class _MockLogger implements AppLogger {
  const new(this.logs);

  final List<String> logs;

  @override
  void info(String message, {String? tag}) => logs.add('INFO: [$tag] $message');

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) => logs.add('ERROR: [$tag] $message');
}
