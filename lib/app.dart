import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/logging/provider/logger_provider.dart';
import 'core/router/navigation_observer.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/provider/theme_provider.dart';
import 'i18n/strings.g.dart';

final class App extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
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
          navigatorObservers: () => [
            NavigationObserver(ref.watch(loggerProvider)),
          ],
        ),
  );
}
