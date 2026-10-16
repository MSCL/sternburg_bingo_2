import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/logging/provider/logger_provider.dart';
import 'core/router/navigation_observer.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/provider/theme_provider.dart';
import 'i18n/strings.g.dart';

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
      (_) => FlutterNativeSplash.remove(),
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
            NavigationObserver(ref.watch(loggerProvider)),
          ],
        ),
  );
}
