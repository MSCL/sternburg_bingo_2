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
  const String routeAName = 'RouteA';
  const String routeBName = 'RouteB';
  const String tabAName = 'TabA';
  const String tabBName = 'TabB';

  String navInfo(String msg) => 'INFO: [Navigation] $msg';

  group('NavigationObserver', () {
    final PageRouteBuilder<dynamic> routeA = PageRouteBuilder<dynamic>(
      settings: const RouteSettings(name: routeAName),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => const SizedBox(),
    );
    final PageRouteBuilder<dynamic> routeB = PageRouteBuilder<dynamic>(
      settings: const RouteSettings(name: routeBName),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => const SizedBox(),
    );

    (NavigationObserver, List<String>) createObserver({bool enabled = false}) {
      final List<String> logs = <String>[];
      final NavigationObserver observer = NavigationObserver(
        _TestLogger(logs),
        enabled: enabled,
      );
      return (observer, logs);
    }

    test(
      'logs navigation push, pop, replace, and remove events when enabled',
      () {
        final (NavigationObserver observer, List<String> logs) = createObserver(
          enabled: true,
        );

        observer
          ..didPush(routeA, null)
          ..didPop(routeA, null)
          ..didReplace(newRoute: routeB, oldRoute: routeA)
          ..didRemove(routeB, routeA);

        expect(logs, <String>[
          navInfo('Push: $routeAName'),
          navInfo('Pop: $routeAName'),
          navInfo('Replace: $routeAName -> $routeBName'),
          navInfo('Remove: $routeBName'),
        ]);
      },
    );

    test('logs tab route navigation events when enabled', () {
      final (NavigationObserver observer, List<String> logs) = createObserver(
        enabled: true,
      );

      final _FakeTabPageRoute tabA = _FakeTabPageRoute(tabAName);
      final _FakeTabPageRoute tabB = _FakeTabPageRoute(tabBName);

      observer
        ..didInitTabRoute(tabA, null)
        ..didChangeTabRoute(tabB, tabA);

      expect(logs, <String>[
        navInfo('InitTabRoute: $tabAName'),
        navInfo('ChangeTabRoute: $tabAName -> $tabBName'),
      ]);
    });

    test('does not log any navigation events when disabled', () {
      final (NavigationObserver observer, List<String> logs) = createObserver();
      final _FakeTabPageRoute tabA = _FakeTabPageRoute(tabAName);

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
