import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.gr.dart';

@AutoRouterConfig()
final class Router extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.material(enablePredictiveBackGesture: true);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
  ];
}

final routerProvider = Provider<Router>((ref) => Router());
