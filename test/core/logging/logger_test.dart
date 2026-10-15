import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/logging/logger.dart';
import 'package:sternburg_bingo_2/core/logging/sentry_logger.dart';
import 'package:sternburg_bingo_2/core/provider/riverpod_observer.dart';
import 'package:sternburg_bingo_2/core/router/navigation_observer.dart';

void main() {
  test('Logger implementations execute without errors', () {
    expect(() {
      const ConsoleLogger()
        ..info('Info')
        ..error('Error');
      const SentryLogger()
        ..info('Info')
        ..error('Error');
    }, returnsNormally);
  });

  test('RiverpodObserver logs provider events when enabled', () {
    final logs = <String>[];
    final observer = RiverpodObserver(_TestLogger(logs), enabled: true);

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

  test('NavigationObserver logs navigation events when enabled', () {
    final logs = <String>[];
    final observer = NavigationObserver(_TestLogger(logs), enabled: true);

    final route = PageRouteBuilder<dynamic>(
      settings: const RouteSettings(name: 'RouteA'),
      pageBuilder: (_, __, ___) => const SizedBox(),
    );

    observer.didPush(route, null);
    expect(logs, contains('INFO: [Navigation] Push: RouteA'));

    observer.didPop(route, null);
    expect(logs, contains('INFO: [Navigation] Pop: RouteA'));
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
