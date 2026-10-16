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
  const String providerName = 'NotifierProvider<_TestNotifier, int>';

  String riverpodInfo(String msg) => 'INFO: [Riverpod] $msg';
  String riverpodError(String msg) => 'ERROR: [Riverpod] $msg';

  group('RiverpodObserver', () {
    (ProviderContainer, List<String>) createContainer({bool enabled = false}) {
      final List<String> logs = <String>[];
      final RiverpodObserver observer = RiverpodObserver(
        _TestLogger(logs),
        enabled: enabled,
      );
      final ProviderContainer container = ProviderContainer(
        observers: <ProviderObserver>[observer],
      );
      return (container, logs);
    }

    test(
      'logs provider init, update, failure, and dispose events when enabled',
      () {
        final (ProviderContainer container, List<String> logs) =
            createContainer(enabled: true);
        final NotifierProvider<_TestNotifier, int> counterProvider =
            NotifierProvider<_TestNotifier, int>(_TestNotifier.new);

        // Add & read
        expect(container.read(counterProvider), 0);
        expect(logs, contains(riverpodInfo('Initialized: $providerName (0)')));

        // Update
        container.read(counterProvider.notifier).increment();
        expect(logs, contains(riverpodInfo('Updated: $providerName | 0 -> 1')));

        // Failure
        final Provider<int> failingProvider = Provider<int>(
          (Ref ref) => throw Exception('Test error'),
        );
        expect(() => container.read(failingProvider), throwsException);
        expect(
          logs.any(
            (String log) => log.contains(
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
      final (ProviderContainer container, List<String> logs) =
          createContainer();
      final NotifierProvider<_TestNotifier, int> counterProvider =
          NotifierProvider<_TestNotifier, int>(_TestNotifier.new);

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
