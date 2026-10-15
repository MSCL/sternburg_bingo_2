import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/logging/logger.dart';
import 'package:sternburg_bingo_2/core/router/navigation_observer.dart';

final class _FakeTabPageRoute extends Fake implements TabPageRoute {
  new(this.name);

  @override
  final String name;
}

void main() {
  const routeAName = 'RouteA';
  const routeBName = 'RouteB';
  const tabAName = 'TabA';
  const tabBName = 'TabB';

  String navInfo(String msg) => 'INFO: [Navigation] $msg';

  group('NavigationObserver', () {
    final routeA = PageRouteBuilder<dynamic>(
      settings: const RouteSettings(name: routeAName),
      pageBuilder: (_, __, ___) => const SizedBox(),
    );
    final routeB = PageRouteBuilder<dynamic>(
      settings: const RouteSettings(name: routeBName),
      pageBuilder: (_, __, ___) => const SizedBox(),
    );

    (NavigationObserver, List<String>) createObserver({bool enabled = false}) {
      final logs = <String>[];
      final observer = NavigationObserver(_TestLogger(logs), enabled: enabled);
      return (observer, logs);
    }

    test(
      'logs navigation push, pop, replace, and remove events when enabled',
      () {
        final (observer, logs) = createObserver(enabled: true);

        observer
          ..didPush(routeA, null)
          ..didPop(routeA, null)
          ..didReplace(newRoute: routeB, oldRoute: routeA)
          ..didRemove(routeB, routeA);

        expect(logs, [
          navInfo('Push: $routeAName'),
          navInfo('Pop: $routeAName'),
          navInfo('Replace: $routeAName -> $routeBName'),
          navInfo('Remove: $routeBName'),
        ]);
      },
    );

    test('logs tab route navigation events when enabled', () {
      final (observer, logs) = createObserver(enabled: true);

      final tabA = _FakeTabPageRoute(tabAName);
      final tabB = _FakeTabPageRoute(tabBName);

      observer
        ..didInitTabRoute(tabA, null)
        ..didChangeTabRoute(tabB, tabA);

      expect(logs, [
        navInfo('InitTabRoute: $tabAName'),
        navInfo('ChangeTabRoute: $tabAName -> $tabBName'),
      ]);
    });

    test('does not log any navigation events when disabled', () {
      final (observer, logs) = createObserver();
      final tabA = _FakeTabPageRoute(tabAName);

      observer
        ..didPush(routeA, null)
        ..didPop(routeA, null)
        ..didReplace(newRoute: routeB, oldRoute: routeA)
        ..didRemove(routeB, routeA)
        ..didInitTabRoute(tabA, null);

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
