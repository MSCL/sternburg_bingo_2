import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/analytics/analytics_provider.dart';
import 'core/analytics/analytics_service.dart';
import 'core/analytics/firebase_analytics_service.dart';
import 'core/feature_flags/feature_flag_provider.dart';
import 'core/feature_flags/feature_flag_service.dart';
import 'core/feature_flags/firebase_feature_flag_service.dart';
import 'core/logging/logger.dart';
import 'core/logging/logger_provider.dart';
import 'core/logging/sentry_logger.dart';
import 'core/provider/riverpod_observer.dart';
import 'core/storage/local_storage.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // also via env
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

  final List<Object> init = await Future.wait(<Future<Object>>[
    SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    ),
    LocaleSettings.useDeviceLocale(),
    Firebase.initializeApp(),
  ]);

  final LocalStorage localStorage = SharedPreferencesLocalStorage(
    init[0] as SharedPreferencesWithCache,
  );
  final FirebaseApp app = init[2] as FirebaseApp;

  final AnalyticsService analyticsService = FirebaseAnalyticsService(app);
  final FeatureFlagService featureFlagService = FirebaseFeatureFlagService(
    app,
    logger,
  );
  await featureFlagService.initialize();

  runApp(
    TranslationProvider(
      child: ProviderScope(
        observers: const <ProviderObserver>[RiverpodObserver(logger)],
        overrides: <Override>[
          loggerProvider.overrideWithValue(logger),
          analyticsServiceProvider.overrideWithValue(analyticsService),
          featureFlagServiceProvider.overrideWithValue(featureFlagService),
          localStorageProvider.overrideWithValue(localStorage),
        ],
        child: const App(),
      ),
    ),
  );
}
