import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/logging/logger.dart';
import 'core/logging/provider/logger_provider.dart';
import 'core/logging/sentry_logger.dart';
import 'core/provider/riverpod_observer.dart';
import 'core/storage/local_storage.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const logger = kDebugMode ? ConsoleLogger() : SentryLogger();

  // disable when using SentryLogger
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.error(
      'Uncaught Flutter framework error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
      tag: 'FlutterError',
    );
  };

  // TODO fix lints here
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error(
      'Uncaught asynchronous error: $error',
      error: error,
      stackTrace: stack,
      tag: 'PlatformError',
    );
    return true;
  };

  // create custom error widget
  // ErrorWidget.builder = (details) => Material();

  final init = await Future.wait([
    SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    ),
    LocaleSettings.useDeviceLocale(),
  ]);

  runApp(
    TranslationProvider(
      child: ProviderScope(
        observers: const [RiverpodObserver(logger)],
        overrides: [
          loggerProvider.overrideWithValue(logger),
          localStorageProvider.overrideWithValue(
            SharedPreferencesLocalStorage(
              init.first as SharedPreferencesWithCache,
            ),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}
