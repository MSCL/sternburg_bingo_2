import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/i18n/strings.g.dart';
import '../../../core/notifications/push_notification_provider.dart';
import '../../../core/router/router.gr.dart';
import '../../../core/splash/splash_provider.dart';

@RoutePage()
final class DashboardScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

final class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashServiceProvider).remove();
      unawaited(_requestNotificationPermission());
    });
  }

  Future<void> _requestNotificationPermission() async {
    final bool updated = await ref
        .read(pushNotificationServiceProvider)
        .requestPermission();
    if (mounted && updated) {
      ref.invalidate(isNotificationPermissionGrantedProvider);
    }
  }

  @override
  Widget build(BuildContext context) => AutoTabsScaffold(
    routes: const <PageRouteInfo<Object?>>[BingoRoute(), SettingsRoute()],
    bottomNavigationBuilder: (BuildContext _, TabsRouter tabsRouter) =>
        NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.grid_on_outlined),
              selectedIcon: const Icon(Icons.grid_on),
              label: context.t.navigationBingo,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: context.t.navigationSettings,
            ),
          ],
        ),
  );
}
