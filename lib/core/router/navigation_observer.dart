import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import '../analytics/analytics_service.dart';
import '../logging/logger.dart';

final class NavigationObserver extends AutoRouteObserver {
  new(this._logger, this._analyticsService, {this.enabled = false});

  final Logger _logger;
  final AnalyticsService _analyticsService;
  final bool enabled;

  static const String _tag = 'Navigation';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final String? routeName = route.settings.name;
    if (routeName != null) {
      unawaited(_analyticsService.setCurrentScreen(routeName));
    }
    if (!enabled) {
      return;
    }
    _logger.info('Push: $routeName', tag: _tag);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final String? previousName = previousRoute?.settings.name;
    if (previousName != null) {
      unawaited(_analyticsService.setCurrentScreen(previousName));
    }
    if (!enabled) {
      return;
    }
    _logger.info('Pop: ${route.settings.name}', tag: _tag);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final String? newName = newRoute?.settings.name;
    if (newName != null) {
      unawaited(_analyticsService.setCurrentScreen(newName));
    }
    if (!enabled) {
      return;
    }
    _logger.info('Replace: ${oldRoute?.settings.name} -> $newName', tag: _tag);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (!enabled) {
      return;
    }
    _logger.info('Remove: ${route.settings.name}', tag: _tag);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    unawaited(_analyticsService.setCurrentScreen(route.name));
    if (!enabled) {
      return;
    }
    _logger.info('InitTabRoute: ${route.name}', tag: _tag);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    unawaited(_analyticsService.setCurrentScreen(route.name));
    if (!enabled) {
      return;
    }
    _logger.info(
      'ChangeTabRoute: ${previousRoute.name} -> ${route.name}',
      tag: _tag,
    );
  }
}
