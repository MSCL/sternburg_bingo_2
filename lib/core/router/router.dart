import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.gr.dart';

@AutoRouterConfig()
final class Router extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.material(enablePredictiveBackGesture: true);

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(
      page: DashboardRoute.page,
      path: '/',
      children: <AutoRoute>[
        AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),
  ];
}

final Provider<Router> routerProvider = Provider<Router>((_) => Router());
