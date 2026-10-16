import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import '../logging/logger.dart';

final class NavigationObserver extends AutoRouteObserver {
  new(this._logger, {this.enabled = false});

  final Logger _logger;
  final bool enabled;

  static const String _tag = 'Navigation';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (!enabled) {
      return;
    }
    _logger.info('Push: ${route.settings.name}', tag: _tag);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (!enabled) {
      return;
    }
    _logger.info('Pop: ${route.settings.name}', tag: _tag);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (!enabled) {
      return;
    }
    _logger.info(
      'Replace: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}',
      tag: _tag,
    );
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
    if (!enabled) {
      return;
    }
    _logger.info('InitTabRoute: ${route.name}', tag: _tag);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    if (!enabled) {
      return;
    }
    _logger.info(
      'ChangeTabRoute: ${previousRoute.name} -> ${route.name}',
      tag: _tag,
    );
  }
}
