import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/logging/logger.dart';
import 'package:sternburg_bingo_2/core/provider/riverpod_observer.dart';

final class _TestNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

void main() {
  const providerName = 'NotifierProvider<_TestNotifier, int>';

  String riverpodInfo(String msg) => 'INFO: [Riverpod] $msg';
  String riverpodError(String msg) => 'ERROR: [Riverpod] $msg';

  group('RiverpodObserver', () {
    (ProviderContainer, List<String>) createContainer({bool enabled = false}) {
      final logs = <String>[];
      final observer = RiverpodObserver(_TestLogger(logs), enabled: enabled);
      final container = ProviderContainer(observers: [observer]);
      return (container, logs);
    }

    test(
      'logs provider init, update, failure, and dispose events when enabled',
      () {
        final (container, logs) = createContainer(enabled: true);
        final counterProvider = NotifierProvider<_TestNotifier, int>(
          _TestNotifier.new,
        );

        // Add & read
        expect(container.read(counterProvider), 0);
        expect(logs, contains(riverpodInfo('Initialized: $providerName (0)')));

        // Update
        container.read(counterProvider.notifier).increment();
        expect(logs, contains(riverpodInfo('Updated: $providerName | 0 -> 1')));

        // Failure
        final failingProvider = Provider<int>(
          (ref) => throw Exception('Test error'),
        );
        expect(() => container.read(failingProvider), throwsException);
        expect(
          logs.any(
            (log) => log.contains(
              riverpodError('Failure in Provider<int>: Exception: Test error'),
            ),
          ),
          isTrue,
        );

        // Dispose
        container.dispose();
        expect(logs, contains(riverpodInfo('Disposed: $providerName')));
      },
    );

    test('does not log events when disabled', () {
      final (container, logs) = createContainer();
      final counterProvider = NotifierProvider<_TestNotifier, int>(
        _TestNotifier.new,
      );

      container.read(counterProvider);
      container.read(counterProvider.notifier).increment();
      container.dispose();

      expect(logs, isEmpty);
    });
  });
}

final class _TestLogger implements Logger {
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
