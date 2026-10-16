import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import 'analytics_service.dart';

final class FirebaseAnalyticsService implements AnalyticsService {
  new(this.app) : _analytics = FirebaseAnalytics.instanceFor(app: app);

  final FirebaseApp app;
  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) => _analytics.logEvent(name: name, parameters: parameters);

  @override
  Future<void> setCurrentScreen(String screenName) =>
      _analytics.logScreenView(screenName: screenName);

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) => _analytics.setUserProperty(name: name, value: value);

  @override
  Future<void> setUserId(String? userId) => _analytics.setUserId(id: userId);

  @override
  Future<void> setAnalyticsCollectionEnabled({required bool enabled}) async {
    await app.setAutomaticDataCollectionEnabled(enabled);
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
