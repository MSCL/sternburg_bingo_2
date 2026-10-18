import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

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
        AutoRoute(page: BingoRoute.page, path: 'bingo', initial: true),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),
    CustomRoute<void>(
      page: BingoWinDialogRoute.page,
      path: '/bingo/winDialog',
      customRouteBuilder:
          <T>(BuildContext context, Widget child, AutoRoutePage<T> page) =>
              DialogRoute<T>(
                context: context,
                settings: page,
                builder: (_) => child,
              ),
    ),
  ];
}

final Provider<Router> routerProvider = Provider<Router>((_) => Router());
