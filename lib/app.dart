import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/analytics/analytics_provider.dart';
import 'core/i18n/strings.g.dart';
import 'core/logging/logger_provider.dart';
import 'core/router/navigation_observer.dart';
import 'core/router/router.dart';
import 'core/splash/splash_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

final class App extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

final class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // could later also go into the first real home screen
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(splashServiceProvider).remove(),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: t.appName,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: ref.watch(themeModeProvider),
    locale: TranslationProvider.of(context).flutterLocale,
    supportedLocales: AppLocaleUtils.supportedLocales,
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    routerConfig: ref
        .watch(routerProvider)
        .config(
          navigatorObservers: () => <NavigatorObserver>[
            NavigationObserver(
              ref.watch(loggerProvider),
              ref.watch(analyticsServiceProvider),
            ),
          ],
        ),
  );
}
