abstract interface class AnalyticsService {
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  Future<void> setCurrentScreen(String screenName);

  Future<void> setUserProperty({required String name, required String? value});

  Future<void> setUserId(String? userId);

  Future<void> setAnalyticsCollectionEnabled({required bool enabled});
}
