import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/router/navigation_observer.dart';

import '../../fakes/fake_analytics_service.dart';
import '../../fakes/fake_logger.dart';

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
    final PageRouteBuilder<Object?> routeA = PageRouteBuilder<Object?>(
      settings: const RouteSettings(name: routeAName),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => const SizedBox(),
    );
    final PageRouteBuilder<Object?> routeB = PageRouteBuilder<Object?>(
      settings: const RouteSettings(name: routeBName),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => const SizedBox(),
    );

    (NavigationObserver, FakeLogger, FakeAnalyticsService) createObserver({
      bool enabled = false,
    }) {
      final FakeLogger logger = FakeLogger();
      final FakeAnalyticsService analyticsService = FakeAnalyticsService();
      final NavigationObserver observer = NavigationObserver(
        logger,
        analyticsService,
        enabled: enabled,
      );
      return (observer, logger, analyticsService);
    }

    test(
      'logs navigation push, pop, replace, and remove events when enabled',
      () {
        final (
          NavigationObserver observer,
          FakeLogger logger,
          FakeAnalyticsService analyticsService,
        ) = createObserver(
          enabled: true,
        );

        observer
          ..didPush(routeA, null)
          ..didPop(routeA, null)
          ..didReplace(newRoute: routeB, oldRoute: routeA)
          ..didRemove(routeB, routeA);

        expect(logger.logs, <String>[
          navInfo('Push: $routeAName'),
          navInfo('Pop: $routeAName'),
          navInfo('Replace: $routeAName -> $routeBName'),
          navInfo('Remove: $routeBName'),
        ]);

        expect(analyticsService.screens, <String>[routeAName, routeBName]);
      },
    );

    test('logs tab route navigation events when enabled', () {
      final (
        NavigationObserver observer,
        FakeLogger logger,
        FakeAnalyticsService analyticsService,
      ) = createObserver(
        enabled: true,
      );

      final _FakeTabPageRoute tabA = _FakeTabPageRoute(tabAName);
      final _FakeTabPageRoute tabB = _FakeTabPageRoute(tabBName);

      observer
        ..didInitTabRoute(tabA, null)
        ..didChangeTabRoute(tabB, tabA);

      expect(logger.logs, <String>[
        navInfo('InitTabRoute: $tabAName'),
        navInfo('ChangeTabRoute: $tabAName -> $tabBName'),
      ]);

      expect(analyticsService.screens, <String>[tabAName, tabBName]);
    });

    test('does not log events when disabled but tracks screens', () {
      final (
        NavigationObserver observer,
        FakeLogger logger,
        FakeAnalyticsService analyticsService,
      ) = createObserver();
      final _FakeTabPageRoute tabA = _FakeTabPageRoute(tabAName);

      observer
        ..didPush(routeA, null)
        ..didPop(routeA, null)
        ..didReplace(newRoute: routeB, oldRoute: routeA)
        ..didRemove(routeB, routeA)
        ..didInitTabRoute(tabA, null);

      expect(logger.logs, isEmpty);
      expect(analyticsService.screens, <String>[
        routeAName,
        routeBName,
        tabAName,
      ]);
    });
  });
}
