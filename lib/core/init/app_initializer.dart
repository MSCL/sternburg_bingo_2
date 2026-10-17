// Static initialization facade class.
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';
import '../analytics/analytics_provider.dart';
import '../analytics/analytics_service.dart';
import '../analytics/firebase_analytics_service.dart';
import '../feature_flags/feature_flag_provider.dart';
import '../feature_flags/feature_flag_service.dart';
import '../feature_flags/firebase_feature_flag_service.dart';
import '../i18n/strings.g.dart';
import '../logging/logger.dart';
import '../logging/logger_provider.dart';
import '../logging/sentry_logger.dart';
import '../notifications/firebase_push_notification_service.dart';
import '../notifications/push_notification_provider.dart';
import '../notifications/push_notification_service.dart';
import '../splash/splash_provider.dart';
import '../splash/splash_service.dart';
import '../storage/local_storage.dart';

/// Holds initialized core services and converts them to Riverpod overrides.
final class AppDependencies {
  const new({
    required this.logger,
    required this.analyticsService,
    required this.featureFlagService,
    required this.pushNotificationService,
    required this.localStorage,
    required this.splashService,
  });

  final Logger logger;
  final AnalyticsService analyticsService;
  final FeatureFlagService featureFlagService;
  final PushNotificationService pushNotificationService;
  final LocalStorage localStorage;
  final SplashService splashService;

  List<Override> toProviderOverrides() => <Override>[
    loggerProvider.overrideWithValue(logger),
    analyticsServiceProvider.overrideWithValue(analyticsService),
    featureFlagServiceProvider.overrideWithValue(featureFlagService),
    pushNotificationServiceProvider.overrideWithValue(pushNotificationService),
    localStorageProvider.overrideWithValue(localStorage),
    splashServiceProvider.overrideWithValue(splashService),
  ];
}

abstract final class AppInitializer {
  /// Initializes application services.
  ///
  /// Synchronous dependencies ([splashService], [logger]) have non-nullable
  /// default values. Asynchronous services ([localStorage], [analyticsService],
  /// [featureFlagService], [pushNotificationService]) are initialized
  /// automatically if omitted.
  static Future<AppDependencies> initialize({
    SplashService splashService = const FlutterNativeSplashService(),
    Logger logger = kDebugMode ? const ConsoleLogger() : const SentryLogger(),
    LocalStorage? localStorage,
    AnalyticsService? analyticsService,
    FeatureFlagService? featureFlagService,
    PushNotificationService? pushNotificationService,
  }) async {
    final WidgetsBinding widgetsBinding =
        WidgetsFlutterBinding.ensureInitialized();
    splashService.preserve(widgetsBinding: widgetsBinding);

    _setupErrorHandling(logger);

    final (
      LocalStorage resolvedLocalStorage,
      _,
      (
        AnalyticsService resolvedAnalytics,
        FeatureFlagService resolvedFeatureFlags,
        PushNotificationService resolvedPushNotifications,
      ),
    ) = await (
      localStorage != null
          ? Future<LocalStorage>.value(localStorage)
          : _initLocalStorage(),
      LocaleSettings.useDeviceLocale(),
      _initFirebaseGroup(
        analyticsService: analyticsService,
        featureFlagService: featureFlagService,
        pushNotificationService: pushNotificationService,
        logger: logger,
      ),
    ).wait;

    return AppDependencies(
      logger: logger,
      analyticsService: resolvedAnalytics,
      featureFlagService: resolvedFeatureFlags,
      pushNotificationService: resolvedPushNotifications,
      localStorage: resolvedLocalStorage,
      splashService: splashService,
    );
  }

  static void _setupErrorHandling(Logger logger) {
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
  }

  static Future<LocalStorage> _initLocalStorage() async =>
      SharedPreferencesLocalStorage(
        await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(),
        ),
      );

  static Future<(AnalyticsService, FeatureFlagService, PushNotificationService)>
  _initFirebaseGroup({
    required AnalyticsService? analyticsService,
    required FeatureFlagService? featureFlagService,
    required PushNotificationService? pushNotificationService,
    required Logger logger,
  }) async {
    if (analyticsService != null &&
        featureFlagService != null &&
        pushNotificationService != null) {
      return (analyticsService, featureFlagService, pushNotificationService);
    }

    final FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return (
      analyticsService ?? FirebaseAnalyticsService(app),
      featureFlagService ?? await _initFeatureFlagService(app, logger),
      pushNotificationService ?? FirebasePushNotificationService(app, logger),
    );
  }

  static Future<FeatureFlagService> _initFeatureFlagService(
    FirebaseApp app,
    Logger logger,
  ) async {
    final FeatureFlagService featureFlagService = FirebaseFeatureFlagService(
      app,
      logger,
    );
    await featureFlagService.initialize();
    return featureFlagService;
  }
}
