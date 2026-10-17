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
      initial: true,
      children: <AutoRoute>[
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
  ];
}

final Provider<Router> routerProvider = Provider<Router>((_) => Router());
