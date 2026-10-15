import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/logging/app_logger.dart';
import 'core/logging/provider/app_logger_provider.dart';
import 'core/logging/sentry_app_logger.dart';
import 'core/provider/riverpod_observer.dart';
import 'core/storage/local_storage.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const logger = kDebugMode ? ConsoleAppLogger() : SentryAppLogger();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.error(
      'Uncaught Flutter framework error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
      tag: 'FlutterError',
    );
  };

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
          appLoggerProvider.overrideWithValue(logger),
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
