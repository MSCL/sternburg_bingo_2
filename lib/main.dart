import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
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

  const Logger logger = kDebugMode ? ConsoleLogger() : SentryLogger();

  // disable when using SentryLogger
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logger.error(
      'Uncaught Flutter framework error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
      tag: 'FlutterError',
    );
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    logger.error(
      'Uncaught asynchronous error',
      error: error,
      stackTrace: stack,
      tag: 'PlatformError',
    );
    return true;
  };

  // create custom error widget
  // ErrorWidget.builder = (details) => Material();

  final List<Object> init = await Future.wait(<Future<Object>>[
    SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    ),
    LocaleSettings.useDeviceLocale(),
  ]);

  runApp(
    TranslationProvider(
      child: ProviderScope(
        observers: const <ProviderObserver>[RiverpodObserver(logger)],
        overrides: <Override>[
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
