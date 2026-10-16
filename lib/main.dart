import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/init/app_initializer.dart';
import 'core/provider/riverpod_observer.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  final AppDependencies dependencies = await AppInitializer.initialize();

  runApp(
    TranslationProvider(
      child: ProviderScope(
        observers: <ProviderObserver>[RiverpodObserver(dependencies.logger)],
        overrides: dependencies.toProviderOverrides(),
        child: const App(),
      ),
    ),
  );
}
