/// Contract for analytics and event tracking services across the application.
///
/// ### Facade & Orchestration Pattern:
/// This interface serves as a facade isolating feature code from specific
/// tracking vendors (e.g. Firebase Analytics).
///
/// **Future Extension:** If additional analytics or telemetry providers are
/// added (e.g. Mixpanel, PostHog, or custom server logging), create a composite
/// implementation (e.g. `CompositeAnalyticsService`) behind this facade to
/// orchestrate multiple tracking backends in parallel without affecting callers
/// .
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
